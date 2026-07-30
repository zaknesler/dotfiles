#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.config/dotfiles}"
REPO_URL="https://github.com/zaknesler/dotfiles.git"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31mXX\033[0m %s\n' "$*" >&2; }
is_installed() { command -v "$1" >/dev/null 2>&1; }

# detect platform
OS="$(uname -s)"
case "$OS" in
  Darwin) PLATFORM=mac ;;
  Linux)  PLATFORM=linux ;;
  *) err "Unsupported OS: $OS (only macOS and Linux supported)"; exit 1 ;;
esac

log "Detected platform: $PLATFORM"

# ask about server mode
SERVER_MODE=false
for arg in "$@"; do
  [ "$arg" = "--server" ] && SERVER_MODE=true
done
if [ "$SERVER_MODE" = false ] && [ -e /dev/tty ]; then
  read -r -p "Server install? Will only symlink necessary config files. [y/N] " reply </dev/tty || reply=""
  case "$reply" in
    [yY]*) SERVER_MODE=true ;;
  esac
fi

# ask about package updates
UPDATE_PACKAGES=false
if [ "$PLATFORM" = linux ] && [ -e /dev/tty ]; then
  read -r -p "Update all system packages when done? [y/N] " reply </dev/tty || reply=""
  case "$reply" in
    [yY]*) UPDATE_PACKAGES=true ;;
  esac
fi

# set a few XDG dirs
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CONFIG_HOME XDG_DATA_HOME
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export PATH="$CARGO_HOME/bin:$PATH"

if [ "$SERVER_MODE" = true ]; then
  STOW_DIRS=(editorconfig git npm nushell nvim)
else
  STOW_DIRS=(editorconfig ghostty git npm nushell nvim zed zaku)
fi

[ "$PLATFORM" = mac ] && STOW_DIRS+=(brew)

# prompt for sudo now so we don't get asked for it later
if is_installed sudo; then
  sudo -v
  ( while true; do sudo -n true || true; sleep 60; kill -0 "$$" 2>/dev/null || exit; done ) &
  SUDO_KEEPALIVE_PID=$!
  trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
fi

# resolve a release asset url
github_asset_url() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | grep -o "\"browser_download_url\": *\"[^\"]*$2\"" \
    | head -n1 | cut -d'"' -f4
}

# install macOS prerequisites
install_mac_prereqs() {
  if ! xcode-select -p >/dev/null 2>&1; then
    log "Installing Xcode command line tools..."
    xcode-select --install || true
    warn "Waiting for Xcode CLI tools install to finish. Re-run this script after it completes if it pauses here."
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
  else
    log "Xcode CLI tools already installed."
  fi

  if ! is_installed brew; then
    log "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    log "Homebrew already installed."
  fi

  # brew may be missing from PATH
  if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  for pkg in stow neovim git; do
    if ! is_installed "$pkg"; then
      log "Installing $pkg via Homebrew..."
      brew install "$pkg"
    fi
  done
}

# install core linux dependencies
install_linux_prereqs() {
  if is_installed apt-get; then
    log "Installing core packages via apt..."
    sudo apt-get update
    sudo apt-get install -y stow git curl pkg-config build-essential libssl-dev ca-certificates unzip htop
  elif is_installed pacman; then
    log "Installing core packages via pacman..."
    sudo pacman -Sy --noconfirm --needed stow git curl pkgconf base-devel openssl ca-certificates unzip htop
  else
    err "No known package manager found (apt/pacman). Install stow, git, curl, and a C toolchain manually."
    exit 1
  fi
}

# install latest neovim from github
install_linux_neovim() {
  if is_installed nvim; then
    log "Neovim already installed ($(nvim --version | head -n1))."
    return
  fi

  local arch
  case "$(uname -m)" in
    x86_64|amd64)  arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) warn "No prebuilt Neovim tarball for $(uname -m); install manually."; return ;;
  esac

  log "Installing latest Neovim from GitHub release..."
  local tmpdir url extracted
  tmpdir="$(mktemp -d)"
  url="$(github_asset_url neovim/neovim "nvim-linux-${arch}\.tar\.gz" || true)"

  if [ -z "$url" ]; then
    warn "Could not resolve latest Neovim release URL; install manually."
    rm -rf "$tmpdir"
    return
  fi

  curl -fsSL "$url" -o "$tmpdir/nvim.tar.gz"
  tar xzf "$tmpdir/nvim.tar.gz" -C "$tmpdir"
  extracted="$(find "$tmpdir" -maxdepth 1 -type d -name 'nvim-linux-*' | head -n1)"
  sudo cp "$extracted/bin/nvim" /usr/local/bin/
  sudo cp -r "$extracted/share/nvim" /usr/local/share/
  rm -rf "$tmpdir"

  log "Installed $(nvim --version | head -n1)"
}

