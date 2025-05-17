#!/bin/bash

# Detect OS and install packages accordingly
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  # Linux (Debian/Ubuntu)
  sudo apt update && sudo apt install -y \
    zsh neovim git curl wget nodejs
elif [[ "$OSTYPE" == "darwin"* ]]; then
  # macOS
  # Check if Homebrew is installed
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  brew update
  brew upgrade
  # Install packages
  brew install neovim git curl wget node
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

# Check if Starship is installed
if command -v starship >/dev/null 2>&1; then
  echo "Starship is installed."
else
  echo "Installing Starship..."
  # Download and install Starship
  curl -sS https://starship.rs/install.sh | sh -s -- -y
  echo "Starship installed."
fi

# Make zsh the default shell if it's not already
if [ "$SHELL" != "$(command -v zsh)" ]; then
  echo "Changing default shell to zsh..."
  chsh -s "$(command -v zsh)"
fi

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
  echo "Backing up existing .zshrc to .zshrc.backup"
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Symlink .zshrc from current directory to home directory
ln -sf "$(pwd)/.zshrc" "$HOME/.zshrc"
echo "Symlinked $(pwd)/.zshrc to $HOME/.zshrc"

# Check if .config directory exists in $HOME
if [ -d "$HOME/.config" ]; then
  echo ".config directory exists in $HOME."
else
  echo "Creating .config directory..."
  mkdir -p "$HOME/.config"
fi

# Check if .config/starship directory exists
if [ -d "$HOME/.config/starship" ]; then
  echo ".config/starship directory exists in $HOME."
  echo "Backing up existing .config/starship to .config/starship.backup"
  mv "$HOME/.config/starship" "$HOME/.config/starship.backup"
  mkdir -p "$HOME/.config/starship"
else
  echo "Creating .config/starship directory..."
  mkdir -p "$HOME/.config/starship"
fi
# Symlink starship.toml from current directory to .config/starship
ln -sf "$(pwd)/starship/starship.toml" "$HOME/.config/starship/starship.toml"
echo "Symlinked starship.toml to $HOME/.config/starship/starship.toml"

# Check if nvim directory exists in .config
if [ -d "$HOME/.config/nvim" ]; then
  echo ".config/nvim directory exists in $HOME."
else
  echo "Creating .config/nvim directory..."
  mkdir -p "$HOME/.config/nvim"
fi
# Symlink init.lua from current directory to .config/nvim
ln -sf "$(pwd)/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -sf "$(pwd)/nvim/lazy-lock.json" "$HOME/.config/nvim/lazy-lock.json"
echo "Symlinked init.lua to $HOME/.config/nvim/init.lua"

echo "Setup complete. Please restart your terminal or run 'source ~/.zshrc' to apply changes."
echo "You may need to install additional plugins for Neovim. Check init.lua for details."
echo "If you encounter any issues, please refer to the documentation for the respective tools."
echo "Happy coding!"
echo "If you want to install the plugins, run :Lazy in Neovim."