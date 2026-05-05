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
  if [ -e "$target" ] || [ -L "$target" ]; then
    local base_name="$(basename "$target")"
    local dir_name="$(dirname "$target")"
    local backup_file="$dir_name/${base_name}.backup.$(date +%Y%m%d%H%M%S)"
    print_info "Backing up $target to $backup_file"
    if mv "$target" "$backup_file"; then
      return 0
    fi
    print_error "Failed to back up $target"
    return 1
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
  backup_file "$target_file" || true

  # Create parent directory if it doesn't exist
  mkdir -p "$(dirname "$target_file")"

  # Create the symlink
  print_info "Creating symlink from $source_file to $target_file"
  if ln -sfn "$source_file" "$target_file"; then
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

  local reply
  read -r -p "$prompt ($options) " reply

  if [ -z "$reply" ]; then
    reply="$default"
  fi

  if [[ $reply =~ ^[Yy]$ ]]; then
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
elif [ "$(uname -o 2>/dev/null)" == "Msys" ] || [ "$(uname -o 2>/dev/null)" == "Cygwin" ] || [ -n "${WSLENV:-}" ]; then
  OS="windows"
  print_success "Windows (WSL/Cygwin/MSYS) detected"
else
  print_warning "Unknown operating system. Some features may not work correctly."
fi

# -----------------------------------------------------------------------------
# Dependencies Installation
# -----------------------------------------------------------------------------
print_section "Installing Dependencies"

MIN_NVIM_MAJOR=0
MIN_NVIM_MINOR=11

MACOS_DEPENDENCIES=(git fzf tmux lolcat fortune starship zoxide eza ripgrep fd bat neovim zsh)
DEBIAN_DEPENDENCIES=(curl unzip git fzf tmux lolcat fortune-mod zoxide ripgrep fd-find bat zsh)
REDHAT_DEPENDENCIES=(curl unzip git fzf tmux lolcat fortune-mod starship zoxide eza ripgrep fd-find bat zsh)

install_homebrew() {
  if ! command_exists brew; then
    print_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    print_success "Homebrew is already installed"
  fi
}

install_brew_packages() {
  install_homebrew
  print_info "Updating Homebrew..."
  brew update || print_warning "Homebrew update failed; continuing with package installation"

  for package in "$@"; do
    if brew list --formula "$package" >/dev/null 2>&1; then
      print_success "$package is already installed"
    else
      brew install "$package" || print_warning "Failed to install $package with Homebrew"
    fi
  done
}

install_apt_packages() {
  if ! command_exists apt; then
    print_warning "apt was not found. Please install dependencies manually."
    return 0
  fi

  sudo apt update || { print_error "apt update failed"; return 1; }
  for package in "$@"; do
    sudo apt install -y "$package" || print_warning "Failed to install $package with apt"
  done

  if command_exists fdfind && ! command_exists fd; then
    mkdir -p "$HOME/.local/bin"
    ln -sfn "$(command -v fdfind)" "$HOME/.local/bin/fd" || print_warning "Failed to create fd compatibility symlink"
  fi

  if command_exists batcat && ! command_exists bat; then
    mkdir -p "$HOME/.local/bin"
    ln -sfn "$(command -v batcat)" "$HOME/.local/bin/bat" || print_warning "Failed to create bat compatibility symlink"
  fi
}

nvim_version_meets_minimum() {
  command_exists nvim || return 1

  local version major minor
  version="$(nvim --version | awk 'NR == 1 {print $2}' | sed 's/^v//')"
  major="${version%%.*}"
  version="${version#*.}"
  minor="${version%%.*}"

  [[ "$major" =~ ^[0-9]+$ ]] || return 1
  [[ "$minor" =~ ^[0-9]+$ ]] || return 1

  if [ "$major" -gt "$MIN_NVIM_MAJOR" ]; then
    return 0
  fi

  if [ "$major" -eq "$MIN_NVIM_MAJOR" ] && [ "$minor" -ge "$MIN_NVIM_MINOR" ]; then
    return 0
  fi

  return 1
}

install_neovim_linux_release() {
  if nvim_version_meets_minimum; then
    print_success "Neovim $(nvim --version | awk 'NR == 1 {print $2}') is already installed"
    return 0
  fi

  if ! command_exists curl; then
    print_error "curl is required to install the official Neovim release"
    return 1
  fi

  local machine asset_arch archive url install_dir tmp_archive
  machine="$(uname -m)"
  case "$machine" in
    x86_64|amd64)
      asset_arch="x86_64"
      ;;
    aarch64|arm64)
      asset_arch="arm64"
      ;;
    *)
      print_error "Unsupported Linux architecture for Neovim release: $machine"
      return 1
      ;;
  esac

  archive="nvim-linux-${asset_arch}.tar.gz"
  url="https://github.com/neovim/neovim/releases/latest/download/${archive}"
  install_dir="/opt/nvim-linux-${asset_arch}"
  tmp_archive="/tmp/${archive}"

  print_info "Installing official Neovim release from $url"
  curl -fL "$url" -o "$tmp_archive" || { print_error "Failed to download Neovim"; return 1; }
  sudo rm -rf "$install_dir"
  sudo tar -C /opt -xzf "$tmp_archive"
  sudo ln -sfn "$install_dir/bin/nvim" /usr/local/bin/nvim
  hash -r 2>/dev/null || true

  if nvim_version_meets_minimum; then
    print_success "Installed Neovim $(nvim --version | awk 'NR == 1 {print $2}')"
    return 0
  fi

  print_error "Neovim installation completed, but nvim is still older than ${MIN_NVIM_MAJOR}.${MIN_NVIM_MINOR}"
  print_info "Make sure /usr/local/bin appears before /usr/bin in PATH."
  return 1
}

