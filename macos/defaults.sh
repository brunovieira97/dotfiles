#!/bin/bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

# General UI/UX

# Disable pop-up for using connected drives with TimeMachine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Create new tabs manually (prevents Cmd+N from opening a new tab while in fullscreen)
defaults write NSGlobalDomain AppleWindowTabbingMode -string "manual"


# Window Manager

# Disable click to show desktop
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Enable margins around tiled windows
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool true


# Input

# Repeat instead of showing special characters when holding a key
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Sets delay before starting repeating keys
defaults write NSGlobalDomain InitialKeyRepeat -int 30

# Maximum speed for repeating keys
defaults write NSGlobalDomain KeyRepeat -int 5

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable automatic period on double-space
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false


# Dock

# Disable magnification effect
defaults write com.apple.dock magnification -bool false

# Use "Genie" effect for minimizing windows
defaults write com.apple.dock mineffect -string "genie"

# Don't minimize windows to app icon
defaults write com.apple.dock minimize-to-application -bool false

# Keep dock at bottom of screen
defaults write com.apple.dock orientation -string "bottom"

# Don't show recent apps in Dock
defaults write com.apple.dock show-recents -bool false

# Disable App Exposé gesture
defaults write com.apple.dock showAppExposeGestureEnabled -bool false

# Enable Mission Control gesture
defaults write com.apple.dock showMissionControlGestureEnabled -bool true

# Disable Dock resizing
defaults write com.apple.dock size-immutable -bool true

# Icon size = 48
defaults write com.apple.dock tilesize -int 48


# Energy saving

# Sleep display after 5 min (battery)
pmset -b displaysleep 5

# Sleep display after 10 min (charging)
pmset -c displaysleep 10

# Set machine sleep to 5 minutes on battery
pmset -b sleep 5


# Finder

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder _FXSortFoldersFirstOnDesktop -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Adjust column widths based on filenames
defaults write com.apple.finder "_FXEnableColumnAutoSizing" -bool true

# Don't create .DS_Store for USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Don't create .DS_Store for network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true


# Security and Privacy

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0


# TextEdit

# Set default format to plain text instead of RTF
defaults write com.apple.TextEdit RichText -bool false

# Start with an untitled file instead of file picker window
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

# Use UTF-8 for opening files
defaults write com.apple.TextEdit PlainTextEncoding -int 4

# Use UTF-8 for saving files
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4


# Screen Capture

# Set screenshot format to PNG
defaults write com.apple.screencapture type -string "png"

# Take screenshots with SDR
defaults write com.apple.screencapture captureHDR -bool false

# Don't show thumbnail after capture
defaults write com.apple.screencapture show-thumbnail -bool false

# Copy screenshots to clipboard
defaults write com.apple.screencapture target -string "clipboard"


# Activity Monitor

# Display processes from all users
defaults write com.apple.ActivityMonitor ShowCategory -int 100

# Display Disk Usage by bytes written
defaults write com.apple.ActivityMonitor DiskGraphType -int 0


# Safari

# Don't open safe downloads automatically
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Show status bar on hover for links
defaults write com.apple.Safari ShowOverlayStatusBar -bool true

# Enable Dev Tools
defaults write com.apple.Safari IncludeDevelopMenu -bool true


# Close any affected apps
for app in "cfprefsd" \
	"Dock" \
	"Finder" \
	"TextEdit" \
	"ActivityMonitor" \
	"Safari" \
	"SystemUIServer"; do
	killall "${app}" &> /dev/null
done
