#!/bin/bash

# =============================================================================
# DOTFILES INSTALLATION SCRIPT
# =============================================================================
# This script automates the installation of dotfiles by creating symbolic links
# and installing required dependencies.

# Set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where the script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

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

    if [ ! -e "$source_file" ]; then
        print_error "Source file $source_file does not exist"
        return 1
    fi

    if [ -L "$target_file" ] && [ "$(readlink "$target_file")" = "$source_file" ]; then
        print_info "Symlink for $target_file already exists and is correct. Skipping."
        return 0
    fi

    backup_file "$target_file"

    print_info "Creating symlink from $source_file to $target_file"
    ln -sf "$source_file" "$target_file"

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

DEPENDENCIES=(fish fzf tmux neovim lolcat fortune)

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

read -p "Do you want to install dependencies? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
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


# Fish
mkdir -p "$HOME/.config/fish"
create_symlink "$DOTFILES_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
create_symlink "$DOTFILES_DIR/fish/cos_intro.fish" "$HOME/.config/fish/cos_intro.fish"

# Tmux
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Neovim
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"

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


CURRENT_SHELL_NAME="$(basename "$SHELL")"
FISH_PATH="$(command -v fish)"
if [ "$CURRENT_SHELL_NAME" != "fish" ]; then
    print_warning "Your current shell is not Fish."
    read -p "Do you want to change your default shell to Fish? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if chsh -s "$FISH_PATH"; then
            print_success "Default shell changed to Fish"
        else
            print_error "Failed to change default shell. Try running: chsh -s $FISH_PATH"
        fi
    else
        print_info "Shell not changed. You can manually switch to Fish with 'chsh -s $FISH_PATH'"
    fi
fi

print_info "For more information, see the README.md file."
