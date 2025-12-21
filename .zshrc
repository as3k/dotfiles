# --- Auto cd ---
setopt AUTO_CD

# --- Prompt & Starship ---
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh 2>/dev/null)" || true
fi

# --- Aliases ---
ZSH_ALIAS="$HOME/.shell/.zsh/zshalias"
if [ -f "$ZSH_ALIAS" ]; then
    source "$ZSH_ALIAS"
else
    print "404: $ZSH_ALIAS not found."
fi

# --- SSH AGENT ---
# Start the ssh-agent if not running (skip if ssh-agent not available)
if command -v ssh-agent >/dev/null 2>&1; then
  if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" 2>/dev/null
    ssh-add ~/.ssh/id_rsa 2>/dev/null
  fi
fi

# --- Node & Yarn ---
# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# Yarn global binaries (only if yarn is installed)
if command -v yarn >/dev/null 2>&1; then
  export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$(yarn global bin 2>/dev/null):$PATH"
fi

# --- Applications ---
# Visual Studio Code command line (macOS)
if [ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
fi

# --- Lando ----
if [ -d "$HOME/.lando/bin" ]; then
  export PATH="$HOME/.lando/bin:$PATH"
fi

# --- Homebrew ---
# Only load Homebrew on systems that have it installed
if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -x "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x "/usr/local/bin/brew" ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# --- Claude ---
# export PATH="$HOME/.claude/bin:$PATH"
export PATH="$(npm prefix -g)/bin:$PATH"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/bin:$PATH"
