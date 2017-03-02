# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="hyperzsh"

# Would you like to use another custom folder than $ZSH/custom?
 ZSH_CUSTOM=$HOME/.shell/.zsh/custom

# Which plugins would you like to load?
plugins=(git node npm ssh-agent)

# ZSH Source
source $ZSH/oh-my-zsh.sh

# Import my aliases if they exist
if [ -f $HOME/.shell/.zsh/zshalias ]; then
	source $HOME/.shell/.zsh/zshalias
else
	print "404: $HOME/.shell/.zsh/zshalias not found."
fi

# Add support for ssh-agent
zstyle :omz:plugins:ssh-agent identities id_rsa


function lvserver() {
    if [ "$HOST" = "dev.zacharyguerrero.com" ]; then
        php artisan serv --host=$DIP --port=8000
    elif [ "$HOST" = "helios" ]; then 
        php artisan serv --host=$IP --port=8000
    else
        print "$HOST"
    fi
}

