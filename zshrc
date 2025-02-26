# export
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/env:$PATH
export SHELL=/usr/bin/zsh
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"
export GOPATH=$HOME/.go
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PODMAN_COMPOSE_QUIET=1
export PODMAN_COMPOSE_EXE=podman-compose

# config
ZSH_THEME="fino-custom"
CASE_SENSITIVE="false"
DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# ohmyzsh
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

# kube-ps1
RPROMPT='$(kube_ps1)'$PROMPT # or RPROMPT='$(kube_ps1)'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init --path)"

#plugins
plugins=(git git-prompt zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting docker docker-compose dnf fzf minikube vscode kube-ps1 zsh-interactive-cd pyenv)

# aliases
alias "kubectl=kubecolor"
alias "k=kubectl"
alias "kubectx=kubectl ctx"
alias "kubens=kubectl ns"
alias "s=ssh"
alias "op=openstack"
alias "code=codium"
alias "yz=yazi"
alias "logir=sudo systemctl restart logid.service"

# source omz
source $ZSH/oh-my-zsh.sh

# kubectl
source <(kubectl completion zsh)
alias "kubectl=kubecolor"
alias "kubectx=kubectl ctx"
alias "kubens=kubectl ns"
compdef kubecolor=kubectl

# startup cmd
fastfetch -c /home/whoami/.fastfetch/presets/examples/12.jsonc

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault
complete -o nospace -C /usr/bin/terraform terraform
complete -C '/usr/local/bin/aws_completer' aws