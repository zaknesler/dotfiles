#!/usr/bin/env bash

#  let plist = $"($env.HOME)/Library/LaunchAgents/com.theme-sync.plist"
#  let script = $"($env.HOME)/.config/dotfiles/.scripts/macos-theme-sync.sh"
#  let watch = $"($env.HOME)/Library/Preferences/.GlobalPreferences.plist"
#  ^plutil -create xml1 $plist
#  ^plutil -replace Label -string com.theme-sync $plist
#  ^plutil -replace ProgramArguments -json ([$script] | to json) $plist
#  ^plutil -replace WatchPaths -json ([$watch] | to json) $plist
#  ^plutil -replace RunAtLoad -bool true $plist
#  ^launchctl bootout $"gui/(id -u | str trim)/com.theme-sync" | ignore
#  ^launchctl bootstrap $"gui/(id -u | str trim)" $plist
#
# To reload after editing the plist:
#   ^launchctl bootout $"gui/(id -u | str trim)/com.theme-sync" | ignore
#   ^launchctl bootstrap $"gui/(id -u | str trim)" $plist
#
# To check status / debug a spawn failure:
#   ^launchctl print $"gui/(id -u | str trim)/com.theme-sync"

set -euo pipefail

MODE_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/nushell/.mode"

if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null || true)" = "Dark" ]; then
  echo -n "dark" > "$MODE_FILE"
else
  echo -n "light" > "$MODE_FILE"
fi
