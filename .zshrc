# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export DISPLAY=:0

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# User configuration

alias zshconfig="hx ~/.zshrc"
alias rf="ruff $1 --config ~/ruff.toml"
alias pip="python -m pip"
alias ipython="python -m IPython"
alias isort="python -m isort --profile black"
alias setup-poetry-env="poetry env use $(which 'python'$(cat ~/.config/python_version))"

export PYTHONSTARTUP="$HOME/.pythonrc.py"
export GPG_TTY=$(tty)

export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

use() {
    echo "$1" > ~/.config/python_version
}

python() {
    local version=$(<~/.config/python_version)
    if [ $version = "3.11" ]; then
        version="3"
    fi
    "python$version" "$@"
}

# Created by `pipx` on 2023-06-14 12:07:35
export PATH="$PATH:/Users/trag1c/.local/bin"
