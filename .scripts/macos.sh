#!/usr/bin/env bash

# Usage: bash macos.sh

set -euo pipefail

# Disable all text auto-corrections and substitutions
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true

# Key repeat, etc.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Mouse/trackpad/scroll
defaults write NSGlobalDomain com.apple.mouse.scaling -float 0.5
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.6875
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.215

# Trackpad: three-finger drag, secondary click
defaults write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true
defaults write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Appearance: auto dark/light, orange accent, show all file extensions
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true
defaults write NSGlobalDomain AppleAccentColor -int 1
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.874510 0.701961 Orange"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Alert sound: low volume, no screen flash
defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0.4345982
defaults write NSGlobalDomain com.apple.sound.beep.sound -string "/System/Library/Sounds/Tink.aiff"
defaults write NSGlobalDomain com.apple.sound.beep.flash -int 0

# Always confirm close with unsaved changes
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true

# Dock: small icons, scale effect, no recent apps
defaults write com.apple.dock tilesize -float 36
defaults write com.apple.dock autohide -bool false
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
defaults write com.apple.dock showMissionControlGestureEnabled -bool true
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock largesize -float 64
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock launchanim -bool false
defaults write com.apple.dock expose-group-apps -bool true
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock size-immutable -bool true

# Finder: no path bar, folders first, no extension warnings, list view, open to home
defaults write com.apple.finder ShowPathbar -bool false
defaults write com.apple.finder ShowSidebar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder FXPreferredSearchViewStyle -string "clmv"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder ShowRecentTags -bool false
defaults write com.apple.finder ShowPreviewPane -bool false
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Finder: quit menu item, empty trash warning
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder WarnOnEmptyTrash -bool true

# iCloud drive on, but desktop/documents sync off
defaults write com.apple.finder FXICloudDriveEnabled -bool true
defaults write com.apple.finder FXICloudDriveDesktop -bool false
defaults write com.apple.finder FXICloudDriveDocuments -bool false

# Desktop: show external and removable drives, hide internal and servers
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Screenshots go to clipboard, default to selection mode
defaults write com.apple.screencapture target -string "clipboard"
defaults write com.apple.screencapture style -string "selection"

# Menu bar: show battery, clock, sound, wifi; hide the rest
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Battery" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC BentoBox-0" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Clock" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC Sound" -bool true
defaults write com.apple.controlcenter "NSStatusItem VisibleCC WiFi" -bool true
defaults write com.apple.controlcenter "NSStatusItem Visible FaceTime" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible KeyboardBrightness" -bool false
defaults write com.apple.controlcenter "NSStatusItem Visible UserSwitcher" -bool false
defaults write com.apple.controlcenter RemoteLiveActivitiesEnabled -bool true

# Disable swipe navigation in browsers
defaults write com.brave.Browser AppleEnableSwipeNavigateWithScrolls -bool false
defaults write net.imput.helium AppleEnableSwipeNavigateWithScrolls -bool false

echo "Restarting Dock, Finder, SystemUIServer..."
killall Dock Finder SystemUIServer cfprefsd 2>/dev/null || true
echo "Done."
