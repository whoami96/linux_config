-- ==========================================================
-- LEAN nvim v3.6 - Pawel Owczarczyk (Asseco Cloud)
-- NVIM v0.11.5+ | Optimized for Cloud Engineering
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

-- Auto-float on CursorHold for diagnostics under cursor
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

-- 2.1) PER-GIT-REPO: Auto-set CWD to repo root
local function get_git_root(startpath)
  local gitdir = vim.fs.find(".git", { path = startpath, upward = true })[1]
  if gitdir then
    return vim.fs.dirname(gitdir)
  end
  return nil
end

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then return end
    local file = vim.api.nvim_buf_get_name(args.buf)
    if file == "" then return end
    local dir = vim.fs.dirname(file)
    if not dir or dir == "" then return end
    local root = get_git_root(dir)
    if root and root ~= "" and vim.fn.getcwd() ~= root then
      vim.api.nvim_set_current_dir(root)
    end
  end,
})

-- Helper: locate directory containing compile_commands.json
local function find_compile_commands_dir(startpath)
  local candidates = {
    "build", "Build", "build-debug", "build-release", ".build",
    "cmake-build-debug", "cmake-build-release",
  }
  local dir = startpath
  for _ = 1, 10 do
    for _, c in ipairs(candidates) do
      local p = dir .. "/" .. c .. "/compile_commands.json"
      if uv.fs_stat(p) then return dir .. "/" .. c end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir or parent == "" then break end
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
        "lua", "vim", "regex", "bash", "python", "yaml", "json",
        "markdown", "markdown_inline", "dockerfile", "terraform",
        "hcl", "go", "gomod", "gosum", "rust", "c",
      },
      highlight = { enable = true },
    },
    config = function(_, opts)
      local ok, ts = pcall(require, "nvim-treesitter.configs")
      if ok then ts.setup(opts) end
    end,
  },

  -- NAVIGATION
  {
    "stevearc/oil.nvim",
    opts = { view_options = { show_hidden = true } },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = { file_ignore_patterns = { "%.git/" } },
        pickers = { find_files = { hidden = true } },
      })
      pcall(telescope.load_extension, "harpoon")
    end,
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({ settings = { save_on_toggle = true, sync_on_ui_close = true } })
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon menu" })
      for i = 1, 9 do
        vim.keymap.set("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon to file " .. i })
      end
    end,
  },

  -- UTILITIES
  { "numToStr/Comment.nvim",       opts = {} }, -- gcc to comment line, gc to comment selection
  { "folke/todo-comments.nvim",    dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
  { "folke/persistence.nvim",      event = "BufReadPre",                       opts = {} },

  -- TERMINAL (Floating)
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-\>]],
        direction = 'float',
        float_opts = { border = 'curved', winblend = 3 },
      })
    end
  },

  -- GIT INTEGRATION (Signs & Blame)
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = { add = { text = '┃' }, change = { text = '┃' }, delete = { text = '_' } },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function bmap(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end
        bmap('n', ']c', function() gs.next_hunk() end, "Next Git change")
        bmap('n', '[c', function() gs.prev_hunk() end, "Prev Git change")
        bmap('n', '<leader>gp', gs.preview_hunk, "Preview Git hunk")
        bmap('n', '<leader>gb', function() gs.blame_line { full = true } end, "Git blame line")
        bmap('n', '<leader>gr', gs.reset_hunk, "Reset Git hunk")
      end
    }
  },

  -- LSP CONFIGURATION
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("mason").setup()
      local lspconfig = require("lspconfig")
      local mlsp = require("mason-lspconfig")
      local servers = { "ansiblels", "terraformls", "yamlls", "pyright", "lua_ls", "gopls", "rust_analyzer", "clangd" }
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local bopts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bopts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bopts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bopts)
      end

      mlsp.setup({
        ensure_installed = servers,
        handlers = {
          function(server_name)
            local opts = { capabilities = capabilities, on_attach = on_attach }
            -- Ansible special mapping
            if server_name == "ansiblels" then opts.filetypes = { "yaml.ansible", "ansible" } end
            -- Clangd CMake integration
            if server_name == "clangd" then
              opts.on_new_config = function(new_config, new_root_dir)
                local ccdir = find_compile_commands_dir(new_root_dir)
                if ccdir then
                  new_config.init_options = new_config.init_options or {}
                  new_config.init_options.compilationDatabasePath = ccdir
                end
              end
            end
            lspconfig[server_name].setup(opts)
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
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp
              .mapping.complete()
        }),
        sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "luasnip" } }, { { name = "buffer" } }),
      })
    end,
  },
}, { performance = { rtp = { disabled_plugins = { "netrw", "netrwPlugin", "tutor" } } } })

-- 4) KEYMAPS
local map = vim.keymap.set
map("n", "-", "<CMD>Oil<CR>")       -- Browse directories like text
map("n", "<leader>w", "<cmd>w<cr>") -- Save file
map("i", "jk", "<Esc>")             -- Fast escape

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })

-- ToggleTerm & LazyGit
map("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Terminal Floating" })
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
function _lazygit_toggle() lazygit:toggle() end

map("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", { desc = "LazyGit" })

-- Terminal shell keymaps (navigation & escape)
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Persistence / Sessions
map("n", "<leader>qs", function() require("persistence").load() end, { desc = "Restore session" })

-- Filetype detection (Ansible & OpenTofu)
vim.filetype.add({
  extension = { tofu = "terraform", tf = "terraform" },
  pattern = {
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.*%.ya?ml"] = "yaml.ansible",
    ["site%.ya?ml"] = "yaml.ansible"
  },
})
vim.treesitter.language.register("yaml", "yaml.ansible")

-- Format on save (LSP)
vim.api.nvim_create_autocmd("BufWritePre", { callback = function() pcall(vim.lsp.buf.format, { async = false }) end })
