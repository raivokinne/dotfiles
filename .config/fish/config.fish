if status is-interactive
    bind \cf 'tmux-sessionizer; commandline -f repaint'
    bind \eh 'tmux-sessionizer -s 0; commandline -f repaint'
    bind \et 'tmux-sessionizer -s 1; commandline -f repaint'
    bind \en 'tmux-sessionizer -s 2; commandline -f repaint'
    bind \es 'tmux-sessionizer -s 3; commandline -f repaint'
end

fish_add_path ~/.local/share/rust-cargo/bin
fish_add_path ~/.local/bin
fish_add_path ~/.config/composer/vendor/bin
fish_add_path ~/go/bin

alias vim=nvim

# opencode
fish_add_path /home/overlord/.opencode/bin

set -g fish_cursor_default block
set -g fish_cursor_insert block
set -g fish_cursor_replace_one block
set -g fish_cursor_replace block
set -g fish_cursor_visual block
set -g fish_cursor_external block
