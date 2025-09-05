# =============================================================================
# ZSH CONFIGURATION FILE
# =============================================================================
export EDITOR="bbedit -w"
export VISUAL="bbedit -w"
export GPG_TTY=$(tty)

# -----------------------------------------------------------------------------
# Completion System Configuration
# -----------------------------------------------------------------------------
fpath+=~/.zfunc
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"

# -----------------------------------------------------------------------------
# Load Modular Configuration Files
# -----------------------------------------------------------------------------
[[ -f ~/code/dot-files/zsh/config/env.zsh ]] && source ~/code/dot-files/zsh/config/env.zsh
[[ -f ~/code/dot-files/zsh/config/aliases.zsh ]] && source ~/code/dot-files/zsh/config/aliases.zsh
[[ -f ~/code/dot-files/zsh/config/functions.zsh ]] && source ~/code/dot-files/zsh/config/functions.zsh

# -----------------------------------------------------------------------------
# Fuzzy Finder (FZF) Configuration
# -----------------------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
  source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
  source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
fi

# -----------------------------------------------------------------------------
# Development Tools Configuration
# -----------------------------------------------------------------------------
# NVM
export NVM_DIR="$HOME/.nvm"
[[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]] && source "/opt/homebrew/opt/nvm/nvm.sh"
[[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# LM Studio
path+=("$HOME/.lmstudio/bin")

# -----------------------------------------------------------------------------
# Prompt Configuration - Starship
# -----------------------------------------------------------------------------
eval "$(starship init zsh)"

# -----------------------------------------------------------------------------
# Shell Startup
# -----------------------------------------------------------------------------
[[ $- == *i* && -f ~/.cos_intro.zsh ]] && source ~/.cos_intro.zsh
