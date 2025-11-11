#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

trap 'echo -e "\n\033[0;31m✘ Interrupted. Exiting...\033[0m"; exit 1' INT

# ----------------------
# 🎨 COLORS & HELPERS
# ----------------------
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
RESET="\033[0m"

log() { echo -e "${YELLOW}➤ $1${RESET}"; }
success() { echo -e "${GREEN}✔ $1${RESET}"; }
error() { echo -e "${RED}✘ $1${RESET}" >&2; }

get_yes_no() {
  local prompt="$1" response
  while true; do
    read -rp "$prompt (y/n) " response
    case "$response" in
    [Yy]) return 0 ;;
    [Nn]) return 1 ;;
    esac
  done
}

backup_file() {
  local target="$1"
  if [[ -e "$target" ]]; then
    mv "$target" "$target.bak"
    success "Backed up $target → $target.bak"
  fi
}

CONFIG_DIR="$HOME/.config"

# ----------------------
# 🧩 INSTALL SKETCHYBAR
# ----------------------
install_sketchybar() {
  log "Cloning Efterklang SketchyBar config..."
  backup_file "$CONFIG_DIR/sketchybar"
  git clone --depth 1 https://github.com/Efterklang/sketchybar "$CONFIG_DIR/sketchybar"
  success "Cloned Efterklang SketchyBar config."

  if get_yes_no "✨ Install SketchyBar dependencies and helpers?"; then
    log "Installing SketchyBar dependencies..."
    brew install lua jq switchaudio-osx media-control imagemagick
    brew tap FelixKratz/formulae
    brew install sketchybar
    brew install --cask font-sketchybar-app-font font-maple-mono-nf-cn
    success "Installed dependencies."
    log "Installing sketchybar-system-stats plugin..."
    brew tap joncrangle/tap
    brew install sketchybar-system-stats
    success "sketchybar-system-stats plugin installed."
    log "Installing SbarLua..."
    tmpdir=$(mktemp -d)
    trap 'rm -rf "$tmpdir"' EXIT
    git clone --depth 1 --quiet https://github.com/FelixKratz/SbarLua.git "$tmpdir"
    (cd "$tmpdir" && make install)
    success "SbarLua installed."
  fi

  brew services restart sketchybar
  sketchybar --reload
  success "SketchyBar loaded."
}

install_sketchybar

success "✅ SketchyBar installation complete."
