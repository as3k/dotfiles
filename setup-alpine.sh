#!/bin/sh

# Minimal Alpine/iSH Setup Script
# Fast, lightweight installation for resource-constrained environments

set -e

echo "========================================="
echo "  Minimal Alpine Setup"
echo "========================================="
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- INSTALL PACKAGES ---
echo "Installing essential packages..."
apk update
apk add --no-cache \
  git \
  zsh \
  neovim \
  curl \
  shadow

echo "Packages installed successfully."
echo ""

# --- CONFIGURE ZSH ---
echo "Configuring Zsh..."

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
  echo "Backing up existing .zshrc to .zshrc.backup"
  mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Symlink minimal Alpine .zshrc
ln -sf "${SCRIPT_DIR}/.zshrc-alpine" "$HOME/.zshrc"
echo "Symlinked ${SCRIPT_DIR}/.zshrc-alpine to $HOME/.zshrc"

# Try to change default shell
if command -v chsh >/dev/null 2>&1; then
  ZSH_PATH="$(command -v zsh)"
  
  if [ -f /etc/shells ] && ! grep -q "^${ZSH_PATH}$" /etc/shells 2>/dev/null; then
    echo "Adding ${ZSH_PATH} to /etc/shells..."
    echo "${ZSH_PATH}" >> /etc/shells 2>/dev/null || echo "Warning: Could not add zsh to /etc/shells"
  fi
  
  if chsh -s "${ZSH_PATH}" 2>/dev/null; then
    echo "Default shell changed to zsh"
  else
    echo "Note: Run 'chsh -s ${ZSH_PATH}' to set zsh as default shell"
  fi
else
  echo "Note: chsh not available, manually set shell with: chsh -s \$(which zsh)"
fi

echo ""

# --- CONFIGURE NEOVIM ---
echo "Configuring Neovim..."

mkdir -p "$HOME/.config"

if [ -d "$HOME/.config/nvim" ]; then
  echo "Backing up existing .config/nvim to .config/nvim.backup"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup"
fi

ln -sf "${SCRIPT_DIR}/nvim" "$HOME/.config/nvim"
echo "Symlinked ${SCRIPT_DIR}/nvim to $HOME/.config/nvim"

echo ""

# --- COMPLETE ---
echo "========================================="
echo "  Setup Complete!"
echo "========================================="
echo ""
echo "Next steps:"
echo "  1. Run 'zsh' to start using Zsh"
echo "  2. Open Neovim with 'nvim' and run ':Lazy' to install plugins"
echo ""
echo "This is a minimal setup optimized for Alpine/iSH."
echo "For full features, use setup.sh on standard Linux systems."
echo ""
