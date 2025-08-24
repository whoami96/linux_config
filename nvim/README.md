# ✨ Neovim Config — WhoAmI

Personal [Neovim](https://neovim.io/) configuration written in **Lua**, using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager.  
Optimized for **DevOps, Kubernetes, Terraform, and coding in multiple languages** (Rust, Python, Go, TypeScript, etc.).

---

## 📌 Highlights

- **UI / Theme**
  - Nord colorscheme with transparent background
  - Lualine statusline, Bufferline tabline
  - Alpha dashboard with shortcuts
  - Icons via `nvim-web-devicons`

- **Navigation**
  - Neo-tree file explorer with `<leader>e` focus toggle
  - Harpoon for quick file marks
  - Telescope (find files, live grep, buffers, help)

- **Editing QoL**
  - Comment.nvim, Surround, Autopairs
  - Indent guides (ibl)
  - Symbols outline (`<cmd>SymbolsOutline<CR>`)

- **Terminals**
  - ToggleTerm with horizontal, vertical, float splits
  - Keymaps:
    - `<C-\>` toggle float terminal
    - `<leader>tt` horizontal / `<leader>tv` vertical / `<leader>tf` float

- **Git**
  - Gitsigns
  - Diffview
  - LazyGit integration (`:LazyGit`)

- **Projects**
  - project.nvim with Telescope integration (`<leader>fp`)

- **LSP / Completion**
  - Mason + mason-lspconfig
  - Configured servers: Terraform, Helm, YAML, Docker, Rust, Python, Bash, JSON, Lua, TS/JS, C/C++, Ansible
  - nvim-cmp + luasnip + VSCode snippets
  - Inline LSP diagnostics + hover, rename, code actions

- **Formatting / Linting**
  - Conform.nvim (format on save)
  - nvim-lint (yamllint, hadolint, tflint, ruff, eslint_d, etc.)

- **DevOps helpers**
  - kubectl.nvim (`:Kubectl`, `:Kubectx`)
  - ansible-vim syntax

- **Tmux integration**
  - Seamless navigation with `<C-h/j/k/l>`

---

## 📂 Structure

```bash
.config/nvim
├── init.lua
└── lazy-lock.json
```
---

# 🚀 Installation

1. Install Neovim (≥ 0.10 recommended):
   ```bash
   sudo dnf install neovim
   ```
2. Clone repo into your config directory:
   ```bash
   git clone https://github.com/whoami96/linux_config.git ~/.linux-config/
   ```
3. Start Neovim:
   ```bash
   nvim
   ```
lazy.nvim will bootstrap and install all plugins automatically. 

---

## ⌨️ Keymaps

- **Save:** ``<leader>w``
- **Close buffer safely:** ``<leader>q`` / ``<leader>bd``
- **Quit Neovim:** ``<leader>Q``
- **Buffers:** ``<Tab>`` / ``<S-Tab>`` cycle
- **File tree:** ``<leader>e`` (focus toggle), ``<leader>t`` or ``<C-n>`` (toggle)
- **Telescope:** ``<leader>ff`` (files), ``<leader>fg`` (grep), ``<leader>fb`` (buffers), ``<leader>fh`` (help)
- **Harpoon:** ``<leader>a`` add, ``<leader>m`` menu, ``<leader>1..4`` jump
- **Terminals:** ``<C-\>`` toggle, ``<leader>tt/tv/tf``
- **LSP:** ``gd`` definition, ``gr`` references, ``K`` hover, ``<leader>rn`` rename, ``<leader>ca`` code action

---

## 🔗 Related
- [Neovim](https://neovim.io/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [Nord Theme](https://www.nordtheme.com/)

---

## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs
---