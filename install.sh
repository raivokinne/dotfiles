#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${HOME}/dotfiles"

info()  { printf "\033[1;34m==>\033[0m %s\n" "$*"; }
warn()  { printf "\033[1;33m==>\033[0m %s\n" "$*"; }
err()   { printf "\033[1;31m==>\033[0m %s\n" "$*" >&2; }
ok()    { printf "\033[1;32m  ->\033[0m done\n"; }

usage() {
	cat <<EOF
Usage: $0 [options]

Options:
  -h, --help           Show this help
  --no-packages        Skip system package installation
  --no-build-dwl       Skip building/installing dwl
  --no-build-dwlmsg    Skip building/installing dwlmsg
  --no-build-st        Skip building/installing st
  --no-symlinks        Skip symlinking config files
EOF
	exit 0
}

SKIP_PACKAGES=false
SKIP_DWL=false
SKIP_DWLMSG=false
SKIP_ST=false
SKIP_SYMLINKS=false

while [[ $# -gt 0 ]]; do
	case "$1" in
		-h|--help) usage ;;
		--no-packages) SKIP_PACKAGES=true ;;
		--no-build-dwl) SKIP_DWL=true ;;
		--no-build-dwlmsg) SKIP_DWLMSG=true ;;
		--no-build-st) SKIP_ST=true ;;
		--no-symlinks) SKIP_SYMLINKS=true ;;
		*) err "Unknown option: $1"; exit 1 ;;
	esac
	shift
done

install_packages() {
	info "Installing system packages..."

	if ! command -v dnf &>/dev/null; then
		warn "dnf not found — skipping package installation."
		warn "Make sure the following dependencies are installed manually."
		return
	fi

	local packages=(
		make gcc pkg-config wayland-devel
		libxkbcommon-devel libinput-devel libdrm-devel
		pixman-devel meson ninja-build wlroots wlroot-devel
		wayland-protocols-devel wayland-scanner
		libwayland-server
		libwayland-client
		waybar foot wmenu bemenu
		grim slurp satty jq swayidle brightnessctl
		pulseaudio-utils wlr-randr wlsunset
		dunst swaync
		libX11-devel libXft-devel libXrender-devel
		jetbrains-mono-fonts-all
		fish
		neovim
		ghostty
		sunshine
		widevine-installer
	)

	sudo dnf install -y "${packages[@]}"
}

build_dwl() {
	info "Building dwl compositor..."
	cd "${DOTFILES}/dwl"
	sudo make clean install
	ok
}

build_dwlmsg() {
	info "Building dwlmsg..."
	cd "${DOTFILES}/dwlmsg"
	make
	sudo make install
	ok
}

build_st() {
	info "Building st terminal..."
	cd "${DOTFILES}/st"
	make
	sudo make clean install
	ok
}

link_configs() {
	info "Symlinking configuration files..."

	ln -snf "${DOTFILES}/.zshrc" "${HOME}/.zshrc"

	mkdir -p "${HOME}/.config/waybar"
	ln -snf "${DOTFILES}/waybar/config.jsonc" "${HOME}/.config/waybar/config.jsonc"
	ln -snf "${DOTFILES}/waybar/style.css"     "${HOME}/.config/waybar/style.css"

	ln -snf "${DOTFILES}/emacs" "${HOME}/.config/emacs"

	mkdir -p "${HOME}/.config/ghostty"
	ln -snf "${DOTFILES}/ghostty/config.ghostty" "${HOME}/.config/ghostty/config.ghostty"

	ln -snf "${DOTFILES}/fish" "${HOME}/.config/fish"

	ln -snf "${DOTFILES}/mako" "${HOME}/.config/mako"

	ln -snf "${DOTFILES}/nvim" "${HOME}/.config/nvim"

	ln -snf "${DOTFILES}/sway" "${HOME}/.config/sway"

	mkdir -p "${HOME}/.local/bin"
	for script in "${DOTFILES}/scripts/"*; do
		chmod +x "$script"
		ln -snf "$script" "${HOME}/.local/bin/$(basename "$script")"
	done

	ok
}

main() {
	info "Starting dotfiles installation..."

	$SKIP_PACKAGES || install_packages
	$SKIP_DWL      || build_dwl
	$SKIP_DWLMSG   || build_dwlmsg
	$SKIP_ST       || build_st
	$SKIP_SYMLINKS || link_configs

	info "Installation complete!"
	cat <<-EOF

	────────────────────────────────────────────
	 What's next?
	────────────────────────────────────────────
	 • Ensure \`${HOME}/.config/rice_assets/Icons/\`
	   exists with your custom notification icons.
	 • If your wallpaper path differs from
	   \`${HOME}/med/pictures/\`, update it in
	   \`${DOTFILES}/dwl/config.h\` (autostart entry).
	 • Log out and select "dwl" from your display
	   manager session list, or start it from a TTY
	   with:  exec dwl
	────────────────────────────────────────────
	EOF
}

main "$@"
