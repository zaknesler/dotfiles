<p align="center">
  <img height="70px" src="https://user-images.githubusercontent.com/7189795/222496059-5d1dfedb-3a0d-45d1-9b20-b364ab1ba7a5.svg" />
</p>

This is the repository for all of my dotfiles for Linux/OSX/WSL2. It uses [GNU Stow](https://www.gnu.org/software/stow/) to organize the configuration files, and follows the [XDG Base Directory specification](https://wiki.archlinux.org/index.php/XDG_Base_Directory) to keep my home (`~`) directory as clean as possible.

A lot of dotfile repositories will automatically configure a Mac by editing system defaults. I find that in most cases this is overkill, I am perfectly fine with tweaking things when necessary; also given that the same configuration file has been passed around for years, I'd bet that some of it is outdated.

## Installation

1. Clone repository to `~/.config/dotfiles` and `cd` into it:

    ```shell
    git clone https://github.com/zaknesler/dotfiles.git ~/.config/dotfiles

    cd ~/.config/dotfiles
    ```

2. Run the `install.sh` file to automatically install everything:

    ```shell
    bash install.sh
    ```
