#!/bin/bash
set -euo pipefail

# =============================================================================
# DOTFILES INSTALLATION SCRIPT
# =============================================================================
# This script automates the installation of dotfiles by creating symbolic links
# and installing required dependencies.
#
# The script will:
# 1. Detect your operating system
# 2. Install dependencies (optional)
# 3. Set up configurations for Zsh, Tmux, Starship, and related tools
# 4. Create symbolic links to configuration files
# 5. Offer to change your default shell to Fish

# Set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

 # Get the directory where the script is located (bash/zsh/sh compatible)
SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
DOTFILES_DIR="$( cd "$( dirname "$SCRIPT_SOURCE" )" >/dev/null 2>&1 && pwd -P )"

# Redirect all output to a log file as well as the terminal
exec > >(tee -a "$HOME/dotfiles-install.log") 2>&1

# Handle auto-confirm flag
AUTO_CONFIRM=false
NVIM_ONLY=false
# Parse args for auto-confirm and scoped install flags
for arg in "$@"; do
  case "$arg" in
    -y|--yes)
      AUTO_CONFIRM=true
      ;;
    --nvim-only)
      NVIM_ONLY=true
      ;;
  esac
done

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

# Print a section header
print_section() {
  echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

# Print a success message
print_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

# Print an error message
print_error() {
  echo -e "${RED}✗ $1${NC}"
}

# Print a warning message
print_warning() {
  echo -e "${YELLOW}! $1${NC}"
}

# Print an info message
print_info() {
  echo -e "${BLUE}i $1${NC}"
}

# Create a backup of a file if it exists
backup_file() {
  local target="$1"
  if [ -e "$target" ]; then
    local base_name="$(basename "$target")"
    local dir_name="$(dirname "$target")"
    local backup_file="$dir_name/${base_name}.backup.$(date +%Y%m%d%H%M%S)"
    print_info "Backing up $target to $backup_file"
    mv "$target" "$backup_file"
    return 0
  fi
  return 1
}

# Create a symbolic link
create_symlink() {
  local source_file="$1"
  local target_file="$2"

  # Check if source file exists
  if [ ! -e "$source_file" ]; then
    print_error "Source file $source_file does not exist"
    return 1
  fi

  # Check if symlink already exists and points to the correct file
  if [ -L "$target_file" ] && [ "$(readlink "$target_file")" = "$source_file" ]; then
    print_info "Symlink for $target_file already exists and is correct. Skipping."
    return 0
  fi

  # Backup existing file or directory
  backup_file "$target_file"

  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$target_file")"

  # Create the symlink
  print_info "Creating symlink from $source_file to $target_file"
  ln -sfn "$source_file" "$target_file"

  # Check if symlink was created successfully
  if [ $? -eq 0 ]; then
    print_success "Symlink created successfully"
    return 0
  else
    print_error "Failed to create symlink"
    return 1
  fi
}

# Install only Neovim configuration
install_nvim_config() {
  mkdir -p "$HOME/.config"
  print_info "Using DOTFILES_DIR=$DOTFILES_DIR"
  if [ -d "$DOTFILES_DIR/nvim" ]; then
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    if [ -L "$HOME/.config/nvim" ]; then
      local target
      target="$(readlink "$HOME/.config/nvim" || true)"
      print_success "Neovim configuration installed"
      if [ -n "$target" ]; then
        print_info "~/.config/nvim -> $target"
      fi
    else
      print_warning "~/.config/nvim was not created as a symlink. Check permissions."
    fi
    print_info "Open Neovim and run :Lazy then :Mason to install plugins and tools."
  else
    print_error "Neovim configuration directory not found at $DOTFILES_DIR/nvim"
    return 1
  fi
}

# Fast path: only install Neovim config and exit
if $NVIM_ONLY; then
  print_section "Neovim Configuration"
  install_nvim_config
  exit $?
fi

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Ask user for confirmation
confirm() {
  local prompt="$1"
  local default="${2:-n}"

  if $AUTO_CONFIRM; then
    return 0
  fi

  if [ "$default" = "y" ]; then
    local options="Y/n"
  else
    local options="y/N"
  fi

  read -p "$prompt ($options) " -n 1 -r
  echo

  if [ -z "$REPLY" ]; then
    REPLY="$default"
  fi

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    return 0
  else
    return 1
  fi
}

# -----------------------------------------------------------------------------
# OS Detection
# -----------------------------------------------------------------------------
print_section "Detecting Operating System"

OS="unknown"
if [ "$(uname)" == "Darwin" ]; then
  OS="macos"
  print_success "macOS detected"
elif [ "$(uname)" == "Linux" ]; then
  if [ -f /etc/debian_version ]; then
    OS="debian"
    print_success "Debian/Ubuntu Linux detected"
  elif [ -f /etc/redhat-release ]; then
    OS="redhat"
    print_success "Red Hat/CentOS/Fedora Linux detected"
  else
    OS="linux"
    print_success "Linux detected"
  fi
  if grep -qi microsoft /proc/version 2>/dev/null; then
    OS="wsl"
    print_success "WSL detected"
  fi
elif [ "$(uname -o 2>/dev/null)" == "Msys" ] || [ "$(uname -o 2>/dev/null)" == "Cygwin" ] || [ -n "$WSLENV" ]; then
  OS="windows"
  print_success "Windows (WSL/Cygwin/MSYS) detected"
else
  print_warning "Unknown operating system. Some features may not work correctly."
fi

# -----------------------------------------------------------------------------
# Dependencies Installation
# -----------------------------------------------------------------------------
print_section "Installing Dependencies"

# List of dependencies to install
DEPENDENCIES=(fzf tmux lolcat fortune starship fish zoxide eza ripgrep fd bat)

install_dependencies() {
  case $OS in
    macos)
      if ! command_exists brew; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      else
        print_success "Homebrew is already installed"
      fi

      print_info "Installing required packages with Homebrew..."
      brew update
      brew install "${DEPENDENCIES[@]}"
      ;;
    debian)
      print_info "Installing required packages with apt..."
      sudo apt update
      sudo apt install -y "${DEPENDENCIES[@]}"
      ;;
    redhat)
      print_info "Installing required packages with dnf/yum..."
      if command_exists dnf; then
        sudo dnf install -y "${DEPENDENCIES[@]}"
      else
        sudo yum install -y "${DEPENDENCIES[@]}"
      fi
      ;;
    *)
      print_warning "Automatic dependency installation is not supported on this OS."
      print_info "Please install the following dependencies manually: ${DEPENDENCIES[*]}"
      ;;
  esac
}

