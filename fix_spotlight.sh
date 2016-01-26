#!/bin/bash -e

SPOTLIGHT_LOCATION=/System/Library/LaunchDaemons/com.apple.metadata.mds.plist
ROOT_SPOTLIGHT_LOCATION=/.Spotlight-V100/VolumeConfiguration.plist

PLISTBUDDY='/usr/libexec/PlistBuddy -c'

EXCLUSIONS=(
"/Users/brian/Library/Application Support/Console"
"/Users/brian/Library/Application Support/CrashReporter"
"/Users/brian/Library/Application Support/Google"
"/Users/brian/Library/Application Support/MobileSync"
"/Users/brian/Library/Application Support/Mozilla"
"/Users/brian/Library/Application Support/Skype"
"/Users/brian/Library/Application Support/Syncthing"
"/Users/brian/Library/Application Support/VMware Fusion"
"/Users/brian/Library/Application Support/iLifeAssetManagement"
"/Users/brian/Library/Application Support/net.limechat.LimeChat-AppStore"
"/Users/brian/Library/Caches"
"/Users/brian/Library/Saved Application State"
"/Users/brian/Library/Saved Searches")

$PLISTBUDDY "Set :LowPriorityBackgroundIO true" $SPOTLIGHT_LOCATION
$PLISTBUDDY "Add :Nice integer 20" $SPOTLIGHT_LOCATION
$PLISTBUDDY "Add :LowPriorityIO bool true" $SPOTLIGHT_LOCATION
plutil -p  $SPOTLIGHT_LOCATION | grep LowPriorityBackgroundIO | grep -q 1
plutil -p  $SPOTLIGHT_LOCATION | grep LowPriorityIO | grep -q 1
plutil -p  $SPOTLIGHT_LOCATION | grep Nice | grep -q 20

$PLISTBUDDY "Delete :Exclusions" $ROOT_SPOTLIGHT_LOCATION
$PLISTBUDDY "Add :Exclusions array" $ROOT_SPOTLIGHT_LOCATION

x=0
for exclusion_item in "${EXCLUSIONS[@]}"
do
  $PLISTBUDDY "Add :Exclusions:$((x++)) string $exclusion_item" $ROOT_SPOTLIGHT_LOCATION
done