ensure_modern_neovim_for_config() {
  if nvim_version_meets_minimum; then
    return 0
  fi

  print_warning "This Neovim config expects Neovim ${MIN_NVIM_MAJOR}.${MIN_NVIM_MINOR}+."

  case $OS in
    macos)
      if confirm "Do you want to install or upgrade Neovim with Homebrew?" "y"; then
        install_brew_packages neovim || print_warning "Failed to install Neovim with Homebrew"
      fi
      ;;
    debian|wsl)
      if confirm "Do you want to install Neovim ${MIN_NVIM_MAJOR}.${MIN_NVIM_MINOR}+ from the official release?" "y"; then
        if ! command_exists curl; then
          sudo apt update && sudo apt install -y curl || {
            print_warning "Failed to install curl; cannot download Neovim"
            return 0
          }
        fi
        install_neovim_linux_release || print_warning "Failed to install modern Neovim from the official release"
      fi
      ;;
    redhat)
      if confirm "Do you want to install Neovim ${MIN_NVIM_MAJOR}.${MIN_NVIM_MINOR}+ from the official release?" "y"; then
        if ! command_exists curl; then
          if command_exists dnf; then
            sudo dnf install -y curl || {
              print_warning "Failed to install curl; cannot download Neovim"
              return 0
            }
          else
            sudo yum install -y curl || {
              print_warning "Failed to install curl; cannot download Neovim"
              return 0
            }
          fi
        fi
        install_neovim_linux_release || print_warning "Failed to install modern Neovim from the official release"
      fi
      ;;
    linux)
      if command_exists curl && confirm "Do you want to install Neovim ${MIN_NVIM_MAJOR}.${MIN_NVIM_MINOR}+ from the official release?" "y"; then
        install_neovim_linux_release || print_warning "Failed to install modern Neovim from the official release"
      else
        print_warning "Install Neovim ${MIN_NVIM_MAJOR}.${MIN_NVIM_MINOR}+ manually before opening this config."
      fi
      ;;
    *)
      print_warning "Install Neovim ${MIN_NVIM_MAJOR}.${MIN_NVIM_MINOR}+ manually before opening this config."
      ;;
  esac
}

install_dependencies() {
  case $OS in
    macos)
      print_info "Installing required packages with Homebrew..."
      install_brew_packages "${MACOS_DEPENDENCIES[@]}"
      ;;
    debian|wsl)
      print_info "Installing required packages with apt..."
      install_apt_packages "${DEBIAN_DEPENDENCIES[@]}"
      install_neovim_linux_release || print_warning "Failed to install modern Neovim from the official release"
      ;;
    redhat)
      print_info "Installing required packages with dnf/yum..."
      if command_exists dnf; then
        sudo dnf install -y "${REDHAT_DEPENDENCIES[@]}" || print_warning "Some dependencies failed to install with dnf"
      else
        sudo yum install -y "${REDHAT_DEPENDENCIES[@]}" || print_warning "Some dependencies failed to install with yum"
      fi
      install_neovim_linux_release || print_warning "Failed to install modern Neovim from the official release"
      ;;
    *)
      print_warning "Automatic dependency installation is not supported on this OS."
      print_info "Please install these tools manually: curl unzip git fzf tmux lolcat fortune starship zoxide eza ripgrep fd bat neovim 0.11+ zsh"
      ;;
  esac
}

# Fast path: only install Neovim config and its required Neovim version
if $NVIM_ONLY; then
  print_section "Neovim Configuration"
  ensure_modern_neovim_for_config
  install_nvim_config
  exit $?
fi

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
    debian|wsl)
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
  ensure_modern_neovim_for_config
  install_nvim_config || print_warning "Neovim configuration was not installed"
else
  print_info "Skipping Neovim configuration"
fi

# iTerm2 (macOS only)
if [ "$OS" == "macos" ]; then
  print_info "iTerm2 configurations need to be imported manually from:"
  print_info "$DOTFILES_DIR/iterm2/profiles/"
fi

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
print_section "Installation Complete"

print_success "Dotfiles have been installed successfully!"
print_info "Please restart your terminal to apply the changes."
print_info "For more information, see the README.md file."
