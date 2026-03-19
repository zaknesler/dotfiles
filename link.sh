#!/usr/bin/env bash

# Usage: bash link.sh [link|unlink|status]

set -euo pipefail
shopt -s dotglob

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
TARGET="$HOME"

PACKAGES=(
  editorconfig
  git
  npm
  nushell
  nvim
  wezterm
  zed
)

IGNORE=(.DS_Store)

# Helpers

usage() {
  echo "Usage: $(basename "$0") [link|unlink|status]"
  echo
  echo "  link     Symlink packages into \$HOME (default)"
  echo "  unlink   Remove symlinks created by this script"
  echo "  status   Show current state of each package"
  exit 1
}

should_ignore() {
  local name="$1"
  for pattern in "${IGNORE[@]}"; do
    [[ "$name" == "$pattern" ]] && return 0
  done
  return 1
}

resolve_link() {
  local raw
  raw="$(readlink "$1")"
  if [[ "$raw" == /* ]]; then
    echo "$raw"
  else
    (cd "$(dirname "$1")" && cd "$(dirname "$raw")" && echo "$(pwd)/$(basename "$raw")")
  fi
}

same_inode() {
  [[ -f "$1" ]] && [[ -f "$2" ]] && [[ "$(stat -f%i "$1")" == "$(stat -f%i "$2")" ]]
}

rel() { echo "${1#"$TARGET"/}"; }

# Operations

do_link() {
  local src="$1" dest="$2"

  for item in "$src"/*; do
    [[ -e "$item" ]] || continue
    local name="$(basename "$item")"
    should_ignore "$name" && continue
    local target="$dest/$name"

    if [[ -d "$item" ]]; then
      if [[ -L "$target" ]] && [[ "$(resolve_link "$target")" == "$item" ]]; then
        echo "  ok   $(rel "$target")"
      elif [[ -d "$target" ]]; then
        do_link "$item" "$target"
      elif [[ -e "$target" ]]; then
        echo "  SKIP $(rel "$target") (already exists)"
      else
        mkdir -p "$dest"
        ln -s "$item" "$target"
        echo "  link $(rel "$target")"
      fi
    else
      if [[ -L "$target" ]] && [[ "$(resolve_link "$target")" == "$item" ]]; then
        echo "  ok   $(rel "$target")"
      elif same_inode "$item" "$target"; then
        echo "  ok   $(rel "$target") (hardlink)"
      elif [[ -e "$target" ]]; then
        echo "  SKIP $(rel "$target") (already exists)"
      else
        mkdir -p "$dest"
        ln -s "$item" "$target"
        echo "  link $(rel "$target")"
      fi
    fi
  done
}

do_unlink() {
  local src="$1" dest="$2"

  for item in "$src"/*; do
    [[ -e "$item" ]] || continue
    local name="$(basename "$item")"
    should_ignore "$name" && continue
    local target="$dest/$name"

    if [[ -L "$target" ]] && [[ "$(resolve_link "$target")" == "$item" ]]; then
      rm "$target"
      echo "  rm   $(rel "$target")"
    elif [[ -d "$item" ]] && [[ -d "$target" ]] && [[ ! -L "$target" ]]; then
      do_unlink "$item" "$target"
    fi
  done
}

do_status() {
  local src="$1" dest="$2"

  for item in "$src"/*; do
    [[ -e "$item" ]] || continue
    local name="$(basename "$item")"
    should_ignore "$name" && continue
    local target="$dest/$name"

    if [[ -L "$target" ]] && [[ "$(resolve_link "$target")" == "$item" ]]; then
      echo "  ✓ $(rel "$target")"
    elif [[ -d "$item" ]] && [[ -d "$target" ]] && [[ ! -L "$target" ]]; then
      do_status "$item" "$target"
    elif same_inode "$item" "$target"; then
      echo "  ✓ $(rel "$target") (hardlink)"
    elif [[ -L "$target" ]]; then
      echo "  ✗ $(rel "$target") (symlink → $(readlink "$target"))"
    elif [[ -e "$target" ]]; then
      echo "  ✗ $(rel "$target") (exists, not linked)"
    else
      echo "  ✗ $(rel "$target") (missing)"
    fi
  done
}

# Main

ACTION="${1:-link}"

case "$ACTION" in
  link|unlink|status) ;;
  *) usage ;;
esac

for pkg in "${PACKAGES[@]}"; do
  echo "[$pkg]"
  "do_$ACTION" "$DOTFILES/$pkg" "$TARGET"
  echo
done