# Offer to install Nerd Fonts
if confirm "Do you want to install Nerd Fonts?" "n"; then
  case $OS in
    macos)
      FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
      FONT_DEST="$HOME/Library/Fonts"
      print_info "Downloading FiraCode Nerd Font..."
      curl -L -o /tmp/FiraCode.zip "$FONT_URL" && unzip -o /tmp/FiraCode.zip -d "$FONT_DEST"
      if [ $? -eq 0 ]; then
        print_success "Fira Code Nerd Font installed to $FONT_DEST"
      else
        print_error "Failed to install Fira Code Nerd Font. Please install it manually from https://www.nerdfonts.com/font-downloads"
      fi
      ;;
    debian)
      sudo apt install -y fonts-firacode || print_warning "Failed to install Fira Code Nerd Font via apt"
      ;;
    *)
      print_info "Please install the Fira Code Nerd Font manually from https://www.nerdfonts.com if it's not available for your system."
      ;;
  esac
fi


if confirm "Do you want to install dependencies?" "n"; then
  install_dependencies || { print_error "Dependency installation failed"; exit 1; }
else
  print_info "Skipping dependency installation"
fi

# -----------------------------------------------------------------------------
# Explicit Fish Installation (in case dependencies were skipped or fish missing)
# -----------------------------------------------------------------------------
if ! command_exists fish; then
  if confirm "Fish is not installed. Do you want to install Fish now?" "y"; then
    case $OS in
      macos)
        if ! command_exists brew; then
          print_info "Installing Homebrew..."
          /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        print_info "Installing Fish via Homebrew..."
        brew install fish && print_success "Fish installed" || print_error "Failed to install Fish"
        ;;
      debian)
        print_info "Installing Fish via apt..."
        sudo apt update && sudo apt install -y fish && print_success "Fish installed" || print_error "Failed to install Fish"
        ;;
      redhat)
        print_info "Installing Fish via dnf/yum..."
        if command_exists dnf; then
          sudo dnf install -y fish && print_success "Fish installed" || print_error "Failed to install Fish"
        else
          sudo yum install -y fish && print_success "Fish installed" || print_error "Failed to install Fish"
        fi
        ;;
      *)
        print_warning "Automatic Fish installation not supported on this OS."
        ;;
    esac
  else
    print_info "Skipping Fish installation"
  fi
