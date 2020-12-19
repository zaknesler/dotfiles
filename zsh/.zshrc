####################
#   ZSH Settings   #
####################

# Path to oh-my-zsh installation
export ZSH="/home/zak/.oh-my-zsh"

# ZSH theme to use
ZSH_THEME="robbyrussell"

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
source ~/.exports
source ~/.aliases
source ~/.functions

# Ruby Env
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
