<p align="center">
  <img height="70px" src="https://user-images.githubusercontent.com/7189795/222496059-5d1dfedb-3a0d-45d1-9b20-b364ab1ba7a5.svg" />
</p>

This is the repository for all of my dotfiles for Linux/Mac/Windows. It uses [GNU Stow](https://www.gnu.org/software/stow) to organize the configuration files, and follows the [XDG Base Directory specification](https://wiki.archlinux.org/index.php/XDG_Base_Directory) to keep my home directory (`~/`) as clean as possible.

#### Pre-requisites

- [Rust](https://rustup.rs)
- [Nushell](https://github.com/nushell/nushell?tab=readme-ov-file#installation)
- [Neovim](https://github.com/neovim/neovim)
- [GNU Stow](https://www.gnu.org/software/stow)
- [Homebrew](https://brew.sh) (Mac only)

#### Installation

1. Clone repository to `~/.config/dotfiles` and `cd` into it

    ```nushell
    git clone --depth 1 https://github.com/zaknesler/dotfiles.git ~/.config/dotfiles

    cd ~/.config/dotfiles
    ```

1. *Optional: Mac OS only*

    ```nushell
    # Install Xcode tools
    xcode-select --install

    # Install Homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Install formulae from ./Brewfile
    brew bundle
    ```

1. Install `nu_plugin_gstat` (enables git repo data)

    ```nushell
    cargo install nu_plugin_gstat
    let gstat = (which nu_plugin_gstat | get path | first)
    nu -c $'register '($gstat)'; version'
    ```

1. Symlink directories using Stow

    ```nushell
    cd ~/.config/dotfiles; ls -s | where type == dir | each { |dir| stow -t $env.HOME ($dir | get name) }
    ```
