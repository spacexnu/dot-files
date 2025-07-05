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
# 3. Set up configurations for various tools (Neovim, Vim, Fish, Zsh, Tmux, etc.)
# 4. Create symbolic links to configuration files
# 5. Offer to change your default shell to Fish

# Set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

 # Get the directory where the script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Redirect all output to a log file as well as the terminal
exec > >(tee -a "$HOME/dotfiles-install.log") 2>&1

# Handle auto-confirm flag
AUTO_CONFIRM=false
if [[ "${1:-}" == "--yes" ]]; then
  AUTO_CONFIRM=true
fi

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
  ln -sf "$source_file" "$target_file"

  # Check if symlink was created successfully
  if [ $? -eq 0 ]; then
    print_success "Symlink created successfully"
    return 0
  else
    print_error "Failed to create symlink"
    return 1
  fi
}

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
DEPENDENCIES=(fish fzf tmux neovim lolcat fortune starship)

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
      brew tap homebrew/cask-fonts
      brew install --cask font-fira-code-nerd-font
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
# Install Neovim configuration (lazy.nvim based)
# -----------------------------------------------------------------------------
if confirm "Do you want to install Neovim configuration?" "y"; then
  print_section "Installing Neovim Configuration"

  NEOVIM_CONFIG_DIR="$HOME/.config/nvim"

  if [ -d "$NEOVIM_CONFIG_DIR" ]; then
    backup_file "$NEOVIM_CONFIG_DIR"
  fi

  create_symlink "$DOTFILES_DIR/nvim" "$NEOVIM_CONFIG_DIR"

  # Check if git is installed before cloning
  if ! command_exists git; then
    print_error "Git is not installed. Please install git and try again."
    exit 1
  fi

  print_info "Checking for lazy.nvim directory at $HOME/.local/share/nvim/lazy/lazy.nvim"
  LAZY_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
  if [ ! -d "$LAZY_DIR" ]; then
    print_info "Cloning lazy.nvim..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git "$LAZY_DIR" || {
      print_error "Failed to clone lazy.nvim"
      exit 1
    }
  else
    print_info "lazy.nvim already exists, skipping clone."
  fi

  print_success "Neovim configuration installed successfully"
  print_info "You can launch Neovim with 'nvim' and it will use the lazy.nvim setup."
else
  print_info "Skipping Neovim configuration"
fi

# -----------------------------------------------------------------------------
# Symlink Creation
# -----------------------------------------------------------------------------
print_section "Creating Symbolic Links"

# Create ~/.config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Fish configuration
if confirm "Do you want to install Fish shell configuration?" "y"; then
  mkdir -p "$HOME/.config/fish"
  create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
  create_symlink "$DOTFILES_DIR/fish/cos_intro.fish" "$HOME/.config/fish/cos_intro.fish"
  print_success "Fish configuration installed"
else
  print_info "Skipping Fish configuration"
fi

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

# Vim configuration
if confirm "Do you want to install Vim configuration?" "y"; then
  create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"
  print_success "Vim configuration installed"
else
  print_info "Skipping Vim configuration"
fi

# IdeaVim configuration
if confirm "Do you want to install IdeaVim configuration?" "y"; then
  create_symlink "$DOTFILES_DIR/ideavim/.ideavimrc" "$HOME/.ideavimrc"
  print_success "IdeaVim configuration installed"
else
  print_info "Skipping IdeaVim configuration"
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
  create_symlink "$DOTFILES_DIR/git/commit-template.txt" "$HOME/.git-commit-template.txt"
  print_success "Git configuration installed"
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

# iTerm2 (macOS only)
if [ "$OS" == "macos" ]; then
  print_info "iTerm2 configurations need to be imported manually from:"
  print_info "$DOTFILES_DIR/iterm2/profiles/"
fi

# -----------------------------------------------------------------------------
# Shell Configuration
# -----------------------------------------------------------------------------
print_section "Shell Configuration"

# Check if Fish is installed
if command_exists fish; then
  CURRENT_SHELL_NAME="$(basename "$SHELL")"
  FISH_PATH="$(command -v fish)"

  if [ "$CURRENT_SHELL_NAME" != "fish" ]; then
    if confirm "Your current shell is not Fish. Do you want to change your default shell to Fish?" "n"; then
      if chsh -s "$FISH_PATH"; then
        print_success "Default shell changed to Fish"
      else
        print_error "Failed to change default shell. Try running: chsh -s $FISH_PATH"
      fi
    else
      print_info "Shell not changed. You can manually switch to Fish with 'chsh -s $FISH_PATH'"
    fi
  else
    print_success "Fish is already your default shell"
  fi
else
  print_warning "Fish shell is not installed. Cannot set as default shell."
fi

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
print_section "Installation Complete"

print_success "Dotfiles have been installed successfully!"
print_info "Please restart your terminal to apply the changes."
print_info "For more information, see the README.md file."
