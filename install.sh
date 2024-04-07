#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    # Install GNU Stow
    echo 'Installing GNU Stow'
    echo '-------------------'
    sudo apt install -y stow

elif [[ "$OSTYPE" == "darwin"* ]]; then

    # Install Xcode command-line tools
    echo 'Installing Xcode Tools'
    echo '---------------------'
    xcode-select --install

    # Install Homebrew
    echo 'Installing Homebrew'
    echo '-------------------'
    /bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'

    # Install GNU Stow
    echo 'Installing GNU Stow'
    echo '-------------------'
    brew install stow

    # Install formulae from Brewfile
    echo 'Installing Brew Formulae'
    echo '------------------------'
    brew bundle

fi

# Install Packer for Neovim
echo 'Installing packer.vim'
echo '------------------'
git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

# Symlink Stow directories
echo 'Symlinking Stow directories'
echo '---------------------------'
ls -d */ | xargs stow -t $HOME

echo 'Finished installing dotfiles!'
