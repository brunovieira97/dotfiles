#!/bin/bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
osascript -e 'tell application "System Preferences" to quit'

# General UI/UX

# Disable the "Are you sure you want to open this application?" dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable pop-up for using connected drives with TimeMachine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true


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
sudo pmset -b displaysleep 5

# Sleep display after 10 min (charging)
sudo pmset -c displaysleep 10

# Set machine sleep to 5 minutes on battery
sudo pmset -b sleep 5


# Finder

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"


# Safari & WebKit

# Don't open 'safe' files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Enable the Develop menu and Web Inspector
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# Disable Autofill of passwords
defaults write com.apple.Safari AutoFillPasswords -bool false

# Enable "Do Not Track"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true


# Security and Privacy

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0


# Close any affected apps
for app in "cfprefsd" \
	"Dock" \
	"Finder" \
	"Safari" \
	"SystemUIServer"; do
	killall "${app}" &> /dev/null
done