else
  print_info "Fish already installed at $(command -v fish)"
fi

# -----------------------------------------------------------------------------
# Symlink Creation
# -----------------------------------------------------------------------------
print_section "Creating Symbolic Links"

# Create ~/.config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Zsh configuration
if confirm "Do you want to install Zsh shell configuration?" "y"; then
  create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
  create_symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
  create_symlink "$DOTFILES_DIR/zsh/.cos_intro.zsh" "$HOME/.cos_intro.zsh"

  # Create directory for Zsh config files
  mkdir -p "$HOME/.zsh"

  # Symlink all files in the config directory
  if [ -d "$DOTFILES_DIR/zsh/config" ]; then
    for config_file in "$DOTFILES_DIR/zsh/config"/*; do
      if [ -f "$config_file" ]; then
        create_symlink "$config_file" "$HOME/.zsh/$(basename "$config_file")"
      fi
    done
  fi

  print_success "Zsh configuration installed"
else
  print_info "Skipping Zsh configuration"
fi

# Fish shell configuration
if confirm "Do you want to install Fish shell configuration?" "y"; then
  mkdir -p "$HOME/.config/fish"
  if create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"; then
    print_success "Fish config.fish installed"
  else
    print_error "Failed to install Fish config.fish"
  fi
  if [ -f "$DOTFILES_DIR/fish/cos_intro.fish" ]; then
    if create_symlink "$DOTFILES_DIR/fish/cos_intro.fish" "$HOME/.config/fish/cos_intro.fish"; then
      print_success "Fish cos_intro.fish installed"
    else
      print_error "Failed to install Fish cos_intro.fish"
    fi
  fi
else
  print_info "Skipping Fish configuration"
fi


# Tmux configuration
if confirm "Do you want to install Tmux configuration?" "y"; then
  if [ -f "$DOTFILES_DIR/tmux/.tmux.conf" ]; then
    create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    print_success "Tmux configuration installed"
  else
    print_error "Tmux configuration file not found"
  fi
else
  print_info "Skipping Tmux configuration"
fi

# Git configuration
if confirm "Do you want to install Git configuration?" "y"; then
  create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"
  create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
  print_success "Git configuration installed (without commit template)"
else
  print_info "Skipping Git configuration"
fi

# Starship configuration
if confirm "Do you want to install Starship prompt configuration?" "y"; then
  mkdir -p "$HOME/.config"
  create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
  print_success "Starship configuration installed"
else
  print_info "Skipping Starship configuration"
fi

# Neovim configuration
if confirm "Do you want to install Neovim configuration?" "y"; then
  mkdir -p "$HOME/.config"
  if [ -d "$DOTFILES_DIR/nvim" ]; then
    create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
    print_success "Neovim configuration installed"
    print_info "Open Neovim and run :Lazy then :Mason to install plugins and tools."
  else
    print_error "Neovim configuration directory not found at $DOTFILES_DIR/nvim"
  fi
else
  print_info "Skipping Neovim configuration"
fi

# iTerm2 (macOS only)
if [ "$OS" == "macos" ]; then
  print_info "iTerm2 configurations need to be imported manually from:"
  print_info "$DOTFILES_DIR/iterm2/profiles/"
fi

# -----------------------------------------------------------------------------
# Shell Configuration
# -----------------------------------------------------------------------------
print_section "Shell Configuration"

if [ "$OS" == "macos" ]; then
  if confirm "Do you want to change your default shell to Fish?" "n"; then
    if command_exists dscl; then
      FISH_PATH="$(command -v fish)"
      if [ -n "$FISH_PATH" ]; then
        print_info "Changing default shell to Fish ($FISH_PATH) using dscl..."
        sudo dscl . -create /Users/"$USER" UserShell "$FISH_PATH" && print_success "Default shell changed to Fish" || print_error "Failed to change default shell"
      else
        print_error "Fish shell not found in PATH"
      fi
    else
      print_error "dscl command not found. Cannot change shell."
    fi
  else
    print_info "Skipping default shell change"
  fi
fi

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
print_section "Installation Complete"

print_success "Dotfiles have been installed successfully!"
print_info "Please restart your terminal to apply the changes."
print_info "For more information, see the README.md file."
