# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
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

# List of plugins to load
plugins=(
  git
  zsh-autosuggestions
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
source $ZDOTDIR/.exports
source $ZDOTDIR/.aliases
source $ZDOTDIR/.functions

# P10k Configuration
source $ZDOTDIR/.p10k.zsh

# Ruby Env
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