# install latest nushell from github
install_linux_nushell() {
  if is_installed nu && is_installed nu_plugin_gstat; then
    log "Nushell already installed ($(nu --version | head -n1))."
    return
  fi

  local target
  case "$(uname -m)" in
    x86_64|amd64)  target=x86_64-unknown-linux-gnu ;;
    aarch64|arm64) target=aarch64-unknown-linux-gnu ;;
    *) err "No prebuilt Nushell tarball for $(uname -m); install manually."; exit 1 ;;
  esac

  log "Installing latest Nushell from GitHub release..."
  local tmpdir url extracted
  tmpdir="$(mktemp -d)"
  url="$(github_asset_url nushell/nushell "${target}\.tar\.gz" || true)"

  if [ -z "$url" ]; then
    err "Could not resolve latest Nushell release URL; install manually."
    rm -rf "$tmpdir"
    exit 1
  fi

  curl -fsSL "$url" -o "$tmpdir/nu.tar.gz"
  tar xzf "$tmpdir/nu.tar.gz" -C "$tmpdir"
  extracted="$(find "$tmpdir" -maxdepth 1 -type d -name 'nu-*' | head -n1)"
  sudo install -m755 "$extracted/nu" "$extracted/nu_plugin_gstat" /usr/local/bin/
  rm -rf "$tmpdir"

  log "Installed $(nu --version | head -n1)"
}

# install pre-reqs
if [ "$PLATFORM" = mac ]; then
  install_mac_prereqs
else
  install_linux_prereqs
  install_linux_neovim
fi

# install rust
if is_installed rustup; then
  log "Rust already installed."
else
  log "Installing Rust via rustup into $CARGO_HOME..."
  curl -fsSL --proto '=https' --tlsv1.2 https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

# install cargo-binstall
if ! is_installed cargo-binstall; then
  log "Installing cargo-binstall..."
  curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
else
  log "cargo-binstall already installed."
fi

# install tree-sitter-cli, nvim needs it
if ! is_installed tree-sitter; then
  log "Installing tree-sitter-cli..."
  cargo-binstall --no-confirm tree-sitter-cli
else
  log "tree-sitter-cli already installed."
fi

# install nushell, must happen before stowing its config dir
if [ "$PLATFORM" = mac ]; then
  if ! is_installed nu; then
    log "Installing Nushell via Homebrew..."
    brew install nushell
  else
    log "Nushell already installed."
  fi
else
  install_linux_nushell
fi

# clone dotfiles repo
if [ -d "$DOTFILES_DIR/.git" ]; then
  log "Dotfiles repo already present at $DOTFILES_DIR, skipping clone."
else
  log "Cloning dotfiles into $DOTFILES_DIR..."
  mkdir -p "$(dirname "$DOTFILES_DIR")"
  git clone --recurse-submodules --depth 1 "$REPO_URL" "$DOTFILES_DIR"
fi

cd "$DOTFILES_DIR"

# symlink directories
log "Symlinking directories: ${STOW_DIRS[*]}"
stow -t "$HOME" --restow "${STOW_DIRS[@]}"

# create wgetrc file so wget doesn't error
mkdir -p "$XDG_CONFIG_HOME"
touch "$XDG_CONFIG_HOME/wgetrc"

# maybe add minimal config to neovim
if [ "$SERVER_MODE" = true ]; then
  log "Server install: marking nvim config .minimal (skips LSPs)"
  touch "$XDG_CONFIG_HOME/nvim/.minimal"
fi

# install homebrew packages, brew finds the Brewfile via XDG_CONFIG_HOME
if [ "$PLATFORM" = mac ]; then
  log "Running brew bundle -g..."
  brew bundle -g || warn "brew bundle -g failed; check $XDG_CONFIG_HOME/homebrew/Brewfile."
fi

# configure nushell as the default shell
NU_PATH="$(command -v nu || true)"
if [ -z "$NU_PATH" ]; then
  err "Nushell binary not found on PATH; cannot set it as the default shell."
  exit 1
fi
if ! grep -qxF "$NU_PATH" /etc/shells 2>/dev/null; then
  log "Adding $NU_PATH to /etc/shells..."
  # add a trailing newline first, otherwise we'd concatenate onto the last entry
  sudo sh -c '
    f=/etc/shells
    [ -s "$f" ] && [ -n "$(tail -c1 "$f")" ] && printf "\n" >> "$f"
    printf "%s\n" "$1" >> "$f"
  ' _ "$NU_PATH"
fi
if [ "${SHELL:-}" != "$NU_PATH" ]; then
  log "Setting default shell to Nushell ($NU_PATH)..."
  sudo chsh -s "$NU_PATH" "$(id -un)" || warn "chsh failed; run manually: chsh -s $NU_PATH"
else
  log "Default shell already Nushell."
fi

# register nu plugins
GSTAT_PATH="$(command -v nu_plugin_gstat || true)"
if [ -n "$GSTAT_PATH" ]; then
  log "Registering nu_plugin_gstat with Nushell..."
  nu -c "plugin add '$GSTAT_PATH'; version" || warn "Failed to register nu_plugin_gstat; run manually inside nu."
else
  warn "nu_plugin_gstat not found, install it manually."
fi

# update system packages
if [ "$UPDATE_PACKAGES" = true ]; then
  if is_installed apt-get; then
    sudo apt-get update && sudo apt-get upgrade -y
  elif is_installed pacman; then
    sudo pacman -Syu --noconfirm
  fi
fi

log "Done. Run 'nu' to verify, then relog."
