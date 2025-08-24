# 🐱 Kitty Terminal Config — WhoAmI

Personal configuration of [Kitty](https://sw.kovidgoyal.net/kitty/) terminal emulator, optimized for **Wayland** on Linux.  
The setup is designed to be clean, fast, and fully compatible with **Ghostty** and **Alacritty** keybindings.

---

## ✨ Features

- **Fonts**
  - FiraCode Nerd Font Mono (with ligatures and Powerline symbols included)
  - Preconfigured at `10.0 pt`

- **Cursor**
  - Beam shape
  - No blinking

- **Colors & Transparency**
  - Background opacity: `0.85`
  - Compatible with external theme file (`current-theme.conf`)

- **Window & Layout**
  - Centered window placement
  - Minimal borders with 5px padding
  - Initial window size: `800x600`
  - Support for **tabs** (custom separator-style bar)
  - Support for **splits** (horizontal & vertical with `Alt+b` / `Alt+Shift+b`)

- **Scrollback**
  - 5000 lines of history
  - Optional pager support (`less -R`)

- **Mouse**
  - Smart URL detection and opening
  - Copy on select
  - Custom pointer shapes
  - Configurable word characters (`@-./_~?&=%+#`)

- **Performance**
  - Low repaint/input delay
  - Monitor sync enabled

- **Keybindings**
  - Clipboard: `Ctrl+Shift+C / V`
  - Scrolling: `Ctrl+Up/Down`, `Ctrl+Shift+Up/Down`, etc.
  - Tabs: `Ctrl+T` new tab, `Ctrl+[ / ]` navigation, `Ctrl+1..0` quick access
  - Windows: `Ctrl+Shift+N` new window, `Ctrl+Q` close
  - Splits: `Alt+B` horizontal, `Alt+Shift+B` vertical
  - Misc: `Ctrl+Enter` fullscreen, `Ctrl+Shift+F` maximize, `Ctrl+K` clear to cursor

- **Advanced**
  - Zsh as default shell
  - Neovim as default editor
  - Shell integration enabled
  - Notifications for finished commands (if unfocused)

- **OS Tweaks**
  - X11 display server by default (`linux_display_server x11`)
  - Wayland IME support enabled
  - Window decorations enabled by default

---

## 📂 Structure

```bash
.config/kitty
├── kitty.conf
└── kitty-themes
    ├── CONTRIBUTING.md
    ├── LICENSE.md
    ├── README.md
    └── themes
```
---

## 🚀 Installation

1. Install Kitty (Fedora example):
   
```bash
sudo dnf install kitty
```
2. Clone this repo and symlink config:
```bash
git clone https://github.com/<your-username>/kitty-config.git ~/.config/kitty
```
3. Launch Kitty:
```bash
kitty
```
---

## 🎨 Theme
The config uses an external theme file:

- current-theme.conf — included at the end of kitty.conf

Keep multiple themes in repo and symlink/copy the one you want to use:
```bash
ln -sf ~/.config/kitty/themes/nord.conf ~/.config/kitty/current-theme.conf
```
---

## 🔗 Related

- [Kitty Docs](https://sw.kovidgoyal.net/kitty/)

---

## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs
---
