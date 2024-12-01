#!/bin/bash

# Do not open Apple Music when media keys, headphones' or AirPods' buttons are pressed
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist
