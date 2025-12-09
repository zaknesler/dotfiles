<p align="center">
  <img height="70px" src="https://user-images.githubusercontent.com/7189795/222496059-5d1dfedb-3a0d-45d1-9b20-b364ab1ba7a5.svg" />
</p>

This is the repository for all of my dotfiles for Linux/Mac/Windows. It uses [GNU Stow](https://www.gnu.org/software/stow) to organize the configuration files, and follows the [XDG Base Directory specification](https://wiki.archlinux.org/index.php/XDG_Base_Directory) to keep my home directory (`~/`) as clean as possible.

> [!IMPORTANT]
> Do not start Nushell until the directories are symlinked. Nushell will not let you symlink its config directory if it's already running. Use the default shell (`bash`, `zsh`, etc.) for the first few steps.

### Installation

1. Install [Nushell](https://github.com/nushell/nushell), [GNU Stow](https://www.gnu.org/software/stow), and [Neovim](https://github.com/neovim/neovim)

1. Clone repository to `~/.config/dotfiles` and `cd` into it

   ```bash
   git clone --recurse-submodules --depth 1 https://github.com/zaknesler/dotfiles.git ~/.config/dotfiles
   cd ~/.config/dotfiles
   ```

1. Symlink directories using Stow

   ```bash
   ls -d */ | xargs stow -t $HOME
   ```

1. Install Homebrew (macOS only)

   ```bash
   # Install Xcode tools
   xcode-select --install

   # Install Homebrew
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

   # Install formulae from ./Brewfile
   brew bundle
   ```

1. Set your default shell to Nushell (Linux/macOS only)

   ```bash
   # Ensure Nushell exists as an option
   cat /etc/shells

   # Set user shell
   chsh -s $(which nu)
   ```

1. Re-login or run `nu` to use new configuration

1. Install Rust via [rustup](https://rustup.rs)

   ```nushell
   curl -L --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

1. Install [cargo-binstall](https://github.com/cargo-bins/cargo-binstall) (Linux only)

   ```nushell
   curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | sh
   ```

1. Install and activate `nu_plugin_gstat` (enables git repo data)

   ```nushell
   cargo binstall nu_plugin_gstat
   let gstat = (which nu_plugin_gstat | get path | first)
   nu -c $'plugin add '($gstat)'; version'
   ```

1. Install FNM (Linux/macOS)

   ```nushell
   curl -fsSL https://fnm.vercel.app/install | sh
   ```
