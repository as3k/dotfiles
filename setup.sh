#!/bin/bash

set -e  # Exit on error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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

# --- CHECK IF PACKAGE IS INSTALLED ON ALPINE ---
check_package_alpine() {
  local package=$1
  apk info --installed "$package" >/dev/null 2>&1
}

# --- INSTALL PACKAGES ON ALPINE ---
install_packages_alpine() {
  echo "Checking packages via Alpine package manager (apk)..."
  
  # List of packages to check/install
  local packages=(
    "bash"
    "curl"
    "wget"
    "git"
    "neovim"
    "nodejs"
    "npm"
    "zsh"
    "starship"
  )
  
  local packages_to_install=()
  
  # Check which packages are missing
  for package in "${packages[@]}"; do
    if check_package_alpine "$package"; then
      echo "✓ $package is already installed"
    else
      echo "✗ $package is not installed"
      packages_to_install+=("$package")
    fi
  done
  
  # Install missing packages
  if [ ${#packages_to_install[@]} -gt 0 ]; then
    echo "Installing missing packages: ${packages_to_install[*]}"
    apk update
    apk add --no-cache "${packages_to_install[@]}"
    echo "All missing packages installed successfully."
  else
    echo "All Alpine packages are already installed."
  fi
}

# --- INSTALL SYSTEM PREREQUISITES FOR HOMEBREW ---
install_system_prerequisites() {
  echo "Installing system prerequisites for Homebrew..."
  
  case "$OS_DISTRO" in
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
  # Skip Homebrew on Alpine - it's not supported with musl libc
  if [ "$OS_DISTRO" = "alpine" ]; then
    echo "Skipping Homebrew installation on Alpine Linux (uses native apk package manager)"
    return 0
  fi
  
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

# --- CHECK IF PACKAGE IS INSTALLED VIA HOMEBREW ---
check_package_brew() {
  local package=$1
  brew list "$package" >/dev/null 2>&1
}

# --- INSTALL PACKAGES VIA HOMEBREW ---
install_packages() {
  # Use Alpine's native package manager on Alpine Linux
  if [ "$OS_DISTRO" = "alpine" ]; then
    install_packages_alpine
    return 0
  fi
  
  echo "Checking packages via Homebrew..."
  
  # List of packages to check/install
  local packages=(
    "neovim"
    "git"
    "curl"
    "wget"
    "node"
    "zsh"
    "starship"
  )
  
  local packages_to_install=()
  
  # Check which packages are missing
  for package in "${packages[@]}"; do
    if check_package_brew "$package"; then
      echo "✓ $package is already installed"
    else
      echo "✗ $package is not installed"
      packages_to_install+=("$package")
    fi
  done
  
  brew update
  
  # Install missing packages
  if [ ${#packages_to_install[@]} -gt 0 ]; then
    echo "Installing missing packages: ${packages_to_install[*]}"
    brew install "${packages_to_install[@]}"
    echo "All missing packages installed successfully."
  else
    echo "All Homebrew packages are already installed."
  fi
}

# --- CONFIGURE ZSH ---
configure_zsh() {
  echo "Configuring Zsh..."
  
  # Make zsh the default shell if it's not already
  local zsh_path
  zsh_path="$(command -v zsh)"
  
  if [ "$SHELL" != "$zsh_path" ]; then
    echo "Changing default shell to zsh..."
    
      # Check if chsh command exists
      if command -v chsh >/dev/null 2>&1; then
      
        # Add zsh to /etc/shells if not present (needed for chsh on some systems)
        if [ -f /etc/shells ] && ! grep -q "^${zsh_path}$" /etc/shells 2>/dev/null; then
          echo "Adding ${zsh_path} to /etc/shells..."
          echo "${zsh_path}" | sudo tee -a /etc/shells >/dev/null 2>&1 || echo "Warning: Could not add zsh to /etc/shells"
        fi
        
        # Try to change shell
        if chsh -s "${zsh_path}" 2>/dev/null; then
          echo "✓ Default shell changed to zsh"
        else
          echo "Warning: Could not change default shell. You may need to run 'chsh -s ${zsh_path}' manually."
        fi
    else
      echo "Warning: chsh command not found. Skipping shell change. You can manually run 'chsh -s ${zsh_path}' later."
    fi
  else
    echo "✓ Zsh is already the default shell."
  fi
  
  # Backup existing .zshrc if it exists
  if [ -f "$HOME/.zshrc" ]; then
    echo "✓ Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
  fi
  
  # Symlink .zshrc from script directory to home directory
  ln -sf "${SCRIPT_DIR}/.zshrc" "$HOME/.zshrc"
  echo "✓ Symlinked ${SCRIPT_DIR}/.zshrc to $HOME/.zshrc"
}

# --- CONFIGURE STARSHIP ---
configure_starship() {
  echo "Configuring Starship..."
  
  # Check if Starship is installed
  if command -v starship >/dev/null 2>&1; then
    echo "✓ Starship is already installed."
  else
    # Skip installation on Alpine since it's handled by apk
    if [ "$OS_DISTRO" != "alpine" ]; then
      echo "Installing Starship..."
      curl -sS https://starship.rs/install.sh | sh -s -- -y
      echo "✓ Starship installed."
    fi
  fi
  
  # Ensure .config directory exists
  mkdir -p "$HOME/.config"
  
  # Check if .config/starship directory exists
  if [ -d "$HOME/.config/starship" ]; then
    echo "✓ Backing up existing .config/starship to .config/starship.backup"
    mv "$HOME/.config/starship" "$HOME/.config/starship.backup"
  fi
  
  mkdir -p "$HOME/.config/starship"
  
  # Symlink starship.toml from script directory to .config/starship
  ln -sf "${SCRIPT_DIR}/starship/starship.toml" "$HOME/.config/starship/starship.toml"
  echo "✓ Symlinked starship.toml to $HOME/.config/starship/starship.toml"
}

# --- CONFIGURE NEOVIM ---
configure_neovim() {
  echo "Configuring Neovim..."
  
  # Ensure .config directory exists
  mkdir -p "$HOME/.config"
  
  # Check if nvim directory exists in .config
  if [ -d "$HOME/.config/nvim" ]; then
    echo "✓ Backing up existing .config/nvim to .config/nvim.backup"
    mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
  fi
  
  # Symlink nvim directory from script directory to .config/nvim
  ln -sf "${SCRIPT_DIR}/nvim" "$HOME/.config/nvim"
  echo "✓ Symlinked ${SCRIPT_DIR}/nvim to $HOME/.config/nvim"
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
