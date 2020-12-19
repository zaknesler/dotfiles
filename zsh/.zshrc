####################
#   ZSH Settings   #
####################

# Path to oh-my-zsh installation
export ZSH="~/.oh-my-zsh"

# ZSH theme to use
ZSH_THEME="robbyrussell"

# List of plugins to load
plugins=(
  git
)

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

# Fix percent sign showing up on startup
# https://superuser.com/a/645612
unsetopt PROMPT_SP
