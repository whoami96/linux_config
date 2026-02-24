-- ==========================================================
-- LEAN nvim v3.5 - Pawel Owczarczyk (Asseco Cloud)
-- NVIM v0.11.5+
-- ==========================================================

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
opt.updatetime = 300 -- Faster CursorHold (diagnostics float)

-- Diagnostics: float window, no virtual_text
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { silent = true, desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { silent = true, desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true, desc = "Diagnostics float" })

-- Auto-float on CursorHold, but only if there are diagnostics on the current line
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local pos = vim.api.nvim_win_get_cursor(0)
    local lnum = pos[1] - 1
    local diags = vim.diagnostic.get(0, { lnum = lnum })
    if #diags > 0 then
      vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
    end
  end,
})

-- 2) BOOTSTRAP LAZY.NVIM
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 2.1) PER-GIT-REPO: set cwd to repo root (Harpoon + sessions per repo)
local function get_git_root(startpath)
  local gitdir = vim.fs.find(".git", { path = startpath, upward = true })[1]
  if gitdir then
    return vim.fs.dirname(gitdir)
  end
  return nil
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local file = vim.api.nvim_buf_get_name(args.buf)
    if file == "" then
      return
    end
    local dir = vim.fs.dirname(file)
    if not dir or dir == "" then
      return
    end
    local root = get_git_root(dir)
    if root and root ~= "" and vim.fn.getcwd() ~= root then
      vim.api.nvim_set_current_dir(root)
    end
  end,
})

-- Helper: locate directory containing compile_commands.json (CMake)
local function find_compile_commands_dir(startpath)
  local candidates = {
    "build",
    "Build",
    "build-debug",
    "build-release",
    ".build",
    "cmake-build-debug",
    "cmake-build-release",
  }

  -- Common case: build dir inside project (search upward a bit)
  local dir = startpath
  for _ = 1, 10 do
    for _, c in ipairs(candidates) do
      local p = dir .. "/" .. c .. "/compile_commands.json"
      if uv.fs_stat(p) then
        return dir .. "/" .. c
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir or parent == "" then
      break
    end
    dir = parent
  end

  -- Fallback: compile_commands.json directly in some parent
  dir = startpath
  for _ = 1, 10 do
    local p = dir .. "/compile_commands.json"
    if uv.fs_stat(p) then
      return dir
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir or parent == "" then
      break
    end
    dir = parent
  end

  return nil
end

-- 3) PLUGINS
require("lazy").setup({
  -- UI & THEME
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nord")
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    end,
  },

  -- Ensure devicons are available for statusline/icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "nord", globalstatus = true } },
  },

  -- TREESITTER
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "vim",
        "regex",
        "bash",
        "python",
        "yaml",
        "json",
        "markdown",
        "markdown_inline",
        "dockerfile",
        "terraform",
        "hcl",
        "go",
        "gomod",
        "gosum",
        "rust",
        "c",
      },
      highlight = { enable = true },
    },
    config = function(_, opts)
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if not ok then
        vim.notify("nvim-treesitter is not available (not installed?)", vim.log.levels.WARN)
        return
      end
      ts.setup(opts)
    end,
  },

  -- NAVIGATION
  {
    "stevearc/oil.nvim",
    opts = { view_options = { show_hidden = true } },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Telescope (+ Harpoon extension)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = { file_ignore_patterns = { "%.git/" } },
        pickers = { find_files = { hidden = true } },
      })
      -- Harpoon ↔ Telescope: :Telescope harpoon marks
      pcall(telescope.load_extension, "harpoon")
    end,
  },

  -- Harpoon2 (auto-save + keymaps 1..9)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")

      harpoon:setup({
        settings = {
          save_on_toggle = true,   -- Save marks without requiring :w
          sync_on_ui_close = true, -- Also sync when closing UI
        },
      })

      -- Add / menu
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end, { desc = "Harpoon add file" })

      vim.keymap.set("n", "<leader>h", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon menu" })

      -- Jump 1..9
      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i, function()
          harpoon:list():select(i)
        end, { desc = "Harpoon to file " .. i })
      end

      -- Prev/Next
      vim.keymap.set("n", "<leader>[", function()
        harpoon:list():prev({ ui_nav_wrap = true })
      end, { desc = "Harpoon prev" })

      vim.keymap.set("n", "<leader>]", function()
        harpoon:list():next({ ui_nav_wrap = true })
      end, { desc = "Harpoon next" })

      -- Harpoon in Telescope
      vim.keymap.set("n", "<leader>fh", "<cmd>Telescope harpoon marks<cr>", { desc = "Harpoon marks (Telescope)" })
    end,
  },

  -- SESSIONS (restore per-cwd -> per git repo thanks to autocmd above)
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()

      local lspconfig = require("lspconfig")
      local mlsp = require("mason-lspconfig")

      local servers = {
        "ansiblels",
        "terraformls",
        "yamlls",
        "pyright",
        "lua_ls",
        "gopls",
        "rust_analyzer",
        "clangd",
      }

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local function on_attach(_, bufnr)
        local bopts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bopts)
      end

      local server_opts = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              staticcheck = true,
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
            },
          },
        },

        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              procMacro = { enable = true },
            },
          },
        },

        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=iwyu",
            "--pch-storage=memory",
          },
          on_new_config = function(new_config, new_root_dir)
            local ccdir = find_compile_commands_dir(new_root_dir)
            if ccdir then
              new_config.init_options = new_config.init_options or {}
              new_config.init_options.compilationDatabasePath = ccdir
            end
          end,
        },
      }

      local function setup_server(server_name)
        local opts = server_opts[server_name] or {}
        opts.capabilities = capabilities
        opts.on_attach = on_attach
        lspconfig[server_name].setup(opts)
      end

      -- Modern mason-lspconfig v2+ approach: single setup path (no setup_handlers fallback)
      mlsp.setup({
        ensure_installed = servers,
        handlers = {
          function(server_name)
            setup_server(server_name)
          end,
        },
      })
    end,
  },

  -- AUTOCOMPLETE
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources(
          { { name = "nvim_lsp" }, { name = "luasnip" } },
          { { name = "buffer" } }
        ),
      })
    end,
  },
}, {
  performance = { rtp = { disabled_plugins = { "netrw", "netrwPlugin", "tutor" } } },
})

-- 4) KEYMAPS (yours)
local map = vim.keymap.set
map("n", "-", "<CMD>Oil<CR>")
map("n", "<leader>w", "<cmd>w<cr>")
map("i", "jk", "<Esc>")
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")

-- Sessions (persistence.nvim)
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").load()
end, { desc = "Restore session" })

vim.keymap.set("n", "<leader>ql", function()
  require("persistence").load({ last = true })
end, { desc = "Restore last session" })

vim.keymap.set("n", "<leader>qd", function()
  require("persistence").stop()
end, { desc = "Stop session saving" })

-- Ansible filetype detection
vim.filetype.add({
  pattern = {
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*%.ya?ml"] = "yaml.ansible",
    ["site%.ya?ml"] = "yaml.ansible",
  },
})

-- Use YAML Treesitter parser for Ansible YAML filetype
vim.treesitter.language.register("yaml", "yaml.ansible")

-- Format on save (LSP)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    pcall(vim.lsp.buf.format, { async = false })
  end,
})
