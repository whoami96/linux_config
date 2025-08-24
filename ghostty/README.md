# Ghostty — Personal Configuration

Custom configuration for [Ghostty](https://ghostty.org) terminal emulator on Linux (Fedora).  
Optimized for productivity, with modern looks, ergonomic keybindings, and extended scrollback.

---

## ✨ Features

- **Font & Theme**
  - FiraCode Nerd Font, size 11
  - Adwaita Dark theme with 90% background opacity
  - Balanced window padding, subtle decorations

- **Ergonomics**
  - Blinking bar cursor
  - Mouse hides while typing
  - Click-to-move cursor
  - Clipboard trimming (no trailing spaces)
  - State auto-save (tabs, splits, positions)

- **Scrollback**
  - 1,000,000 lines

- **Startup**
  - Default shell: `zsh`
  - Working directory: `$HOME`
  - Shell integration enabled

- **Clipboard / UX**
  - Copy/Paste via `Ctrl+Shift+C` / `Ctrl+Shift+V`
  - Desktop notifications enabled

---

## ⌨️ Keybindings

### Tabs & Windows
- `Ctrl+T` — new tab  
- `Ctrl+[` / `Ctrl+]` — previous / next tab  
- `Ctrl+1...0` — switch to tab 1–10  
- `Ctrl+Shift+N` — new window  
- `Ctrl+Q` — close window  
- `Ctrl+Shift+Q` — close all windows  

### Splits
- `Ctrl+B` — split left  
- `Ctrl+M` — split right  
- `Ctrl+Shift+B` — split down  
- `Ctrl+Shift+M` — split up  
- `Alt+Shift+Arrows` — resize split by 10 cells  
- `Alt+Shift+A` — equalize all splits  

### Font & Config
- `Ctrl+Shift+R` — reset font size  
- `Ctrl+Shift+E` — reload config  

### Clipboard
- `Ctrl+Shift+C` — copy  
- `Ctrl+Shift+V` — paste  

### Inspector
- `Ctrl+H` — show inspector  
- `Ctrl+Shift+H` — hide inspector  

### Fullscreen & Quick Terminal
- `Ctrl+Enter` — toggle fullscreen  
- `Ctrl+K` (global) — toggle quick terminal  

---

## 📂 File location

On Linux (Fedora):

```bash
~/.config/ghostty/config
```
---

## 🔧 Requirements
- [Ghostty Docs](https://ghostty.org/docs) 

---

## 📝 License
This configuration is shared under the MIT License.
Feel free to adapt and modify for your own workflow.

---
## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs

---
