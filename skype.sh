#!/bin/bash

defaults write com.skype.skype AutoCollapseChatView -bool true
defaults write com.skype.skype AutoCollapseSidebar -bool false
defaults write com.skype.skype DialpadOpen -bool false
defaults write com.skype.skype DisableWebKitDeveloperExtras -bool true
defaults write com.skype.skype HockeySDKAutomaticallySendCrashReports -bool true
defaults write com.skype.skype HockeySDKCrashReportActivated -bool false
defaults write com.skype.skype IncludeDebugMenu -bool true
defaults write com.skype.skype SKDisableWelcomeTour -bool true
defaults write com.skype.skype SKFileTransferShowImagesInline -bool false
defaults write com.skype.skype SKMyselfCorner 3
defaults write com.skype.skype SKMyselfMinimized -bool false
 
# Remember password
defaults write com.skype.skype SKRememberPassword -bool true

defaults write com.skype.skype SKShowWelcomeTour -bool false
defaults write com.skype.skype SearchSelectedTab -bool true
defaults write com.skype.skype ShowDialpadOnLogin -bool false
defaults write com.skype.skype SidebarIsCollapsed -bool false
defaults write com.skype.skype WebKitDeveloperExtras -bool true

# Hide menu icon
defaults write com.skype.skype SKShowSystemStatusBarItem -bool false

# Hide watermark
defaults write com.skype.skype SKShowWatermark -bool false

# Notifications
defaults write com.skype.skype UserDefinedEvents -dict-add "Busy" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "CallConnecting" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "ContactBecomesAvailable" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "ContactRequestReceived" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "ContactsReceived" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "DesktopAPIClientConnected" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "FileTransferCompleted" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "FileTransferFailed" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "FirstMessageReceived" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "HangUp" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "HoldCall" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "IncomingCall" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "IncomingCallWaiting" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "IncomingFileTransfer" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "MessageReceived" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "MessageSent" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "OutgoingCall" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "RemotePartyHungUp" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "ResumeCall" '{PlaySound = 0; Bounce = 0;}'
defaults write com.skype.skype UserDefinedEvents -dict-add "SignIn" '{PlaySound = 0; Bounce = 0;}'
