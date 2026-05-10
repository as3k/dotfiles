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

. ~/.bash_git
# bun completions
[ -s "/Users/zg/.bun/_bun" ] && source "/Users/zg/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# Qbit shell integration
[[ -n "$QBIT" ]] && source "/Users/zg/Library/Application Support/qbit/integration.zsh"


# Added by Antigravity
export PATH="/Users/zg/.antigravity/antigravity/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# shellcheck shell=bash

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
\builtin typeset -ga precmd_functions
\builtin typeset -ga chpwd_functions
# shellcheck disable=SC2034,SC2296
precmd_functions=("${(@)precmd_functions:#__zoxide_hook}")
# shellcheck disable=SC2034,SC2296
chpwd_functions=("${(@)chpwd_functions:#__zoxide_hook}")
chpwd_functions+=(__zoxide_hook)
chpwd_functions+=(__gh_account_hook)

# =============================================================================
# Auto-switch gh account based on directory
# =============================================================================
function __gh_account_hook() {
    local msdev_dir="/Users/zg/www/msdev"
    local ms_account="zacharyg-ms"
    local personal_account="as3k"

    if [[ "$PWD" == "$msdev_dir"* ]]; then
        # Inside msdev — switch to MS account if not already active
        local current
        current=$(gh auth status 2>/dev/null | awk '/Active account: true/{found=1} found && /account /{print $NF; exit}')
        if [[ "$current" != "$ms_account" ]]; then
            gh auth switch --user "$ms_account" --hostname github.com &>/dev/null \
                && echo "gh: switched to $ms_account"
        fi
    else
        # Outside msdev — switch back to personal account if not already active
        local current
        current=$(gh auth status 2>/dev/null | awk '/Active account: true/{found=1} found && /account /{print $NF; exit}')
        if [[ "$current" != "$personal_account" ]]; then
            gh auth switch --user "$personal_account" --hostname github.com &>/dev/null \
                && echo "gh: switched to $personal_account"
        fi
    fi
}

# Report common issues.
function __zoxide_doctor() {
    [[ ${_ZO_DOCTOR:-1} -ne 0 ]] || return 0
    [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] || return 0

    _ZO_DOCTOR=0
    \builtin printf '%s\n' \
        'zoxide: detected a possible configuration issue.' \
        'Please ensure that zoxide is initialized right at the end of your shell configuration file (usually ~/.zshrc).' \
        '' \
        'If the issue persists, consider filing an issue at:' \
        'https://github.com/ajeetdsouza/zoxide/issues' \
        '' \
        'Disable this message by setting _ZO_DOCTOR=0.' \
        '' >&2
}

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

# Jump to a directory using only keywords.
function __zoxide_z() {
    __zoxide_doctor
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$#" -eq 2 ]] && [[ "$1" = "--" ]]; then
        __zoxide_cd "$2"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" && __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    __zoxide_doctor
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

function z() {
    __zoxide_z "$@"
}

function zi() {
    __zoxide_zi "$@"
}

# Completions.
if [[ -o zle ]]; then
    __zoxide_result=''

    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            # Show completions for local directories.
            _cd -/

        elif [[ "${words[-1]}" == '' ]]; then
            # Show completions for Space-Tab.
            # shellcheck disable=SC2086
            __zoxide_result="$(\command zoxide query --exclude "$(__zoxide_pwd || \builtin true)" --interactive -- ${words[2,-1]})" || __zoxide_result=''

            # Set a result to ensure completion doesn't re-run
            compadd -Q ""

            # Bind '\e[0n' to helper function.
            \builtin bindkey '\e[0n' '__zoxide_z_complete_helper'
            # Sends query device status code, which results in a '\e[0n' being sent to console input.
            \builtin printf '\e[5n'

            # Report that the completion was successful, so that we don't fall back
            # to another completion function.
            return 0
        fi
    }

    function __zoxide_z_complete_helper() {
        if [[ -n "${__zoxide_result}" ]]; then
            # shellcheck disable=SC2034,SC2296
            BUFFER="z ${(q-)__zoxide_result}"
            __zoxide_result=''
            \builtin zle reset-prompt
            \builtin zle accept-line
        else
            \builtin zle reset-prompt
        fi
    }
    \builtin zle -N __zoxide_z_complete_helper

    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete z
fi

# =============================================================================
#
# To initialize zoxide, add this to your shell configuration file (usually ~/.zshrc):
#
# eval "$(zoxide init zsh)"


# opencode
export PATH=/Users/zg/.opencode/bin:$PATH

# Open SSH tunnel to msstage MySQL (port 3306) — connect any MySQL client to 127.0.0.1:3306
alias msstage-db='ssh -f -L 3306:127.0.0.1:3306 msstage -N && echo "msstage tunnel up on 3306"'
export EDITOR=nvim
# export LINEAR_API_KEY=... set via env or secrets
