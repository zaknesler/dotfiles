#!/bin/bash

# It is recommended that you do not run this script automatically, but instead
# just copy each section and run them manually. This way nothing unexpected
# happens. Or just run it; what's the worst that can happen?

# Pre-configuration
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# OS-specific install of GNU Stow
if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    # Install GNU Stow
    echo 'Installing GNU Stow'
    echo '-------------------'
    sudo apt install -y stow

    # If ZSH is not detected, install it
    if [ -z "$ZSH_VERSION" ]; then

        # Install ZSH
        echo 'Installing ZSH'
        echo '--------------'
        sudo apt install -y zsh

    fi

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

# Install oh-my-zsh
echo 'Installing oh-my-zsh'
echo '--------------------'
curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install ZSH Autosuggestions
echo 'Installing ZSH Autosuggestions'
echo '------------------------------'
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/config/oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Powerlevel10k
echo 'Installing Powerlevel10k'
echo '------------------------'
git clone --depth=1 https://github.com/romkatv/powerlevel10k ${ZSH_CUSTOM:-$HOME/config/oh-my-zsh/custom}/themes/powerlevel10k

# install zsh-nvm
echo 'installing zsh-nvm'
echo '------------------'
git clone https://github.com/lukechilds/zsh-nvm ${ZSH_CUSTOM:-$HOME/config/oh-my-zsh/custom}/plugins/zsh-nvm

# Install Packer for Neovim
echo 'Installing packer.vim'
echo '------------------'
git clone --depth 1 https://github.com/wbthomason/packer.nvim $HOME/.local/share/nvim/site/pack/packer/start/packer.nvim

# Symlink Stow directories
echo 'Symlinking Stow directories'
echo '---------------------------'
ls -d */ | xargs stow -t $HOME

# Create directory for ZSH history
mkdir -p $HOME/.local/share/zsh

echo 'Finished installing dotfiles!'
