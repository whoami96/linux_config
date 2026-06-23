# ==========================================================
# Oh My Zsh Theme — whoami-fino
# Author: Paweł Owczarczyk <pawel@owczarczyk.it>
# Version: 1.6.1 (Fixed prompt spacing, clean)
# ==========================================================

function virtualenv_info {
    local env_name=""
    local pyenv_env=""

    # 1. pyenv
    if type pyenv &>/dev/null; then
        pyenv_env=$(pyenv version-name 2>/dev/null)
        if [[ -n "$pyenv_env" && "$pyenv_env" != "system" ]]; then
            env_name="$pyenv_env"
        fi
    fi

    # 2. virtualenv / uv
    if [[ -z "$env_name" && -n "$VIRTUAL_ENV" ]]; then
        env_name=$(basename "$VIRTUAL_ENV")
        if [[ "$env_name" == ".venv" ]]; then
            env_name=$(basename "$(dirname "$VIRTUAL_ENV")")
        fi
    fi

    # 3. Conda fallback
    if [[ -z "$env_name" && -n "$CONDA_DEFAULT_ENV" ]]; then
        env_name="$CONDA_DEFAULT_ENV"
    fi

    # Hide python segment if it's an OpenStack deployment venv
    if [[ -n "$OS_CLOUD" && "$env_name" == "openstack" ]]; then
        return
    fi

    if [[ -n "$env_name" ]]; then
        echo "(%{$FG[178]%}%{$reset_color%}|%{$FG[178]%}${env_name}%{$reset_color%}) "
    fi
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '⠠⠵' && return
    echo '○'
}

function box_name {
  local box="${SHORT_HOST:-$HOST}"
  [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
  echo "${box:gs/%/%%}"
}

function os_cloud_info {
    [[ -n $OS_CLOUD ]] && echo "(%{$fg[red]%}%{$reset_color%}|%{$fg[blue]%}$OS_CLOUD%{$reset_color%}) "
}

function distrobox_info {
    if [[ -n "$CONTAINER_ID" ]]; then
        local box_name=""
        if [[ -f /run/.containerenv ]]; then
            box_name=$(grep -oP 'name="\K[^"\s]+' /run/.containerenv 2>/dev/null)
        fi
        [[ -z "$box_name" ]] && box_name="$CONTAINER_ID"
        echo "(%{$FG[099]%}󰏖%{$reset_color%}|%{$FG[099]%}${box_name}%{$reset_color%}) "
    fi
}

# Two-line prompt definition (with guaranteed space before username)
PROMPT="╭─ \$(virtualenv_info)\$(os_cloud_info)\$(distrobox_info)%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}\$(git_prompt_info)\$(ruby_prompt_info) %D - %*
╰─$(prompt_char) "

# Git prompt formatting
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘✘✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"

# Ruby prompt formatting
ZSH_THEME_RUBY_PROMPT_PREFIX=" %{$FG[239]%}using%{$FG[243]%} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"