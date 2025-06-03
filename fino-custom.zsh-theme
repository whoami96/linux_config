# Fork https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/fino-time.zsh-theme
# Fino-time zsh theme with support for openstack cloud context and pyenv context.
# Theme need supported Nerd Font.
#
# Function to show active Python virtual environment or Conda environment
function virtualenv_info {
    # Check if pyenv environment is active
    if type -p pyenv &>/dev/null; then
        local pyenv_env=$(pyenv version-name 2>/dev/null)
        if [[ -n "$pyenv_env" && "$pyenv_env" != "system" ]]; then
            # Add icon before pyenv environment name, with a darker yellow color for the icon
            echo "(\033[38;5;178m\ue73c\033[0m|$pyenv_env) "
        fi
    fi

    # Check if Conda environment is active
    [ $CONDA_DEFAULT_ENV ] && echo "($CONDA_DEFAULT_ENV) "

    # Check if a regular virtualenv is active (only if not using pyenv)
    if [ -n "$VIRTUAL_ENV" ] && [ -z "$pyenv_env" ]; then
        echo '('`basename $VIRTUAL_ENV`') '
    fi
}

# Function to show prompt character based on git status
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '⠠⠵' && return
    echo '○'
}

# Function to read box name (custom computer name) if defined
function box_name {
  local box="${SHORT_HOST:-$HOST}"
  [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
  echo "${box:gs/%/%%}"
}

# Function to display active OS_CLOUD value
function os_cloud_info {
    [[ -n $OS_CLOUD ]] && echo "(%{$fg[red]%}%{$reset_color%}|%{$fg[blue]%}$OS_CLOUD%{$reset_color%}) "
}

# Main prompt definition (without kube_ps1)
PROMPT="╭─% \$(virtualenv_info)\$(os_cloud_info)%{$FG[040]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}\$(git_prompt_info)\$(ruby_prompt_info) %D - %*
╰─$(prompt_char) "

# Git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%}✘✘✘"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%}✔"

# Ruby version prompt settings
ZSH_THEME_RUBY_PROMPT_PREFIX=" %{$FG[239]%}using%{$FG[243]%} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
