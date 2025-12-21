#!/bin/bash

set -e  # Exit on error

# --- OS DETECTION ---
detect_os() {
  OS_TYPE=""
  OS_DISTRO=""
  
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
    echo "Detected macOS"
  elif [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "linux"* ]]; then
    OS_TYPE="linux"
    
    # Check /etc/os-release for distribution info
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      OS_DISTRO="${ID:-unknown}"
      echo "Detected Linux distribution: $OS_DISTRO"
    else
      echo "Warning: Cannot determine Linux distribution"
      OS_DISTRO="unknown"
    fi
  else
    echo "Unsupported OS: $OSTYPE"
    echo "Supported platforms: macOS, Ubuntu, Debian, Alpine Linux"
    exit 1
  fi
}

# --- INSTALL SYSTEM PREREQUISITES FOR HOMEBREW ---
install_system_prerequisites() {
  echo "Installing system prerequisites for Homebrew..."
  
  case "$OS_DISTRO" in
    alpine)
      echo "Installing Alpine prerequisites..."
      apk update
      apk add --no-cache bash curl git procps build-base
      ;;
    ubuntu|debian)
      echo "Installing Debian/Ubuntu prerequisites..."
      sudo apt update
      sudo apt install -y build-essential curl git procps file
      ;;
    *)
      if [ "$OS_TYPE" = "linux" ]; then
        echo "Warning: Unknown Linux distribution. Homebrew installation may require manual prerequisites."
      fi
      ;;
  esac
}

# --- INSTALL HOMEBREW ---
install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed."
    return 0
  fi
  
  echo "Homebrew not found. Installing Homebrew..."
  
  if [ "$OS_TYPE" = "macos" ]; then
    # Install Homebrew on macOS
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  elif [ "$OS_TYPE" = "linux" ]; then
    # Install system prerequisites first
    install_system_prerequisites
    
    # Install Homebrew on Linux
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configure Homebrew environment for Linux
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "$HOME/.linuxbrew" ]; then
      eval "$($HOME/.linuxbrew/bin/brew shellenv)"
    fi
  fi
  
  echo "Homebrew installed successfully."
}

# --- INSTALL PACKAGES VIA HOMEBREW ---
install_packages() {
  echo "Installing packages via Homebrew..."
  
  # Update Homebrew
  brew update
  brew upgrade
  
  # Install packages (using consistent names across all platforms)
  echo "Installing development tools..."
  brew install neovim git curl wget node zsh yazi
  
  echo "All packages installed successfully."
}

# --- CONFIGURE ZSH ---
configure_zsh() {
  echo "Configuring Zsh..."
  
  # Make zsh the default shell if it's not already
  if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(command -v zsh)"
  else
    echo "Zsh is already the default shell."
  fi
  
  # Backup existing .zshrc if it exists
  if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
  fi
  
  # Symlink .zshrc from current directory to home directory
  ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"
  echo "Symlinked $(pwd)/.zshrc to $HOME/.zshrc"
}

# --- CONFIGURE STARSHIP ---
configure_starship() {
  echo "Configuring Starship..."
  
  # Check if Starship is installed
  if command -v starship >/dev/null 2>&1; then
    echo "Starship is already installed."
  else
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    echo "Starship installed."
  fi
  
  # Ensure .config directory exists
  mkdir -p "$HOME/.config"
  
  # Check if .config/starship directory exists
  if [ -d "$HOME/.config/starship" ]; then
    echo "Backing up existing .config/starship to .config/starship.backup"
    mv "$HOME/.config/starship" "$HOME/.config/starship.backup"
  fi
  
  mkdir -p "$HOME/.config/starship"
  
  # Symlink starship.toml from current directory to .config/starship
  ln -sf "$(pwd)/starship/starship.toml" "$HOME/.config/starship/starship.toml"
  echo "Symlinked starship.toml to $HOME/.config/starship/starship.toml"
}

# --- CONFIGURE NEOVIM ---
configure_neovim() {
  echo "Configuring Neovim..."
  
  # Ensure .config directory exists
  mkdir -p "$HOME/.config"
  
  # Check if nvim directory exists in .config
  if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing .config/nvim to .config/nvim.backup"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
  fi
  
  # Symlink nvim directory from current directory to .config/nvim
  ln -sf "$(pwd)/nvim" "$HOME/.config/nvim"
  echo "Symlinked $(pwd)/nvim to $HOME/.config/nvim"
}

# --- MAIN EXECUTION ---
main() {
  echo "========================================="
  echo "  Dotfiles Setup Script"
  echo "========================================="
  echo ""
  
  # Detect operating system
  detect_os
  echo ""
  
  # Install Homebrew (will install prerequisites if needed)
  install_homebrew
  echo ""
  
  # Install packages via Homebrew
  install_packages
  echo ""
  
  # Configure Zsh
  configure_zsh
  echo ""
  
  # Configure Starship
  configure_starship
  echo ""
  
  # Configure Neovim
  configure_neovim
  echo ""
  
  # --- COMPLETE ---
  echo "========================================="
  echo "  Setup Complete!"
  echo "========================================="
  echo ""
  echo "Next steps:"
  echo "  1. Restart your terminal or run 'source ~/.zshrc'"
  echo "  2. Open Neovim and run ':Lazy' to install plugins"
  echo ""
  echo "Happy coding!"
}

# Run main function
main
