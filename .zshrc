PS1="%B%F{4}[%F{3}%n%F{8}@%F{6}%M %F{5}%~%F{4}]%f%b %(?.%F{2}.%F{1})❯%f "

EDITOR=vim

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zshhistory
setopt appendhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.

export XDG_CONFIG_HOME=$HOME/.config

alias vim=nvim

bindkey -s ^f "tmux-sessionizer\n"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export GOPATH=$HOME/.local/go

addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ ! -z "$2" ]] || [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

addToPathFront $HOME/.zig
addToPathFront $HOME/.local/.npm-global/bin
addToPathFront $HOME/.local/odin
addToPathFront $HOME/.local/apps
addToPathFront $HOME/.local/scripts
addToPathFront $HOME/.local/bin
addToPathFront $HOME/.local/npm/bin
addToPathFront $HOME/.local/n/bin/
addToPathFront $HOME/.local/apps/

addToPathFront $HOME/.local/go/bin
addToPathFront /usr/local/go/bin
addToPathFront $HOME/.deno/bin
addToPath $HOME/.cargo/bin
addToPath $HOME/.sst/bin
addToPath $HOME/.npm-global/bin

export PATH="/home/overlord/.stripe/bin:$PATH"

# opencode
export PATH=/home/overlord/.opencode/bin:$PATH
