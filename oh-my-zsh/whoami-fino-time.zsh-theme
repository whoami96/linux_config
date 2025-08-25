# ==========================================================
# Oh My Zsh Theme — whoami-fino
# Author: Paweł Owczarczyk <pawel@owczarczyk.it>
# Version: 1.0
# Date: 24.08.2025
# Fork https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/fino-time.zsh-theme
# Description: Fino-time fork with OpenStack cloud context and
# pyenv/conda/virtualenv indicators. Requires a Nerd Font.
# ==========================================================

# Show active Python environment (pyenv > conda > virtualenv)
function virtualenv_info {
    # pyenv active?
    if type -p pyenv &>/dev/null; then
        local pyenv_env=$(pyenv version-name 2>/dev/null)
        if [[ -n "$pyenv_env" && "$pyenv_env" != "system" ]]; then
            # Python icon (darker yellow) + env name
            echo "(\033[38;5;178m\ue73c\033[0m|$pyenv_env) "
        fi
    fi

    # conda active?
    [ $CONDA_DEFAULT_ENV ] && echo "($CONDA_DEFAULT_ENV) "

    # plain virtualenv active (only if not using pyenv)
    if [ -n "$VIRTUAL_ENV" ] && [ -z "$pyenv_env" ]; then
        echo '('`basename $VIRTUAL_ENV`') '
    fi
}

# Prompt glyph depending on git status
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '⠠⠵' && return
    echo '○'
}

# Read custom box name from ~/.box-name if present; escape % for prompt
function box_name {
  local box="${SHORT_HOST:-$HOST}"
  [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
  echo "${box:gs/%/%%}"
}

# Show active OpenStack cloud (OS_CLOUD)
function os_cloud_info {
    [[ -n $OS_CLOUD ]] && echo "(%{$fg[red]%}%{$reset_color%}|%{$fg[blue]%}$OS_CLOUD%{$reset_color%}) "
}

# Two-line prompt (no kube_ps1)
PROMPT="╭─% \$(virtualenv_info)\$(os_cloud_info)%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}\$(git_prompt_info)\$(ruby_prompt_info) %D - %*
╰─$(prompt_char) "

# Git prompt
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘✘✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"

# Ruby prompt
ZSH_THEME_RUBY_PROMPT_PREFIX=" %{$FG[239]%}using%{$FG[243]%} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
