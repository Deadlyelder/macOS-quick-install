#!/bin/sh

## This script is an update to the scripts by Deadlyelder here:
## https://github.com/Deadlyelder/macOS-quick-install

# Homebrew install/update

if test ! $(which brew)
then
	echo '> Installing Homebrew'
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo '> Updating Homebrew'

# TODO: Redirect to null
brew update > /dev/null 2>&1

brew doctor

## Cask and MAS

echo '> Installing mas-cli'
brew install mas
echo "\t< Enter your apple store email :"
read EMAIL
echo "\t< Enter password for the $EMAIL : "
read -s PASSWORD
mas signin $EMAIL "$PASSWORD"

echo '> Installing Cask'
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
echo '> Installing the softwares'

echo '>> Installing dev related stuff'
brew install git

echo '>> Installing utilities'
brew cask install bartender calibre istat-menus flux radio-silence
install "Pocket"
install "Coffitivity"
install "Amphetamine"
install "Magnet"
install "Silenz"

echo '>> Installing office applications'
install "Pages"
install "Keynote"

echo '>> Installing music/video apps'
brew cask install vlc spotify

echo '>> Installing dev applications'
brew cask install iterm2 transmit visual-studio-code python
install "Xcode"

echo '>> Installing communication applications'
install "Slack"
brew cask install discord firefox transmission tunnelblick

echo '>> Installing managers'
install "1Password"
install "Dashlane"

echo '>> Installing Docker'
brew install docker

echo '>> Installing GNUPG'
brew install gnupg

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

echo 'This script misses:'
echo '\t * cozy-cloud'
echo '\t * parcel'
