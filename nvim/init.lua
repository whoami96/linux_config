-- ==========================================================
-- Neovim init.lua — WhoAmI (Paweł Owczarczyk <pawel@owczarczyk.it>)
-- Version: 1.4.1
-- Date: 24.08.2025
-- Description: Personal Neovim configuration (Nord, LSP, Treesitter,
-- Telescope, Git, Neo-tree, ToggleTerm, Harpoon, etc.)
-- ==========================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.scrolloff = 8
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.hidden = true
vim.opt.confirm = true
pcall(function() vim.opt.fillchars:append({ diff = "╱" }) end)

-- NVIM 0.10 shim (for plugins still calling buf_get_clients)
if vim.lsp and vim.lsp.get_clients and vim.lsp.buf_get_clients then
  vim.lsp.buf_get_clients = function(bufnr) return vim.lsp.get_clients({ bufnr = bufnr }) end
end

-- ===== Base keymaps + Safe buffer close (never quits Neovim) =====
local map = vim.keymap.set

local function close_buffer_safely()
  local cur = vim.api.nvim_get_current_buf()
  local bt  = vim.bo[cur].buftype
  local ft  = vim.bo[cur].filetype

  if bt ~= "" or ft == "alpha" or ft == "dashboard" or ft == "neo-tree" then
    vim.cmd("enew")
    return
  end

  if vim.bo[cur].modified then
    vim.cmd("confirm bdelete")
    return
  end

  local alt = vim.fn.bufnr("#")
  local listed = vim.fn.getbufinfo({ buflisted = 1 })

  if alt > 0 and vim.fn.buflisted(alt) == 1 then
    vim.cmd("buffer #")
  elseif #listed > 1 then
    vim.cmd("bnext")
  else
    vim.cmd("enew")
  end

  if vim.api.nvim_buf_is_valid(cur) then
    vim.cmd("silent! bdelete " .. cur)
  end
end

map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", close_buffer_safely, { desc = "Close current file (buffer) safely", noremap = true, silent = true })
map("n", "<leader>bd", close_buffer_safely,
  { desc = "Close current file (buffer) safely", noremap = true, silent = true })
map("n", "<leader>tq", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>Q", "<cmd>qa<CR>", { desc = "Quit Neovim" })

-- Disable <leader>q in special UIs so it cannot trigger their 'q' quits
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "alpha", "dashboard", "neo-tree" },
  callback = function(args)
    vim.keymap.set("n", "<leader>q", "<Nop>", { buffer = args.buf, silent = true })
  end,
})

-- Keep <C-l> free in terminals: disable default tmux-navigator mappings
vim.g.tmux_navigator_no_mappings = 1

