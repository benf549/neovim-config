# Installation Instructions:
- install neovim (`sudo apt-get install neovim`) and place this file in `~/.config/nvim/init.vim`
- Then install vim-plug by running: 
```terminal
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
- Then install plugins using `:PlugInstall` from within the neovim editor
- Then install a nerdfont (https://github.com/ryanoasis/nerd-fonts) to make vim's nerd tree icons work correctly and set as the terminal font.

