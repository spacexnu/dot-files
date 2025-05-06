# =============================================================================
# ZSH PROFILE CONFIGURATION
# =============================================================================
# This file is sourced at login. It's used to set environment variables and
# run commands that should be executed only once at the start of a login session.

# -----------------------------------------------------------------------------
# Homebrew Configuration
# -----------------------------------------------------------------------------
# Initialize Homebrew environment variables (PATH, MANPATH, etc.)
eval "$(/opt/homebrew/bin/brew shellenv)"

# -----------------------------------------------------------------------------
# Path Configuration
# -----------------------------------------------------------------------------
# Add pipx binaries to PATH (added by pipx on 2024-08-07)
export PATH="$PATH:/Users/spacexnu/.local/bin"

# -----------------------------------------------------------------------------
# Development Tools Configuration
# -----------------------------------------------------------------------------
# Initialize OrbStack (Docker/Linux VM alternative for macOS)
# OrbStack provides command-line tools and integration
# This won't be added again if you remove it
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
