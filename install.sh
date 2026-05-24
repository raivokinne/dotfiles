#!/usr/bin/env bash
set -euo pipefail

DOTFILES="${HOME}/dotfiles"
WLRROOTS_PREFIX="/opt/wlroots019"

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

# ── Parse arguments ────────────────────────────────────────────────
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

# ── Dependency installation ────────────────────────────────────────
install_packages() {
	info "Installing system packages..."

	if ! command -v dnf &>/dev/null; then
		warn "dnf not found — skipping package installation."
		warn "Make sure the following dependencies are installed manually."
		return
	fi

	local packages=(
		# Build tools
		make gcc pkg-config wayland-devel
		# wlroots dependencies 
		libxkbcommon-devel libinput-devel libdrm-devel
		pixman-devel meson ninja-build wlroots0.19
		# wayland-protocols (for protocol headers)
		wayland-protocols-devel wayland-scanner
		# Runtime
		libwayland-server
		# dwlmsg runtime
		libwayland-client
		# Bar, launcher, etc.
		waybar foot wmenu bemenu
		# Script deps
		grim slurp satty jq swayidle brightnessctl
		pulseaudio-utils wlr-randr wlsunset
		# Notification daemon
		dunst swaync
		# st dependencies
		libX11-devel libXft-devel libXrender-devel
		# Font
		jetbrains-mono-fonts-all
		# Streaming (optional)
		sunshine
	)

	sudo dnf install -y "${packages[@]}"
}

# ── Build & install dwl ────────────────────────────────────────────
build_dwl() {
	info "Building dwl compositor..."
	cd "${DOTFILES}/dwl"

	if [[ ! -f "${WLRROOTS_PREFIX}/lib64/libwlroots-0.19.so" ]]; then
		err "wlroots 0.19 not found at ${WLRROOTS_PREFIX}."
		err "Install it first or use --no-build-dwl"
		exit 1
	fi

	export PKG_CONFIG_PATH="${WLRROOTS_PREFIX}/lib64/pkgconfig"
	sudo --preserve-env=PKG_CONFIG_PATH make clean install
	ok
}

# ── Build & install dwlmsg ─────────────────────────────────────────
build_dwlmsg() {
	info "Building dwlmsg..."
	cd "${DOTFILES}/dwlmsg"
	make
	sudo make install
	ok
}

# ── Build & install st ────────────────────────────────────────────
build_st() {
	info "Building st terminal..."
	cd "${DOTFILES}/st"
	make
	sudo make clean install
	ok
}

# ── Symlink configs ────────────────────────────────────────────────
link_configs() {
	info "Symlinking configuration files..."

	# Waybar
	mkdir -p "${HOME}/.config/waybar"
	ln -snf "${DOTFILES}/waybar/config.jsonc" "${HOME}/.config/waybar/config.jsonc"
	ln -snf "${DOTFILES}/waybar/style.css"     "${HOME}/.config/waybar/style.css"
	ok
}

# ── Main ───────────────────────────────────────────────────────────
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
