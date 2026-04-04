# ==========================================================
# Oh My Zsh Theme — whoami-fino
# Author: Paweł Owczarczyk <pawel@owczarczyk.it>
# Version: 1.1 (Fixed OpenStack Redundancy)
# ==========================================================

# Show active Python environment (pyenv > conda > virtualenv)
function virtualenv_info {
    local env_name=""
    local pyenv_env=""

    # 1. pyenv active?
    if type pyenv &>/dev/null; then
        pyenv_env=$(pyenv version-name 2>/dev/null)
        if [[ -n "$pyenv_env" && "$pyenv_env" != "system" ]]; then
            env_name="$pyenv_env"
        fi
    fi

    # 2. plain virtualenv/uv active? (if no pyenv or pyenv is system)
    if [[ -z "$env_name" && -n "$VIRTUAL_ENV" ]]; then
        env_name=$(basename "$VIRTUAL_ENV")
        # Jeśli uv stworzył folder .venv, pokaż nazwę katalogu projektu
        if [[ "$env_name" == ".venv" ]]; then
            env_name=$(basename "$(dirname "$VIRTUAL_ENV")")
        fi
    fi

    # 3. Conda (fallback)
    if [[ -z "$env_name" && -n "$CONDA_DEFAULT_ENV" ]]; then
        env_name="$CONDA_DEFAULT_ENV"
    fi

    # --- LOGIKA UKRYWANIA DLA OPENSTACK ---
    # Jeśli nazwa env to "openstack" i mamy aktywne OS_CLOUD, nie pokazujemy tego segmentu
    if [[ -n "$OS_CLOUD" && "$env_name" == "openstack" ]]; then
        return
    fi

    # Wyświetlanie, jeśli coś znaleziono
    if [[ -n "$env_name" ]]; then
        echo "(\033[38;5;178m\ue73c\033[0m|$env_name) "
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

# Two-line prompt
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
