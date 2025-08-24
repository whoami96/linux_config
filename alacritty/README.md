# 🖥️ Alacritty Configuration

Personal **Alacritty** setup for Linux (Fedora).  
Designed for productivity, minimalism and seamless integration with **tmux**.

---

## ✨ Features

- 🔄 **Live config reload** (changes apply instantly on save)
- 🪟 **Starts tmux automatically** and attaches to session `main`
- 🖋️ **Vi mode** navigation in scrollback (`Ctrl+Shift+Space`)
- 🔗 **URL hints overlay** (`Ctrl+Shift+O`, opens in `xdg-open`)
- 📋 **Clipboard integration**
  - Copy: `Ctrl+Shift+C`
  - Paste: `Ctrl+Shift+V`
  - Middle click paste (primary selection)
- 🔍 **Scrollback search**
  - Forward: `Ctrl+Shift+F`
  - Backward: `Ctrl+Shift+B`
- 🖼️ **Window**
  - Fixed initial size `105x35`
  - Dark decorations theme
  - Opacity `0.88`
- ⌨️ **Font**
  - `FiraCode Nerd Font` at size **11**
  - Full Nerd Font support for icons and ligatures
- 📏 **Font size control**
  - Increase: `Ctrl+=`, `Ctrl++`, `Ctrl+Numpad+`
  - Decrease: `Ctrl+-`, `Ctrl+Numpad-`
  - Reset: `Ctrl+0`
- 🖱️ **Mouse**
  - Auto-hide cursor while typing
  - Middle click → paste
- 🖥️ **Fullscreen toggle**: `F11`
- 📜 **Scrollback history**: 50,000 lines

---

## 📂 File location

Place the configuration file at:

```bash
~/.config/alacritty/alacritty.toml
```
---

## 🚀 Quick Start

Install Alacritty:

```bash
sudo dnf install alacritty   # Fedora
```

Install FiraCode Nerd Font:

```bash
sudo dnf install fira-code-fonts
# or download from Nerd Fonts release page
```

Copy config:

```bash
mkdir -p ~/.config/alacritty
cp alacritty.toml ~/.config/alacritty/

```

Start Alacritty – it will automatically open tmux and attach to session main.

---

## 🛠️ Dependencies

- [Alacritty](https://alacritty.org/config-alacritty.html)
- [Tmux](https://github.com/tmux/tmux/wiki)
- [Nerd Font](https://www.nerdfonts.com/)

## 📜 License
MIT — feel free to use and modify.

---

## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs

---
