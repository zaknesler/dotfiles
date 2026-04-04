#!/usr/bin/env bash

# Usage: bash macos.sh

set -euo pipefail

# Disable all text auto-corrections and substitutions
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool 0
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool 0
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool 0
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool 0
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool 1

# Mouse, trackpad, and scroll
defaults write NSGlobalDomain com.apple.mouse.scaling -float 0.5
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.6875
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool 1
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool 1
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.215

# Appearance: auto dark/light, orange accent, show all file extensions
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool 1
defaults write NSGlobalDomain AppleAccentColor -int 1
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.874510 0.701961 Orange"
defaults write NSGlobalDomain AppleShowAllExtensions -bool 1
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Alert sound: low volume, no screen flash
defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0.4345982
defaults write NSGlobalDomain com.apple.sound.beep.sound -string "/System/Library/Sounds/Tink.aiff"
defaults write NSGlobalDomain com.apple.sound.beep.flash -int 0

# Always confirm close with unsaved changes
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool 1

# Dock: small icons, scale effect, no recent apps
defaults write com.apple.dock tilesize -float 36
defaults write com.apple.dock autohide -bool 0
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-process-indicators -bool 1
defaults write com.apple.dock show-recents -bool 0
defaults write com.apple.dock showAppExposeGestureEnabled -bool 1
defaults write com.apple.dock showMissionControlGestureEnabled -bool 1

# Finder: path bar, folders first, no extension warnings, icon view, open to home
defaults write com.apple.finder ShowPathbar -bool 1
defaults write com.apple.finder ShowSidebar -bool 1
defaults write com.apple.finder _FXSortFoldersFirst -bool 1
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool 1
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool 0
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"
defaults write com.apple.finder FXPreferredSearchViewStyle -string "clmv"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder ShowRecentTags -bool 0
defaults write com.apple.finder ShowPreviewPane -bool 0

# iCloud drive on, but desktop/documents sync off
defaults write com.apple.finder FXICloudDriveEnabled -bool 1
defaults write com.apple.finder FXICloudDriveDesktop -bool 0
defaults write com.apple.finder FXICloudDriveDocuments -bool 0

# Desktop: show external and removable drives, hide internal and servers
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool 1
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool 0
defaults write com.apple.finder ShowMountedServersOnDesktop -bool 0
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool 1

# Screenshots go to clipboard, default to selection mode
defaults write com.apple.screencapture target -string "clipboard"
defaults write com.apple.screencapture style -string "selection"

# Menu bar: show battery, clock, sound, wifi, now playing; hide the rest
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Battery" -bool 1
defaults write com.apple.controlcenter "NSStatusItem VisibleCC BentoBox-0" -bool 1
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Clock" -bool 1
defaults write com.apple.controlcenter "NSStatusItem VisibleCC NowPlaying" -bool 1
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Sound" -bool 1
defaults write com.apple.controlcenter "NSStatusItem VisibleCC WiFi" -bool 1
defaults write com.apple.controlcenter "NSStatusItem Visible FaceTime" -bool 0
defaults write com.apple.controlcenter "NSStatusItem Visible KeyboardBrightness" -bool 0
defaults write com.apple.controlcenter "NSStatusItem Visible UserSwitcher" -bool 0
defaults write com.apple.controlcenter RemoteLiveActivitiesEnabled -bool 1

# Brave: disable swipe navigation
defaults write com.brave.Browser AppleEnableSwipeNavigateWithScrolls -bool FALSE

echo "Restarting Dock, Finder, SystemUIServer..."
killall Dock Finder SystemUIServer cfprefsd 2>/dev/null || true
echo "Done."
