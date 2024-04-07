<p align="center">
  <img height="70px" src="https://user-images.githubusercontent.com/7189795/222496059-5d1dfedb-3a0d-45d1-9b20-b364ab1ba7a5.svg" />
</p>

This is the repository for all of my dotfiles for Linux/Mac/Windows. It uses [GNU Stow](https://www.gnu.org/software/stow) to organize the configuration files, and follows the [XDG Base Directory specification](https://wiki.archlinux.org/index.php/XDG_Base_Directory) to keep my home directory (`~/`) as clean as possible.

### Pre-requisites

- [Nushell](https://github.com/nushell/nushell)
- [Neovim](https://github.com/neovim/neovim)
- [GNU Stow](https://www.gnu.org/software/stow)

### Installation

(wip for now)

1. Clone repository to `~/.config/dotfiles` and `cd` into it:

    ```shell
    git clone https://github.com/zaknesler/dotfiles.git ~/.config/dotfiles

    cd ~/.config/dotfiles
    ```

2. Install `nu_plugin_gstat`

    ```nushell
    cargo install nu_plugin_gstat
    let gstat = (which nu_plugin_gstat | get path | first)
    nu -c $'register '($plugin)'; version'
    ```

3. Install Stylua

    ```nushell
    cargo install stylua
    ```

4. Symlink directories using Stow

    ```nushell
    ls ~/.config/dotfiles | where type == dir | each { |dir| stow -t $env.HOME ($dir | get name) }
    ```
