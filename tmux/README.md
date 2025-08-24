# 🔲 Tmux Config — WhoAmI

Personal [tmux](https://github.com/tmux/tmux) configuration (tested on **Fedora 42, tmux 3.5a**).  
Designed for productivity with **Nord theme**, **Vim-style copy mode**, Wayland clipboard, and session persistence via `tmux-resurrect`.

---

## ✨ Features

- **Prefix**
  - Default: `Ctrl-b`
  - Secondary: `Ctrl-a`

- **UI / Theme**
  - Nord colorscheme (statusline, borders, activity)
  - Statusline with:
    - Session name
    - Workdir
    - User + Host (or `~/.box-name`)
    - Date + Time
  - Pane borders highlighted in Nord palette

- **Navigation & QoL**
  - Mouse mode enabled
  - History: `50k` lines
  - Vim-style keybindings in copy-mode
  - Synchronize panes with `prefix + s`
  - Reload config with `prefix + r`
  - Pane resizing with `H J K L`

- **Splits**
  - `prefix + |` → vertical split
  - `prefix + -` → horizontal split

- **Copy-mode**
  - Vi keys
  - `v` → begin selection
  - `y` → copy to system clipboard (Wayland via `wl-copy`)
  - `/`, `?`, `n`, `N` → search like Vim

- **Statusline**
  - Left: ` <session>`
  - Right: ` <cwd> |  <user> |  <host> | <date> <time>`

- **Plugins (via TPM)**
  - `tmux-plugins/tpm` — plugin manager
  - `tmux-plugins/tmux-prefix-highlight`
  - `tmux-plugins/tmux-yank`
  - `tmux-plugins/tmux-open`
  - `Morantron/tmux-fingers`
  - `christoomey/vim-tmux-navigator`

- **Session Persistence**
  - [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) + [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum)
  - Auto-save every 10 minutes
  - Restore sessions automatically on tmux start
  - Manual bindings:
    - `prefix + C-s` / `prefix + S` → save session
    - `prefix + C-r` / `prefix + R` → restore session

---

## 📂 Structure

```bash
linux_config/tmux
├── README.md
└── tmux.conf
```

---

## 🚀 Installation

1. Install tmux:
   ```bash
   sudo dnf install tmux
   # or
   sudo apt install tmux
   ```
2. Clone this repo:
   ```bash
   git clone https://github.com/whoami96/linux_config.git ~/linux-config
   ```
3. Copy files:
   ```bash
   cp ~/linux-config/tmux/tmux.conf ~/.tmux.conf
   ```
4. Install TPM (Tmux Plugin Manager):
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
   ```
5. Start tmux and install plugins:
   ```bash
   tmux
   # then hit: prefix + I (capital i)
   ```
---

## 🔑 Keybindings Quick Ref

- **Splits:** ``<prefix> |`` vertical, ``<prefix> -`` horizontal  
- **Resize:** ``<prefix> H J K L``  
- **Copy-mode:** ``v`` select, ``y`` copy → wl-copy  
- **Session:** ``<prefix> Tab`` → last window  
- **Save/Restore:** ``<prefix> S`` save, ``<prefix> R`` restore  
- **Reload config:** ``<prefix> r``  


---

## 🔗 Related
- [tmux](https://github.com/tmux/tmux)
- [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect)
- [Nord Theme](https://www.nordtheme.com/)

---

## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs

---