#!/bin/bash

{
	# Close any open System Preferences panes
	osascript -e 'tell application "System Preferences" to quit'

	# General UI/UX
	defaults delete com.apple.TimeMachine DoNotOfferNewDisksForBackup
	defaults delete com.apple.print.PrintingPrefs "Quit When Finished"
	defaults delete NSGlobalDomain AppleWindowTabbingMode

	# Window Manager
	defaults delete com.apple.WindowManager EnableStandardClickToShowDesktop
	defaults delete com.apple.WindowManager EnableTiledWindowMargins

	# Input
	defaults delete NSGlobalDomain ApplePressAndHoldEnabled
	defaults delete NSGlobalDomain InitialKeyRepeat
	defaults delete NSGlobalDomain KeyRepeat
	defaults delete NSGlobalDomain NSAutomaticSpellingCorrectionEnabled
	defaults delete NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled

	# Dock
	defaults delete com.apple.dock magnification
	defaults delete com.apple.dock mineffect
	defaults delete com.apple.dock minimize-to-application
	defaults delete com.apple.dock orientation
	defaults delete com.apple.dock show-recents
	defaults delete com.apple.dock showAppExposeGestureEnabled
	defaults delete com.apple.dock showMissionControlGestureEnabled
	defaults delete com.apple.dock size-immutable
	defaults delete com.apple.dock tilesize

	# Finder
	defaults delete com.apple.finder NewWindowTarget
	defaults delete com.apple.finder NewWindowTargetPath
	defaults delete NSGlobalDomain AppleShowAllExtensions
	defaults delete com.apple.finder ShowStatusBar
	defaults delete com.apple.finder ShowPathbar
	defaults delete com.apple.finder _FXSortFoldersFirst
	defaults delete com.apple.finder _FXSortFoldersFirstOnDesktop
	defaults delete com.apple.finder FXDefaultSearchScope
	defaults delete com.apple.finder "_FXEnableColumnAutoSizing"
	defaults delete com.apple.desktopservices DSDontWriteUSBStores
	defaults delete com.apple.desktopservices DSDontWriteNetworkStores
	defaults delete com.apple.finder QLInlinePreviewMinimumSupportedSize

	# Security and Privacy
	defaults delete com.apple.screensaver askForPassword
	defaults delete com.apple.screensaver askForPasswordDelay

	# TextEdit
	defaults delete com.apple.TextEdit RichText
	defaults delete com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile
	defaults delete com.apple.TextEdit PlainTextEncoding
	defaults delete com.apple.TextEdit PlainTextEncodingForWrite

	# Screen Capture
	defaults delete com.apple.screencapture type
	defaults delete com.apple.screencapture captureHDR
	defaults delete com.apple.screencapture show-thumbnail
	defaults delete com.apple.screencapture target

	# Activity Monitor
	defaults delete com.apple.ActivityMonitor ShowCategory
	defaults delete com.apple.ActivityMonitor DiskGraphType

	# Safari
	defaults delete com.apple.Safari AutoOpenSafeDownloads
	defaults delete com.apple.Safari ShowOverlayStatusBar
	defaults delete com.apple.Safari IncludeDevelopMenu

	# Close any affected apps
	kill_apps() {
        local apps=(
            "cfprefsd"
            "Dock"
            "Finder"
            "TextEdit"
            "ActivityMonitor"
            "Safari"
            "SystemUIServer"
        )

        local app
        for app in "${apps[@]}"; do
            killall "${app}"
        done
    }

    kill_apps
} &> /dev/null
