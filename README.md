# Dotfiles

This is the repository for all of my dotfiles for Linux/OSX/WSL2. It uses [GNU Stow](https://www.gnu.org/software/stow/) to organize the configuration files, and follows the [XDG Base Directory specification](https://wiki.archlinux.org/index.php/XDG_Base_Directory) to keep my home (`~`) directory as clean as possible.

This is relatively minimal as far as configuration goes; it will download and install GNU Stow (including Xcode tools and [Homebrew](https://brew.sh) if running on a Mac), install Zsh if necessary, download and configure [oh-my-zsh](https://ohmyz.sh), install [Vim Plug](https://github.com/junegunn/vim-plug), symlink directories to their final locations, and install all Brew formulae.

A lot of dotfile repositories will automatically configure a Mac by editing system defaults. I find that in most cases this is overkill, I am perfectly fine with tweaking things when necessary; also given that the same configuration file has been passed around for years, I'd bet that some of it is outdated.

## Installation

If you're crazy enough to install somebody else's dotfiles, you may do so by following these steps:

1. Clone this repository to `~/.config/dotfiles` and `cd` into it:

    ```shell
    git clone https://github.com/zaknesler/dotfiles.git ~/.config/dotfiles

    cd ~/.config/dotfiles
    ```

2. Run the `install.sh` file to automatically install everything:

    ```shell
    bash install.sh
    ```

### Note

It is recommended that you take a long, thorough look through the files before installing. There is nothing malicious but it might be more involved to install than running a single `install.sh` file.

You might have to help the script along at some points, as it is not intended to be a fully-featured, handle-every-case script. In fact, it's recommended that you copy, paste, and execute each section manually to ensure that nothing is skipped.
