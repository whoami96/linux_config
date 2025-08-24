# 🐧 Linux Config — WhoAmI

Personal dotfiles and configurations for daily Linux workflow.  
Optimized for **DevOps, Kubernetes, Neovim, and modern CLI tooling**,  
with a consistent **Nord-inspired look & feel** across all terminals and editors.

---

## 📦 Contents

- [alacritty/](./alacritty/README.md) — Alacritty terminal config  
- [ghostty/](./ghostty/README.md) — Ghostty terminal config  
- [kitty/](./kitty/README.md) — Kitty terminal config  
- [logiops/](./logiops/README.md) — Logitech MX Master 3 (LogiOps) config  
- [nvim/](./nvim/README.md) — Neovim (Lua + lazy.nvim) config  
- [oh-my-zsh/](./oh-my-zsh/README.md) — Zsh + Oh My Zsh with custom theme  
- [tmux/](./tmux/README.md) — Tmux (TPM, Nord theme) config  
- [vim/](./vim/README.md) — Vim (vim-plug + darkzen) config  

> Each subdirectory includes its own README with detailed setup.

---


## ✨ Highlights

- **Terminals:** Alacritty, Ghostty, Kitty with unified keymaps & Nord vibe  
- **Shell:** Zsh + OMZ, plugins (fzf, zoxide, direnv, pyenv, kubectl), custom theme `whoami-fino-time`  
- **Editors:** Neovim (LSP, Treesitter, Telescope, Harpoon, Conform/Lint) and classic Vim (NERDTree, airline, syntastic)  
- **Multiplexer:** tmux with Wayland clipboard, session auto save/restore (resurrect + continuum)  
- **Devices:** LogiOps for MX Master 3 (gestures, SmartShift, DPI, thumb wheel)

## 🚀 Setup

Clone this repo and symlink the configs you need. Example:

```bash
git https://github.com/whoami96/linux_config.git ~/linux_config

# Example: symlink tmux + zsh
ln -sf ~/linux_config/tmux/tmux.conf ~/.tmux.conf
ln -sf ~/linux_config/oh-my-zsh/zshrc ~/.zshrc
ln -sf ~/linux_config/oh-my-zsh/whoami-fino-time.zsh-theme ~/.oh-my-zsh/themes/whoami-fino-time.zsh-theme

# Example: symlink nvim
ln -sf ~/linux_config/nvim ~/.config/nvim
```

Each subdirectory has its own README.md with detailed setup instructions.

---

## 🔗 Related
- [Nord Theme](https://www.nordtheme.com/)
- [Neovim](https://neovim.io/)
- [tmux](https://github.com/tmux/tmux)
- [Oh My Zsh](https://ohmyz.sh/)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [direnv](https://direnv.net/)

---

## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs

---