-- ===== lazy.nvim bootstrap =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Nord + transparent bg
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("nord")
      for _, g in ipairs({ "Normal", "NormalNC", "NormalFloat", "SignColumn", "FloatBorder" }) do
        pcall(vim.api.nvim_set_hl, 0, g, { bg = "none" })
      end
    end
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { theme = "nord", globalstatus = true, section_separators = "", component_separators = "" },
      sections = {
        lualine_a = { { "mode", icon = "" } },
        lualine_b = { { "branch", icon = "" }, "diff" },
        lualine_c = { { "filename", path = 1, symbols = { modified = " ", readonly = " " } } },
        lualine_x = { { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } } },
        lualine_y = { { "filetype", icon_only = true }, "encoding", "fileformat" },
        lualine_z = { { "location", icon = "" } },
      },
    }
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({ options = { diagnostics = "nvim_lsp", separator_style = "thin" } })
      map("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
      map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
      map("n", "<leader>bd", close_buffer_safely, { desc = "Close buffer safely" })
    end,
  },

  { "folke/which-key.nvim",        event = "VeryLazy", opts = {} },

  -- Notify / Noice / Dressing
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local ok, notify = pcall(require, "notify")
      if ok then
        notify.setup({ stages = "fade", timeout = 1500, background_colour = "#000000" })
        vim.notify = notify
      end
    end,
  },
  { "stevearc/dressing.nvim",  event = "VeryLazy",    opts = {} },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = { progress = { enabled = true }, signature = { enabled = true }, hover = { enabled = true } },
      presets = { command_palette = true, long_message_to_split = true, lsp_doc_border = true },
    },
  },

  -- Editing / Git QoL
  { "lewis6991/gitsigns.nvim", event = "BufReadPre",  opts = {} },
  { "numToStr/Comment.nvim",   event = "VeryLazy",    opts = {} },
  { "kylechui/nvim-surround",  event = "VeryLazy",    opts = {} },
  { "windwp/nvim-autopairs",   event = "InsertEnter", opts = {} },

  -- Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      { "<leader>t", function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) end, desc = "File Tree" },
      { "<C-n>",     function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() }) end, desc = "File Tree" },
    },
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      filesystem = {
        filtered_items = { hide_dotfiles = false, hide_gitignored = false },
        follow_current_file = { enabled = true },
      },
      default_component_configs = {
        icon = { folder_closed = "", folder_open = "", folder_empty = "󰜌" },
      },
    },
  },

  -- ToggleTerm
  {
    "akinsho/toggleterm.nvim",
    keys = {
      { [[<C-\>]],    mode = { "n", "t" }, desc = "Toggle terminal (float)" },
      { "<leader>tt", mode = "n",          desc = "Terminal horizontal" },
      { "<leader>tv", mode = "n",          desc = "Terminal vertical" },
      { "<leader>tf", mode = "n",          desc = "Terminal float" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = { border = "rounded" },
      shade_terminals = false,
      start_in_insert = true,
    },
    config = function(_, opts)
      local toggleterm = require("toggleterm")
      toggleterm.setup(opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], { desc = "Terminal → Normal" })
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Terminal → Normal" })
      local Terminal = require("toggleterm.terminal").Terminal
      local term_h = Terminal:new({ direction = "horizontal" })
      vim.keymap.set("n", "<leader>tt", function() term_h:toggle() end, { desc = "Terminal horizontal" })
      local term_v = Terminal:new({ direction = "vertical" })
      vim.keymap.set("n", "<leader>tv", function() term_v:toggle() end, { desc = "Terminal vertical" })
      local term_f = Terminal:new({ direction = "float" })
      vim.keymap.set("n", "<leader>tf", function() term_f:toggle() end, { desc = "Terminal float" })
    end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon"); harpoon:setup()
      map("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon add" })
      map("n", "<leader>m", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
      for i = 1, 4 do map("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon " .. i }) end
    end
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    opts = { scope = { enabled = false }, exclude = { filetypes = { "alpha", "dashboard", "lazy", "mason", "help", "gitcommit" } } },
  },

  -- Symbols outline
  { "simrat39/symbols-outline.nvim", cmd = { "SymbolsOutline", "SymbolsOutlineOpen" },                 opts = {} },

  -- Git helpers
  { "kdheepak/lazygit.nvim",         cmd = "LazyGit" },
  { "sindrets/diffview.nvim",        cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" }, opts = {} },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Live grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,  desc = "Help" },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "-uu" },
      }
    }
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua", "bash", "python", "json", "yaml", "toml", "markdown", "markdown_inline", "gitignore", "regex",
        "terraform", "hcl", "dockerfile", "helm",
        "rust", "go", "c", "cpp", "javascript", "typescript",
      },
      highlight        = { enable = true },
      indent           = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end
  },

  -- LSP
  { "williamboman/mason.nvim",        config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "terraformls", "helm_ls", "yamlls", "dockerls", "docker_compose_language_service",
        "rust_analyzer", "pyright", "bashls", "jsonls", "taplo", "marksman",
        "clangd", "ts_ls", "lua_ls", "ansiblels",
      }
    }
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local lsp = require("lspconfig")
      local on_attach = function(_, bufnr)
        local buf = function(m, lhs, rhs, d) vim.keymap.set(m, lhs, rhs, { buffer = bufnr, desc = d }) end
        buf("n", "gd", vim.lsp.buf.definition, "Go to def")
        buf("n", "gr", vim.lsp.buf.references, "References")
        buf("n", "K", vim.lsp.buf.hover, "Hover")
        buf("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        buf("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
        buf("n", "<leader>fd", function() vim.diagnostic.open_float() end, "Diag float")
        buf("n", "[d", vim.diagnostic.goto_prev, "Prev diag")
        buf("n", "]d", vim.diagnostic.goto_next, "Next diag")
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = {
        lua_ls = { settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } } },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
              schemas = {
                kubernetes                                            = { "/*.yml", "/*.yaml", "**/k8s/**.yaml", "**/manifests/**.yaml" },
                ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
                ["https://json.schemastore.org/github-action.json"]   = ".github/actions/*",
                ["https://json.schemastore.org/kustomization.json"]   = "kustomization.{yml,yaml}",
                ["https://json.schemastore.org/chart.json"]           = "Chart.{yml,yaml}",
              },
              format = { enable = false },
            },
          },
        },
        ts_ls = {
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
          end
        },
        clangd = { cmd = { "clangd", "--background-index", "--clang-tidy" } },
        docker_compose_language_service = {},
      }
      for name, cfg in pairs(servers) do
        lsp[name].setup(vim.tbl_deep_extend("force", { on_attach = on_attach, capabilities = capabilities }, cfg))
      end
      for _, name in ipairs({
        "bashls", "pyright", "jsonls", "dockerls", "terraformls",
        "rust_analyzer", "helm_ls", "ansiblels", "taplo",
        "marksman", "clangd", "ts_ls", "docker_compose_language_service",
      }) do
        if not servers[name] then lsp[name].setup({ on_attach = on_attach, capabilities = capabilities }) end
      end
    end
  },

  -- Completion (FIX: use preset.insert, not preset(insert))
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip", "saadparwaiz1/cmp_luasnip", "rafamadriz/friendly-snippets"
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"]     = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
          ["<S-Tab>"]   = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end,
        }),
        sources = { { name = "nvim_lsp" }, { name = "luasnip" }, { name = "path" }, { name = "buffer" } },
        formatting = {
          format = function(_, item)
            local icons = {
              Text = "󰉿",
              Method = "󰊕",
              Function = "󰊕",
              Constructor = "",
              Field = "󰜢",
              Variable = "󰀫",
              Class = "󰠱",
              Interface = "",
              Module = "",
              Property = "󰜢",
              Unit = "",
              Value = "󰎠",
              Enum = "",
              Keyword = "󰌋",
              Snippet = "",
              Color = "󰏘",
              File = "󰈙",
              Reference = "󰈇",
              Folder = "󰉋",
              EnumMember = "",
              Constant = "󰏿",
              Struct = "󰙅",
              Event = "",
              Operator = "󰆕",
              TypeParameter = ""
            }
            item.kind = (icons[item.kind] or "") .. " " .. item.kind
            return item
          end
        }
      })
    end
  },

  -- Conform + Lint
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufReadPost" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        yaml = { "yamlfmt", "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        rust = { "rustfmt" },
        toml = { "taplo" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        c = { "clang_format" },
        cpp = { "clang_format" },
      },
      format_on_save = { timeout_ms = 2000, lsp_fallback = true },
    }
  },
  {
    "mfussenegger/nvim-lint",
    event = "BufWritePost",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        yaml = { "yamllint" },
        dockerfile = { "hadolint" },
        terraform = { "tflint" },
        ansible = { "ansible_lint" },
        python = { "ruff" },
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      }
      vim.api.nvim_create_autocmd("BufWritePost", { callback = function() require("lint").try_lint() end })
    end
  },

  -- Projects
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({})
      pcall(function() require("telescope").load_extension("projects") end)
      map("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Projects" })
    end
  },

  -- Dashboard (only when starting without files)
  {
    "goolord/alpha-nvim",
    cond = function() return vim.fn.argc() == 0 end,
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      dashboard.section.header.val = {
        "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "████╗  ██║██║   ██║██║████╗ ████║",
        "██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
      }
      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find File", ":Telescope find_files<CR>"),
        dashboard.button("r", "  Recent Files", ":Telescope oldfiles<CR>"),
        dashboard.button("p", "  Projects", ":Telescope projects<CR>"),
        dashboard.button("t", "  Terminal", ":ToggleTerm<CR>"),
        dashboard.button("u", "  Update Plugins", ":Lazy sync<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }
      alpha.setup(dashboard.opts)
    end
  },

  -- tmux navigator
  { "christoomey/vim-tmux-navigator", lazy = false },

  -- DevOps helpers
  {
    "ramilito/kubectl.nvim",
    version = "2.*",
    dependencies = { "saghen/blink.download" },
    cmd = { "Kubectl", "Kubectx" },
    opts = { kubectl_cmd = { cmd = "kubectl", env = {}, args = {}, persist_context_change = false } },
  },

  -- Ansible
  { "pearofducks/ansible-vim", ft = { "yaml", "yml", "ansible" } },

}, {
  ui = { icons = { plugin = "" } },
  performance = {
    rtp = { disabled_plugins = { "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" } },
  },
})

-- ===== Extra UX =====
map('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>')
map('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>')
map('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>')
map('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>')

-- Neo-tree focus toggle (SPC e)
local function toggle_focus_neotree()
  local current = vim.api.nvim_get_current_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if ft == "neo-tree" then
      if win ~= current then
        vim.api.nvim_set_current_win(win)
      else
        vim.cmd("wincmd p")
      end
      return
    end
  end
  pcall(function() require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd(), reveal = true }) end)
end
map("n", "<leader>e", toggle_focus_neotree, { desc = "Neo-tree ↔ Editor (focus toggle)" })

-- Terminal windows: cleaner UI
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
  end,
})

-- Final enforcement of leader mappings (in case any plugin remaps later)
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    pcall(vim.keymap.del, "n", "<leader>q")
    pcall(vim.keymap.del, "n", "<leader>Q")
    vim.keymap.set("n", "<leader>q", close_buffer_safely,
      { desc = "Close current file (buffer) safely", noremap = true, silent = true })
    vim.keymap.set("n", "<leader>Q", "<cmd>qa<CR>",
      { desc = "Quit Neovim", noremap = true, silent = true })
  end,
})
