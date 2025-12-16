# =============================================================================
# ZSH CONFIGURATION FILE
# =============================================================================
export EDITOR="nvim"
export VISUAL="nvim"
export GPG_TTY=$(tty)

# =============================================================================
# Homebrew always compile
# =============================================================================
export HOMEBREW_BUILD_FROM_SOURCE=1

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
# Pyenv
# -----------------------------------------------------------------------------

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# -----------------------------------------------------------------------------
# Shell Startup
# -----------------------------------------------------------------------------
[[ $- == *i* && -f ~/.cos_intro.zsh ]] && source ~/.cos_intro.zsh
