# Enable P10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

####################
#   ZSH Settings   #
####################

# Path to oh-my-zsh installation
export ZSH="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-zsh"

# ZSH theme to use
ZSH_THEME="powerlevel10k/powerlevel10k"

source $ZDOTDIR/.exports

# List of plugins to load
plugins=(
  zsh-autosuggestions
  zsh-nvm
)

# Configure ZSH Autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#959992"

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

#######################
#   Custom Settings   #
#######################

# SSH key
export SSH_KEY_PATH="~/.ssh/rsa_id"

# Include bash exports, aliases, and functions
source $ZDOTDIR/.aliases
source $ZDOTDIR/.functions

# P10k Configuration
source $ZDOTDIR/.p10k.zsh
