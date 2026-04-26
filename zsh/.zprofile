# =============================================================================
# ZSH PROFILE CONFIGURATION
# =============================================================================
# This file is sourced at login. It's used to set environment variables and
# run commands that should be executed only once at the start of a login session.

# -----------------------------------------------------------------------------
# Homebrew Configuration (macOS only)
# -----------------------------------------------------------------------------
if [[ "$(uname -s)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# -----------------------------------------------------------------------------
# Path Configuration
# -----------------------------------------------------------------------------
# Add pipx binaries to PATH
export PATH="$PATH:$HOME/.local/bin"

# -----------------------------------------------------------------------------
# Development Tools Configuration
# -----------------------------------------------------------------------------
# Initialize OrbStack (macOS only)
if [[ "$(uname -s)" == "Darwin" ]]; then
  source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi
