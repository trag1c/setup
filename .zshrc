# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="blazz"

plugins=(
    git
    poetry
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

export PYTHONSTARTUP="$HOME/.pythonrc.py"
export GPG_TTY=$(tty)

alias zshconfig="hx ~/.zshrc"
alias use="pyenv shell"
alias rust="evcxr"
alias ipython="python -m IPython"

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# pipx
export PATH="$PATH:/Users/trag1c/.local/bin"

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
