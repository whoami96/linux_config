# 🐚 Zsh Config — WhoAmI

Personal [Zsh](https://www.zsh.org/) configuration based on **Oh My Zsh**, with a custom theme `whoami-fino`.  
Designed for **DevOps workflows** (Kubernetes, OpenStack, Terraform, Pyenv, Rust, Azure CLI, etc.),  
with extra focus on **fzf**, **zoxide**, and modern CLI tooling.

---

## ✨ Features

- **Shell Framework**
  - [Oh My Zsh](https://ohmyz.sh/) with plugins
  - Custom theme: `whoami-fino` (fork of `fino-time`)
  - Two-line prompt with:
    - username + host (or custom `~/.box-name`)
    - working directory
    - Git branch + status
    - Active Python (pyenv / conda / virtualenv)
    - Active OpenStack cloud (`OS_CLOUD`)

- **Plugins**
  - `git`, `git-prompt`
  - `zsh-autosuggestions`
  - `fast-syntax-highlighting`
  - `zsh-interactive-cd`
  - `dnf`, `fzf`, `vscode`, `pyenv`, `azure-cli`, `rust`

- **Environment Support**
  - Cargo, Go, Krew
  - Pyenv
  - NVM (Node.js)
  - Direnv
  - Zoxide

- **History & Options**
  - Shared history across sessions
  - 200k entries saved
  - Smarter navigation with `AUTO_CD`, `AUTO_PUSHD`, `EXTENDED_GLOB`

- **fzf Integration**
  - Uses `fd` or `rg` as backend if available
  - Custom previews for `<Ctrl-R>` history search
  - Fuzzy cd (`zi`, `za` with zoxide)

- **Kubernetes**
  - Aliases: `k`, `kubectx`, `kubens`
  - `kubecolor` integration for colorful output
  - Autocompletion enabled

- **Aliases**
  - `s=ssh`, `op=openstack`
  - `yz=yazi` (file manager)
  - `logir` → restart logiops service
  - OpenStack helper: `openv` (select OS_CLOUD + pyenv activate), `opexit`

- **ls/eza & bat**
  - If `eza` is installed: colorful `ls`, `ll`, `la`
  - If `bat` is installed: man pages and pager with syntax highlight

- **Completions**
  - Vault, Terraform, AWS CLI, OpenTofu

- **Extras**
  - Fastfetch on shell start
  - Custom keybindings for word movement and deletion
  - Safe PATH exports for Cargo, Go, Pyenv, NVM

---

## 📂 Structure

```bash
linux_config/oh-my-zsh
├── fino-custom.zsh-theme
├── README.md
└── zshrc
```
---

## 🚀 Installation

1. Install Zsh & OMZ:
   ```bash
   sudo dnf install zsh git
   chsh -s /usr/bin/zsh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```
2. Clone repo:
   ```bash
   git clone https://github.com/whoami96/linux_config.git ~/linux_config
   ```
3. Copy files
   ```bash
   cp ~/linux_config/oh-my-zsh/zshrc ~/.zshrc
   cp ~/linux_config/oh-my-zsh/zshrc ~/.oh-my-zsh/themes/whoami-fino-time.zsh-theme
   ```
4. Reload shell:
   ```bash
   exec zsh
   ```
---
## 🎨 Theme (whoami-fino-time)

Two-line prompt example:
```bash
╭─ (pyenv|3.13.7) (|openstack) user at dev-box in ~/workspace on main ✔  2025-08-24 - 19:32
╰─⠠⠵
```

- Python virtualenv/pyenv/conda indicators

- Active OS_CLOUD (OpenStack context)

- Git branch + status (✔ clean / ✘✘✘ dirty)

- Ruby version if present

- Custom host name from ~/.box-name if available

- Requires a Nerd Font for icons.

---
## 🔗 Related
- [Oh My Zsh](https://ohmyz.sh/)
- [fzf](https://github.com/junegunn/fzf)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [direnv](https://direnv.net/)
- [kubecolor](https://github.com/hidetatz/kubecolor)
- [pyenv](https://github.com/pyenv/pyenv)

---
## 🧑 Author

WhoAmI (Paweł Owczarczyk)

Linux & DevOps Enthusiast — dotfiles and homelab configs

---