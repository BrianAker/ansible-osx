#!/bin/bash -e

/usr/libexec/PlistBuddy -c "Set LowPriorityBackgroundIO true" /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
/usr/libexec/PlistBuddy -c "Add Nice integer 20" /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
/usr/libexec/PlistBuddy -c "Add LowPriorityIO bool true" /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
plutil -p  /System/Library/LaunchDaemons/com.apple.metadata.mds.plist | grep LowPriorityBackgroundIO | grep -q 1
plutil -p  /System/Library/LaunchDaemons/com.apple.metadata.mds.plist | grep LowPriorityIO | grep -q 1
plutil -p  /System/Library/LaunchDaemons/com.apple.metadata.mds.plist | grep Nice | grep -q 20
