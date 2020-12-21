#!/bin/bash

# It is recommended that you do not run this script automatically, but instead
# just copy each command and run them individually. This way nothing unexpected
# happens while installing. Or just run it; what's the worst that can happen?

# Install Xcode command-line tools
echo 'Installing Xcode Tools'
echo '---------------------'
xcode-select --install

# Install oh-my-zsh
echo 'Installing oh-my-zsh'
echo '--------------------'
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# OS-specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    # Install GNU Stow
    echo 'Installing GNU Stow'
    echo '-------------------'
    apt install -y stow

elif [[ "$OSTYPE" == "darwin"* ]]; then

    # Install Homebrew
    echo 'Installing Homebrew'
    echo '-------------------'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install GNU Stow
    echo 'Installing GNU Stow'
    echo '-------------------'
    brew install stow

fi

# Symlink Stow directories
echo 'Symlinking Stow directories'
echo '---------------------------'
ls -d */ | xargs stow -t $HOME

# Install ZSH Autosuggestions
echo 'Installing ZSH Autosuggestions'
echo '------------------------------'
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/config/oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Powerlevel10k
echo 'Installing Powerlevel10k'
echo '------------------------'
git clone --depth=1 https://github.com/romkatv/powerlevel10k ${ZSH_CUSTOM:-$HOME/config/oh-my-zsh/custom}/themes/powerlevel10k

# Install Vim Plug
echo 'Installing Vim Plug'
echo '-------------------'
curl -fLo ${XDG_CONFIG_HOME:-$HOME/.config}/vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Vim Plug installed. Run :PlugInstall in Vim to install plugins."

# Install formulae from Brewfile
echo 'Installing Brew Formulae'
echo '------------------------'
brew bundle

echo 'Finished installing dotfiles!'
