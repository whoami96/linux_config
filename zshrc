# export
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
export PATH=$HOME/.cargo/env:$PATH
export SHELL=/usr/bin/zsh
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"
export GOPATH=$HOME/.go
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# config
ZSH_THEME="fino-custom"
CASE_SENSITIVE="false"
DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="false"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# ohmyzsh
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
eval "$(pyenv init --path)"

#plugins
plugins=(git git-prompt zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting dnf fzf kubectl-autocomplete vscode zsh-interactive-cd pyenv azure-cli rust k3d)

# aliases
alias "kubectl=kubecolor"
alias "k=kubectl"
alias "kubectx=kubie ctx"
alias "kubens=kubie ns"
alias "s=ssh"
alias "op=openstack"
alias "yz=yazi"
alias "logir=sudo systemctl restart logid.service"
alias openv='pyenv activate openstack && export OS_CLOUD=$({ yq e ".clouds | keys | sort | .[]" ~/.config/openstack/clouds.yaml | { [ -n "$OS_CLOUD" ] && echo "$OS_CLOUD"; [ -n "$OS_CLOUD" ] && grep -v "^$OS_CLOUD$" || cat; }; } | fzf)'
alias opexit='pyenv deactivate openstack && unset OS_CLOUD'

# source
source $ZSH/oh-my-zsh.sh

# kubectl
source <(kubectl completion zsh)
alias "kubectl=kubecolor"
compdef kubecolor=kubectl

# startup cmd
fastfetch -c /home/whoami/.fastfetch/presets/examples/12.jsonc

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/vault vault
complete -o nospace -C /usr/bin/terraform terraform
complete -C '/usr/local/bin/aws_completer' aws

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

complete -o nospace -C /usr/bin/tofu tofu