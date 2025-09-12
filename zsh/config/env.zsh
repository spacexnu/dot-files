# =============================================================================
# ZSH ENVIRONMENT VARIABLES CONFIGURATION
# =============================================================================
# This file contains all environment variables used in the Zsh shell configuration.
# It is sourced by the main .zshrc file.

# -----------------------------------------------------------------------------
# Prompt Configuration
# -----------------------------------------------------------------------------
# Set the path to the Starship configuration file
export STARSHIP_CONFIG=~/code/dot-files/starship/starship.toml

# (Colors for ls are set conditionally in aliases fallback when eza is absent)

# -----------------------------------------------------------------------------
# Path Configuration
# -----------------------------------------------------------------------------
export PATH="$PATH:/usr/local/clamav/bin:/usr/local/clamav/sbin"

# -----------------------------------------------------------------------------
# Development Tools Configuration
# -----------------------------------------------------------------------------
# SDKMAN configuration
export SDKMAN_DIR="$HOME/.sdkman"
