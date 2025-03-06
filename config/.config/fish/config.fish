if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias vim="nvim"
 
set fish_greeting ""
 
eval "$(/opt/homebrew/bin/brew shellenv)"
 
bind --preset \cC 'cancel-commandline'
 
if type -q nvm
  function __nvm_auto --on-variable PWD
  end
  __nvm_auto
end
 
if type -q pyenv
  status --is-interactive; and source (pyenv init -|psub)
end
 
if type -q bat
  abbr --add -g cat 'bat'
end
 
if type -q trash
  abbr --add -g rm 'trash'
end

function fish_prompt
    set -l pointer_color red
    test $status = 0; and set pointer_color yellow
 
    set -q __fish_git_prompt_showupstream
    or set -g __fish_git_prompt_showupstream auto
 
    if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end
 
    set_color yellow
    printf '%s' $USER
    set_color normal
    printf ' in '
 
    set_color $fish_color_cwd
    printf '%s' (prompt_pwd --dir-length=0)
    set_color normal
 
    # git
    set_color white -d
    set -l prompt_git (fish_git_prompt '%s')
    test -n "$prompt_git"
    and printf ' %s' $prompt_git
    set_color normal
 
    # Line 2
    echo
    set_color $pointer_color
    printf '» '
    set_color normal
end

function fish
  source ~/.config/fish/config.fish
end

