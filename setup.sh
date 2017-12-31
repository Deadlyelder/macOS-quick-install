#!/bin/sh

## Homebrew

if test ! $(which brew)
then
	echo 'Installing Homebrew'
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Verify that installed version is up-to-date
brew update

## Cask and MAS

echo 'Installing mas-cli'
brew install mas
echo "Enter your apple store email :"
read EMAIL
echo "Enter password for the $EMAIL : "
read -s PASSWORD
mas signin $EMAIL "$PASSWORD"

echo 'Installing Cask'
brew tap caskroom/cask

# Installing apps from mas
function install () {
	# Check if the App is already installed
	mas list | grep -i "$1" > /dev/null

	if [ "$?" == 0 ]; then
		echo "==> $1 Already installed"
	else
		echo "==> Installing $1..."
		mas search "$1" | { read app_ident app_name ; mas install $app_ident ; }
	fi
}

## Softwares
echo 'Installing the softwares'
brew install wget cmake coreutils psutils git node libssh

echo 'Installing utilities'
brew cask install alfred sizeup typinator istat-menus flux appcleaner hosts carbon-copy-cloner
install "FastScripts"
install "PopClip"
install "MacTracker"

echo 'Installing office applications'
install "iA Writer"
install "Ulysses"
install "Pages"
install "Keynote"
brew cask install evernote

echo 'Installing dev applications'
brew cask install iterm2 transmit
install "Xcode"
install "JSON Helper for AppleScript"
install "Twitter Scripter"

echo 'Installing communication applications'
install "Reeder"
install "Tweetbot"
install "Slack"
install "1Password"
brew cask install google-chrome firefox mattermost transmission

## System configurations

echo "Changing the default settings..."

## Finder

# Hidden files
chflags nohidden ~/Library

# Display the sidebar, setting default view to list view, show path, display extensions
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string “Nlsv”
defaults write com.apple.finder ShowPathbar -bool true
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Default to HOME folder
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Limiting the search to current folder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Enable quick look text selection
defaults write com.apple.finder QLEnableTextSelection -bool true

# Forbidn the creation of .DS_STORE file
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Dock settings
# Minimum text size 
defaults write com.apple.dock tilesize -int 15
# Activate magnification and set the size to max of the magnification
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -float 128

# Ask for passwrod immediately after screensaver starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Chime alert sound when volume is changed
sudo defaults write com.apple.systemsound com.apple.sound.beep.volume -float 1

# Trackpad: Touch to click
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

## Application setups

## Safari
# Set Safari’s home page to ‘about:blank’
defaults write com.apple.Safari HomePage -string "about:blank";ok

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false;ok

# Hitting the Backspace key to go to the previous page in history
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true;ok

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false;ok

# Hide annyoing Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool false;ok

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2;ok

# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true;ok

# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true;ok

# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true;ok

## Disable Photos app when iPhone is plugged
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

## Messages
# Disable automatic emoji substitution
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false;ok

# Disable smart quotes; annoying for dev
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false;ok

# Disable the auto dash
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false;ok

# Disable continuous spell check
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false;ok

## Apple App Store
#Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true;ok

# Enable Debug Menu in App store
defaults write com.apple.appstore ShowDebugMenu -bool true;ok

## Address Book, Dashboard, iCal, Texedit.
# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true;ok

# Dev mode in the dashboard
defaults write com.apple.dashboard devmode -bool true;ok

# Plain text mode for new TextEdit doc
defaults write com.apple.TextEdit RichText -int 0;ok
# Always open and save files as UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4;ok

## Activity Monitor
# Display the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true;ok

# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5;ok

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0;ok

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0;ok

## Mail App
# Disable send and reply animations in Mail.app
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true;ok

# Copy email addresses as 'alice@example.com' instead of 'Alice Bob <alice@example.com>' in Mail.app"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false;ok

# Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true;ok

# Disable automatic spell checking
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled";ok

