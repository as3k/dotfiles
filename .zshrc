# --- Auto cd ---
setopt AUTO_CD

# --- Prompt & Starship ---
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# --- Aliases ---
ZSH_ALIAS="$HOME/.shell/.zsh/zshalias"
if [ -f "$ZSH_ALIAS" ]; then
    source "$ZSH_ALIAS"
else
    print "404: $ZSH_ALIAS not found."
fi

# --- SSH AGENT ---
# Start the ssh-agent if not running
if [ -z "$SSH_AUTH_SOCK" ]; then
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa 2>/dev/null
fi

# --- Node & Yarn ---
# NVM (Node Version Manager)
export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.nvm}/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Yarn global binaries
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$(yarn global bin):$PATH"

# --- Applications ---
# Visual Studio Code command line
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"

# Lando
export PATH="$HOME/.lando/bin:$PATH"