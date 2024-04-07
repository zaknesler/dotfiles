#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then

    # Install Xcode command-line tools
    echo 'Installing Xcode Tools'
    echo '---------------------'
    xcode-select --install

    # Install Homebrew
    echo 'Installing Homebrew'
    echo '-------------------'
    /bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'

    # Install formulae from Brewfile
    echo 'Installing Brew Formulae'
    echo '------------------------'
    brew bundle

fi
