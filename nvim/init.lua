-- ==========================================================
-- Paweł Owczarczyk
-- Config for Neovim 0.12.x | Fedora 44
-- ==========================================================

-- 0) EARLY FILETYPE DETECTION
vim.filetype.add({
  extension = {
    tofu = "terraform",
    tf = "terraform",
    tfvars = "terraform-vars",
  },
  pattern = {
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*%.ya?ml"] = "yaml.ansible",
    ["docker-compose.*%.ya?ml"] = "yaml.docker-compose",
    ["gitlab-ci.*%.ya?ml"] = "yaml.gitlab",
  },
})

-- 1) GLOBAL OPTIONS
vim.g.mapleader = " "
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.clipboard = "unnamedplus"
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.termguicolors = true
opt.undofile = true
opt.cursorline = true
opt.updatetime = 300

vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  float = { border = "rounded" },
})

-- 2) BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- 3) PLUGINS
require("lazy").setup({
  -- UI & THEME
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nord")
      local hl_groups = { "Normal", "NormalFloat", "FloatBorder", "SignColumn", "LineNr", "CursorLineNr" }
      for _, group in ipairs(hl_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
      end
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "nord", globalstatus = true } } },

  -- TREESITTER (Hybrid Config for 0.11/0.12 compatibility)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ts_config = {
        ensure_installed = {
          "lua", "bash", "python", "yaml", "terraform", "hcl", "go", "rust", "dockerfile", "markdown", "markdown_inline"
        },
        highlight = { enable = true },
        indent = { enable = true },
      }

      -- Próba załadowania starego modułu, jeśli nie istnieje - użycie nowego
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if ok then
        configs.setup(ts_config)
      else
        require("nvim-treesitter").setup(ts_config)
      end
    end,
  },

  -- NAVIGATION
  { "stevearc/oil.nvim", opts = { view_options = { show_hidden = true } } },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup()
      telescope.load_extension("fzf")
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("harpoon"):setup() end
  },

  -- LSP & MASON
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
      local lspconfig = require("lspconfig")

      require("mason-lspconfig").setup({
        ensure_installed = { "ansiblels", "terraformls", "yamlls", "pyright", "lua_ls", "gopls", "ruff" },
        handlers = {
          function(server_name)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            if server_name == "terraformls" then
              lspconfig.terraformls.setup({
                capabilities = capabilities,
                filetypes = { "terraform", "terraform-vars", "hcl" },
              })
            elseif server_name == "pyright" then
              lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                  pyright = { disableOrganizeImports = true },
                  python = { analysis = { ignore = { '*' } } }
                }
              })
            else
              lspconfig[server_name].setup({ capabilities = capabilities })
            end
          end,
        },
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
          vim.lsp.buf.format({ async = false })
          vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
        end,
      })
    end,
  },

  -- AUTOCOMPLETE
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
      "saadparwaiz1/cmp_luasnip"
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({ ["<CR>"] = cmp.mapping.confirm({ select = true }) }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" } }),
      })
    end,
  },

  -- TOOLS
  { "akinsho/toggleterm.nvim", version = "*", opts = { direction = 'float', open_mapping = [[<C-\>]] } },
  { "lewis6991/gitsigns.nvim", opts = {} },
})

-- 4) KEYMAPS
local map = vim.keymap.set
map("n", "-", "<CMD>Oil<CR>")
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>w", "<cmd>w<cr>")
