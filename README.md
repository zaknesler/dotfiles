# Dotfiles

This is the repository for all of my dotfiles for Linux/OSX. It uses [GNU Stow](https://www.gnu.org/software/stow/) to organize the configuration files, and follows the [XDG Base Directory specification](https://wiki.archlinux.org/index.php/XDG_Base_Directory) to keep my home (`~`) directory as clean as possible.

## Installation

If you're crazy enough to install somebody else's dotfiles, you may do so by following these steps:

1. Clone this repository to `~/.config/dotfiles` and `cd` into it:

    ```shell
    git clone https://github.com:zaknesler/dotfiles ~/.config/dotfiles

    cd ~/.config/dotfiles
    ```

2. Run the `install.sh` file to automatically install everything:

    ```shell
    bash install.sh
    ```

### Note

It is recommended that you take a long, thorough look through the files before installing. There is nothing malicious but it might be more involved to install than running a single `install.sh` file.

You might have to encourage the script along every now and then, but for the most part I tried to do as much automatically as possible.
