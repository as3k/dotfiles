# Installing my shell setup
Shells are a pretty personal thing and we all like ours a little bit different than anybody else's. my setup is still pretty basic and uses [oh my zsh](https://github.com/robbyrussell/oh-my-zsh) and (for now) a pretty basic vimrc. 

## Directories
to install my basic setup, clone this repo into your root directory and rename it `.shell` and then copy the `.zshrc` and `.vim/.vimrc` files to your root directory. After you copy those files into your root, use `zs` to source your new `.zshrc` file. 

## nvim config
create a symlink for nvim at `~/.config/nvim` for the nvim directory in dotfiles. this way Dein will handle all the plugins for nvim. 
