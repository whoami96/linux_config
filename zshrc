# export
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/env:$PATH
export ZSH="$HOME/.oh-my-zsh"
export LANG=pl_PL.UTF-8
export EDITOR="vim"

# config
ZSH_THEME="fino-my"
CASE_SENSITIVE="false"
DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# ohmyzsh
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

#plugins
plugins=(git git-prompt zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting docker docker-compose brew fzf minikube vscode autoswitch_virtualenv kube-ps1)

# aliases
alias "python=python3.12"
alias "pip=pip3"
alias "kubectl=kubecolor"

# source omz
source $ZSH/oh-my-zsh.sh

# startup cmd
fastfetch -c /Users/whoami/.fastfetch/presets/examples/12.jsonc
