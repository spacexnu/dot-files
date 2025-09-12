#!/usr/bin/env bash
set -euo pipefail

# Toggle or set Starship theme between Catppuccin Frappe (dark) and Latte (light)
# Usage: toggle-starship-theme [toggle|latte|frappe|auto|status]

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
LATTE_CFG="$SCRIPT_DIR/starship.latte.toml"
FRAPPE_CFG="$SCRIPT_DIR/starship.toml"
DEST_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
DEST_FILE="$DEST_DIR/starship.toml"

usage() {
  echo "Usage: $(basename "$0") [toggle|latte|frappe|auto|status]" >&2
}

ensure_paths() {
  mkdir -p "$DEST_DIR"
  if [[ ! -f "$LATTE_CFG" ]]; then
    echo "Missing Latte config: $LATTE_CFG" >&2
    exit 1
  fi
  if [[ ! -f "$FRAPPE_CFG" ]]; then
    echo "Missing Frappe config: $FRAPPE_CFG" >&2
    exit 1
  fi
}

current_target() {
  if [[ -L "$DEST_FILE" ]]; then
    readlink "$DEST_FILE"
  elif [[ -f "$DEST_FILE" ]]; then
    echo "(regular file)"
  else
    echo "(none)"
  fi
}

set_link() {
  local target="$1"
  ln -sfn "$target" "$DEST_FILE"
}

detect_system_scheme() {
  # Returns: "dark" or "light" (best-effort)
  local os
  os="$(uname -s 2>/dev/null || echo unknown)"
  if [[ "$os" == "Darwin" ]]; then
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi "Dark"; then
      echo dark
    else
      echo light
    fi
    return
  fi
  if command -v gsettings >/dev/null 2>&1; then
    if gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | grep -qi 'prefer-dark'; then
      echo dark
    else
      echo light
    fi
    return
  fi
  echo light
}

cmd="${1:-toggle}"

case "$cmd" in
  -h|--help|help)
    usage; exit 0 ;;
esac

ensure_paths

case "$cmd" in
  status)
    echo "Starship config link: $DEST_FILE"
    echo "Current target: $(current_target)"
    exit 0 ;;

  latte)
    set_link "$LATTE_CFG"
    echo "Switched to Latte (light): $LATTE_CFG"
    ;;

  frappe|dark)
    set_link "$FRAPPE_CFG"
    echo "Switched to Frappe (dark): $FRAPPE_CFG"
    ;;

  auto)
    scheme="$(detect_system_scheme)"
    if [[ "$scheme" == "dark" ]]; then
      set_link "$FRAPPE_CFG"
      echo "Auto-detected dark mode → Frappe: $FRAPPE_CFG"
    else
      set_link "$LATTE_CFG"
      echo "Auto-detected light mode → Latte: $LATTE_CFG"
    fi
    ;;

  toggle|*)
    target="$(current_target)"
    if [[ "$target" == "$LATTE_CFG" ]]; then
      set_link "$FRAPPE_CFG"
      echo "Toggled to Frappe (dark): $FRAPPE_CFG"
    else
      set_link "$LATTE_CFG"
      echo "Toggled to Latte (light): $LATTE_CFG"
    fi
    ;;
esac

echo "Tip: new prompts pick changes automatically. If not, run: exec $SHELL -l"

