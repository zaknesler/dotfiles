#!/bin/bash

# It is recommended that you do not run this script automatically, but instead
# just copy each command and run them individually. This way nothing unexpected
# happens while installing. Or just run it; what's the worst that can happen?

# Install oh-my-zsh
echo 'Install oh-my-zsh'
echo '-----------------'
rm -rf $HOME/.oh-my-zsh
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
curl -L https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Install ZSH Autosuggestions
echo 'Install ZSH Autosuggestions'
echo '---------------------------'
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/config/oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Powerlevel10k
echo 'Install Powerlevel10k'
echo '---------------------'
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/config/oh-my-zsh/custom}/themes/powerlevel10k

# OS-specific
if [[ "$OSTYPE" == "linux-gnu"* ]]; then

    # Install GNU Stow
    echo 'Install GNU Stow'
    echo '----------------'
    apt install -y stow

elif [[ "$OSTYPE" == "darwin"* ]]; then

    # Install Homebrew
    echo 'Install Homebrew'
    echo '----------------'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install GNU Stow
    echo 'Install GNU Stow'
    echo '----------------'
    brew install stow

fi

# Symlink Stow directories
echo 'Symlink Stow directories'
echo '------------------------'
ls -d */ | xargs stow

# Install Vim Plug
echo 'Install Vim Plug'
echo '----------------'
curl -fLo ${XDG_CONFIG_HOME:-$HOME/.config}/vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Vim Plug installed. Run :PlugInstall in Vim to install plugins."
