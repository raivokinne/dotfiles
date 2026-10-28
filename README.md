# dotfiles

Personal configuration files, organized to mirror `$HOME`.

## Layout

```
.
├── .config/        # ~/.config (XDG configs)
│   ├── alacritty/
│   ├── btop/
│   ├── emacs/
│   ├── fish/
│   ├── ...
│   └── waybar/
├── .bash_profile   # ~/.bash_profile
├── .bashrc         # ~/.bashrc
├── .gitconfig      # ~/.gitconfig
├── .zshrc          # ~/.zshrc
├── dwl/            # dwl source/build
├── dwlmsg/         # dwlmsg source/build
├── dwm/            # dwm source/build
├── st/             # st source/build
└── install.sh
```

Application configs live under `.config/`, matching where they are read from at
runtime. Window manager and terminal sources (`dwl`, `dwlmsg`, `dwm`, `st`) stay
at the repository root because they are built and installed, not read from
`~/.config`.

## Install

```sh
./install.sh
```

The installer links each entry in `.config/` into `$XDG_CONFIG_HOME` (default:
`~/.config`), and links the root dotfiles (`.bash_profile`, `.bashrc`,
`.gitconfig`, `.zshrc`) into `$HOME`. Helper scripts are also linked into
`~/.local/bin`. If an app config directory already exists, matching files are
linked into it while unrelated or generated files stay in place. Any existing
file that would be replaced is moved to
`~/.local/state/dotfiles/backup/<timestamp>/` first, so running the script is
non-destructive.
