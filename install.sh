#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_ROOT="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/backup/$(date +%Y%m%d-%H%M%S)"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '\033[1;32m  ->\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m %s\n' "$*"; }

usage() {
	cat <<EOF
Usage: $0 [--help]

Symlink this repository into \$HOME. Existing files are moved to
$BACKUP_ROOT instead of being overwritten.

  ~/.config/<app>     -> <repo>/.config/<app>
  ~/.<shell-config>   -> <repo>/.<shell-config>

If an app config directory already exists, matching files are linked into it
and unrelated or generated files are left in place.
EOF
}

case "${1:-}" in
	-h|--help) usage; exit 0 ;;
	"") ;;
	*) printf 'Unknown option: %s\n' "$1" >&2; exit 1 ;;
esac

link_file() {
	local src="$1" dest="$2"
	local relative backup

	if [[ -L "$dest" && "$(readlink -f -- "$dest")" == "$(readlink -f -- "$src")" ]]; then
		ok "$dest (already linked)"
		return
	fi

	if [[ -e "$dest" || -L "$dest" ]]; then
		if [[ "$dest" == "$HOME"/* ]]; then
			relative="${dest#"$HOME"/}"
		else
			relative="${dest#/}"
		fi
		backup="$BACKUP_ROOT/$relative"
		mkdir -p "$(dirname -- "$backup")"
		mv -- "$dest" "$backup"
		warn "backed up $dest -> $backup"
	fi

	mkdir -p "$(dirname -- "$dest")"
	ln -s -- "$src" "$dest"
	ok "$dest -> $src"
}

link_item() {
	local src="$1" dest="$2" entry

	if [[ -d "$src" && ! -L "$src" && -d "$dest" && ! -L "$dest" ]]; then
		while IFS= read -r -d '' entry; do
			link_item "$entry" "$dest/$(basename -- "$entry")"
		done < <(find "$src" -mindepth 1 -maxdepth 1 -print0)
	else
		link_file "$src" "$dest"
	fi
}

info "Linking shell and git dotfiles..."
for file in .bash_profile .bashrc .gitconfig .zshrc; do
	link_file "$DOTFILES/$file" "$HOME/$file"
done

info "Linking XDG configs into $CONFIG_HOME..."
shopt -s nullglob
for src in "$DOTFILES/.config"/*; do
	link_item "$src" "$CONFIG_HOME/$(basename -- "$src")"
done

# Keep helper scripts executable and available on PATH.
if [[ -d "$DOTFILES/.config/scripts" ]]; then
	find "$DOTFILES/.config/scripts" -maxdepth 1 -type f -name '*.sh' -exec chmod +x {} +
	info "Linking helper scripts into $HOME/.local/bin..."
	mkdir -p "$HOME/.local/bin"
	for script in "$DOTFILES/.config/scripts"/*; do
		[[ -f "$script" ]] || continue
		link_file "$script" "$HOME/.local/bin/$(basename -- "$script")"
	done
fi

info "Done."
if [[ -d "$BACKUP_ROOT" ]]; then
	warn "Previous files were backed up under $BACKUP_ROOT"
fi
