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
    if [ -f "$1" ] || [ -d "$1" ] || [ -L "$1" ]; then
        local backup_file="$1.backup.$(date +%Y%m%d%H%M%S)"
        print_info "Backing up $1 to $backup_file"
        mv "$1" "$backup_file"
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
    
    backup_file "$target_file"
    
    print_info "Creating symlink from $source_file to $target_file"
    ln -s "$source_file" "$target_file"
    
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
            brew install zsh starship fzf tmux neovim lolcat fortune
            ;;
        debian)
            print_info "Installing required packages with apt..."
            sudo apt update
            sudo apt install -y zsh starship fzf tmux neovim lolcat fortune
            ;;
        redhat)
            print_info "Installing required packages with dnf/yum..."
            if command_exists dnf; then
                sudo dnf install -y zsh fzf tmux neovim lolcat fortune
            else
                sudo yum install -y zsh fzf tmux neovim lolcat fortune
            fi
            ;;
        *)
            print_warning "Automatic dependency installation is not supported on this OS."
            print_info "Please install the following dependencies manually:"
            print_info "- zsh"
            print_info "- starship"
            print_info "- fzf"
            print_info "- tmux"
            print_info "- neovim"
            print_info "- lolcat"
            print_info "- fortune"
            ;;
    esac
}

read -p "Do you want to install dependencies? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    install_dependencies
else
    print_info "Skipping dependency installation"
fi

# -----------------------------------------------------------------------------
# Symlink Creation
# -----------------------------------------------------------------------------
print_section "Creating Symbolic Links"

# Create ~/.config directory if it doesn't exist
mkdir -p "$HOME/.config"

# Zsh
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/zsh/.zprofile" "$HOME/.zprofile"
create_symlink "$DOTFILES_DIR/zsh/.cos_intro.zsh" "$HOME/.cos_intro.zsh"

# Starship
mkdir -p "$HOME/.config/starship"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship/starship.toml"

# Tmux
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Vim
# create_symlink "$DOTFILES_DIR/vim/.vimrc" "$HOME/.vimrc"

# Neovim
# mkdir -p "$HOME/.config/nvim"
create_symlink "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
# create_symlink "$DOTFILES_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
# create_symlink "$DOTFILES_DIR/nvim/lua" "$HOME/.config/nvim/lua"
# create_symlink "$DOTFILES_DIR/nvim/after" "$HOME/.config/nvim/after"

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
print_info "Please restart your terminal or run 'source ~/.zshrc' to apply the changes."

if [ "$SHELL" != "$(which zsh)" ]; then
    print_warning "Your current shell is not Zsh."
    read -p "Do you want to change your default shell to Zsh? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh -s "$(which zsh)"
        print_success "Default shell changed to Zsh"
    else
        print_info "Shell not changed. You can manually switch to Zsh with 'chsh -s $(which zsh)'"
    fi
fi

print_info "For more information, see the README.md file."
