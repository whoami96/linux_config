-- ==========================================================
-- Paweł Owczarczyk
-- Config for Neovim 0.12.0 STABLE | Ubuntu 24.04
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
opt.rtp:prepend(vim.fn.stdpath("data") .. "/site")
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
      -- Przezroczyste tło pod Ghostty
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lualine/lualine.nvim", opts = { options = { theme = "nord", globalstatus = true } } },

  -- TREESITTER (Native 0.12.0 support)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "lua", "bash", "python", "yaml", "terraform", "hcl", "go", "rust", "dockerfile", "markdown", "markdown_inline"
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- NAVIGATION
  { "stevearc/oil.nvim", opts = { view_options = { show_hidden = true } } },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
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
        -- Dodajemy ruff do listy
        ensure_installed = { "ansiblels", "terraformls", "yamlls", "pyright", "lua_ls", "gopls", "ruff" },
        handlers = {
          function(server_name)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            
            -- Specyficzna konfiguracja dla Pyright, aby nie gryzł się z Ruffem
            if server_name == "pyright" then
              lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                  pyright = {
                    -- Używamy Ruffa do organizowania importów, więc wyłączamy to w Pyright
                    disableOrganizeImports = true,
                  },
                  python = {
                    analysis = { ignore = { '*' } }, -- Opcjonalnie: pozwól Ruffowi na diagnostykę
                  }
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
          -- Opcjonalnie: ruff organize imports
          vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
        end,
      })
    end,
  },

  -- AUTOCOMPLETE
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
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