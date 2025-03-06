ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "$ZINIT_HOME/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^h' history-search-backward
bindkey '^l' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Set the default editor
export EDITOR=nvim
export VISUAL=nvim
alias pico='edit'
alias spico='sedit'
alias nano='edit'
alias snano='sedit'
alias vim='nvim'
alias lvim='NVIM_APPNAME="LazyVim" nvim'
alias art="php artisan"
alias migrate="php artisan migrate"
alias seed="php artisan db:seed"
alias la="ls -la"
alias godot-server="~/.local/bin/godot-server"

# To have colors for ls and all grep commands such as grep, egrep and zgrep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'
#export GREP_OPTIONS='--color=auto' #deprecated

# Check if ripgrep is installed
if command -v rg &> /dev/null; then
    # Alias grep to rg if ripgrep is installed
    alias grep='rg'
else
    # Alias grep to /usr/bin/grep with GREP_OPTIONS if ripgrep is not installed
    alias grep="/usr/bin/grep $GREP_OPTIONS"
fi
unset GREP_OPTIONS

# Color for manpages in less makes manpages a little easier to read
export less_termcap_mb=$'\e[01;31m'
export less_termcap_md=$'\e[01;31m'
export less_termcap_me=$'\e[0m'
export less_termcap_se=$'\e[0m'
export less_termcap_so=$'\e[01;44;33m'
export less_termcap_ue=$'\e[0m'
export less_termcap_us=$'\e[01;32m'

#######################################################
# machine specific alias's
#######################################################

# alias's for ssh
# alias servername='ssh yourwebsite.com -l username -p portnumberhere'

# alias's to change the directory
alias web='cd /var/www/html'

# alias's to mount iso files
# mount -o loop /home/nameofiso.iso /home/isomountdir/
# umount /home/nameofiso.iso
# (both commands done as root only.)

#######################################################
# general alias's
#######################################################
# to temporarily bypass an alias, we precede the command with a \
# eg: the ls command is aliased, but to use the normal ls command you would type \ls
# add an "alert" alias for long running commands.  use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# edit this .bashrc file
alias ebrc='edit ~/.bashrc'

# show help for this .bashrc file
alias hlp='less ~/.bashrc_help'

# alias to show the date
alias da='date "+%y-%m-%d %a %t %z"'

# alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
# alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -r'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'
alias svi='sudo vi'
alias vis='nvim "+set si"'

# cd into the old directory
alias bd='cd "$oldpwd"'

# remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# alias's for multiple directory listing commands
alias ls="eza --icons --group-directories-first"

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -r 000'
alias 644='chmod -r 644'
alias 666='chmod -r 666'
alias 755='chmod -r 755'
alias 777='chmod -r 777'

# search command line history
alias h="history | grep "

# search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# search files in the current folder
alias f="find . | grep "

# count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# to see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# show open ports
alias openports='netstat -nape --inet'

# alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# alias's to show disk space and space used in a folder
alias diskspace="du -s | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -cahf --dirsfirst'
alias treed='tree -cafd'
alias mountedinfo='df -ht'

# alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# sha1
alias sha1='openssl sha1'

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

# kitty - alias to be able to use kitty features when connecting to remote servers(e.g use tmux on remote server)

alias kssh="kitty +kitten ssh"

# alias to cleanup unused docker containers, images, networks, and volumes

alias docker-clean=' \
  docker container prune -f ; \
  docker image prune -f ; \
  docker network prune -f ; \
  docker volume prune -f '

#######################################################
# special functions
#######################################################
# extracts any archive(s) (if unp isn't installed)
extract() {
	for archive in "$@"; do
		if [ -f "$archive" ]; then
			case $archive in
			*.tar.bz2) tar xvjf $archive ;;
			*.tar.gz) tar xvzf $archive ;;
			*.bz2) bunzip2 $archive ;;
			*.rar) rar x $archive ;;
			*.gz) gunzip $archive ;;
			*.tar) tar xvf $archive ;;
			*.tbz2) tar xvjf $archive ;;
			*.tgz) tar xvzf $archive ;;
			*.zip) unzip $archive ;;
			*.z) uncompress $archive ;;
			*.7z) 7z x $archive ;;
			*) echo "don't know how to extract '$archive'..." ;;
			esac
		else
			echo "'$archive' is not a valid file!"
		fi
	done
}

# searches for text in all files in the current folder
ftext() {
	# -i case-insensitive
	# -i ignore binary files
	# -h causes filename to be printed
	# -r recursive search
	# -n causes line number to be printed
	# optional: -f treat search term as a literal, not a regular expression
	# optional: -l only print filenames and not the matching lines ex. grep -irl "$1" *
	grep -iihrn --color=always "$1" . | less -r
}

# copy file with a progress bar
cpp() {
    set -e
    strace -q -ewrite cp -- "${1}" "${2}" 2>&1 |
    awk '{
        count += $nf
        if (count % 10 == 0) {
            percent = count / total_size * 100
            printf "%3d%% [", percent
            for (i=0;i<=percent;i++)
                printf "="
            printf ">"
            for (i=percent;i<100;i++)
                printf " "
            printf "]\r"
        }
    }
    end { print "" }' total_size="$(stat -c '%s' "${1}")" count=0
}

# copy and go to the directory
cpg() {
	if [ -d "$2" ]; then
		cp "$1" "$2" && cd "$2"
	else
		cp "$1" "$2"
	fi
}

proj_open_keybind() {
    zle push-line # Save the current command line stack
    BUFFER="~/.local/bin/tmux-sessionizer"
    zle accept-line # Execute the command
}

zle -N proj_open_keybind
bindkey '^f' proj_open_keybind

alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias nvim-rust="NVIM_APPNAME=Rust nvim"

# move and go to the directory
mvg() {
	if [ -d "$2" ]; then
		mv "$1" "$2" && cd "$2"
	else
		mv "$1" "$2"
	fi
}

# create and go to the directory
mkdirg() {
	mkdir -p "$1"
	cd "$1"
}

# goes up a specified number of directories  (i.e. up 4)
up()
{
	local d=""
	limit=$1
	for ((i = 1; i <= limit; i++)); do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

# automatically do an ls after each cd, z, or zoxide
cd ()
{
	if [ -n "$1" ]; then
		builtin cd "$@" && ls
	else
		builtin cd ~ && ls
	fi
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/.cargo/bin
export PATH="$PATH:$HOME/.composer/vendor/bin"

# bun completions
[ -s "/Users/raivokinne/.bun/_bun" ] && source "/Users/raivokinne/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Add Homebrew to PATH
export PATH="/usr/local/Homebrew/bin:$PATH"

# Additional PATH modifications
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/opt/homebrew/sbin"

# Go environment
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export GOBIN="$GOPATH/bin"
export PATH="$GOBIN:$PATH"

# Composer environment
export COMPOSER_HOME="$HOME/.composer"
export PATH="$COMPOSER_HOME/vendor/bin:$PATH"

# Rust environment
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

# Bun environment
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# .Net
export PATH="/usr/local/share/dotnet/:$PATH"

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"
# eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/zen.toml)"

export DYLD_LIBRARY_PATH="/usr/local/lib:$DYLD_LIBRARY_PATH"

# pnpm
export PNPM_HOME="/Users/raivokinne/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


# Herd injected PHP binary.
export PATH="/Users/raivokinne/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 8.2 configuration.
export HERD_PHP_82_INI_SCAN_DIR="/Users/raivokinne/Library/Application Support/Herd/config/php/82/"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

