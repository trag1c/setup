export PYTHONSTARTUP="$HOME/.pythonrc.py"
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"
export GPG_TTY=$(tty)
export EDITOR=hx

alias hxconfig="hx ~/.config/helix/config.toml"
alias zshconfig="hx ~/.zshrc"

alias cp="cp -vi"
alias l="ls -lah"
alias ls="ls -G"
alias md="mkdir -p"
alias mv="mv -vi"
alias rd="rmdir"
alias rm="rm -v"

alias neofetch="fastfetch"
alias python="uv run python"
alias rust="evcxr"
alias uvhx="uv run hx"

alias ga="git add"
alias gb="git branch"
alias gbd="git branch --delete"
alias gc="git commit -S --verbose"
alias gcb="git checkout -b"
alias gco="git checkout"
alias gd="git diff"
alias gl="git pull"
alias glog="git log --oneline --decorate --graph"
alias gp="git push"
alias grh="git reset --hard"
alias gst="git status"

function mkcd
{
  dir="$*";
  mkdir -p "$dir" && cd "$dir";
}

function c() {
    open -a "/Applications/Visual Studio Code.app" $@
}

export PATH="$PATH:/Users/trag1c/.local/bin:/Users/trag1c/dev/bin"

. "$HOME/.cargo/env"

autoload -U compinit
compinit

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

eval "$(atuin init zsh)"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
