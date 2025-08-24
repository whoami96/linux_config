# ✍️ Vim Config — WhoAmI

Personal [Vim](https://www.vim.org/) configuration with a modernized but **classic feel**.  
Includes **fzf**, **NERDTree**, **airline**, **syntastic**, and the **darkzen** colorscheme.  
Designed for a transparent look that blends with the terminal theme.

---

## ✨ Features

- **Plugin Manager**
  - [vim-plug](https://github.com/junegunn/vim-plug) for easy plugin management

- **Plugins**
  - `vim-sensible` — sane defaults
  - `fzf` + `fzf.vim` — fuzzy search
  - `editorconfig-vim`
  - `vim-fugitive` — Git integration
  - `vim-surround` — text object editing
  - `syntastic` — syntax checking
  - `nerdcommenter` — easy commenting
  - `supertab` — tab-completion
  - `tabular` — text alignment
  - `vim-airline` + themes — status/tab line
  - `nerdtree` — file explorer
  - `vim-devicons` — icons (requires Nerd Font)
  - `nerdtree-visual-selection` — advanced selection
  - `vim-colorschemes` — including `darkzen`
  - `suda.vim` — read/write root-owned files with `:SudaWrite`

- **UI / Look & Feel**
  - Colorscheme: `darkzen`
  - Transparent background (respects terminal opacity/blur)
  - Airline statusline with tabline enabled
  - Nerdtree file explorer toggle with `<C-f>`
  - Popup menu: white-on-black

- **Editing**
  - Tabs = 4 spaces
  - Smart indentation
  - Search with `incsearch`, `ignorecase`, `smartcase`
  - Persistent command history (`1000` entries)
  - Wildmenu/wildmode completion

- **Syntastic**
  - Runs checks on file open and save
  - Loclist integration for quick navigation

- **QoL**
  - Mouse enabled in normal/replace mode
  - Scrolloff `10` lines
  - Autoclose NERDTree when last buffer
  - `w!!` → save as root via sudo

---

## 📂 Structure

```bash
linux_config/vim
├── README.md
└── vimrc
```
---
## 🚀 Installation

1. Install Vim (with Lua support recommended):
   ```bash
   sudo dnf install vim
   # or
   sudo apt install vim
   ```
2. Install [vim-plug](https://github.com/junegunn/vim-plug)
   ```bash
   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```
3. Clone repo and symlink config:
   ```bash
   git clone https://github.com/whoami96/linux_config.git ~/linux_config
   ```
4. Copy file:
   ```
   cp ~/linux_config/vim/vimrc ~/.vimrc
   ```
5. Open Vim and install plugins:
   ```bash
   :PlugInstall
   ```
---

## ⌨️ Keybindings

- NERDTree: <C-f> toggle / find file

- Save as root: :w!!

- Airline: statusline + tabline enabled by default

---

## 🔗 Related
- [VIM](https://www.vim.org/)
- [vim-plug](https://github.com/junegunn/vim-plug)
- [fzf](https://github.com/junegunn/fzf)
- [NERDTree](https://github.com/preservim/nerdtree)
- [vim-airline](https://github.com/vim-airline/vim-airline)

---

## ## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs

---