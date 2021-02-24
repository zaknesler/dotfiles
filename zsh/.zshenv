if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export SHELL="/usr/bin/zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export SHELL="/usr/local/bin/zsh"
fi

export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
