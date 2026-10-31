# Git branch in prompt, with staged (+) / unstaged (*) markers.
autoload -Uz vcs_info add-zsh-hook
add-zsh-hook precmd vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' formats ' %F{8}(%F{5}%b%F{2}%c%F{3}%u%F{8})%f'
zstyle ':vcs_info:git:*' actionformats ' %F{8}(%F{5}%b%F{8}|%F{1}%a%F{2}%c%F{3}%u%F{8})%f'

PS1='%F{5}%~${vcs_info_msg_0_}%F{4}%f%b %(?.%F{2}.%F{1})❯%f '

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
