# macOS-quick-install
Repo that contains script to automate setting up my macOS machine.

## Current status and version
Work in progress.
Version: 0.4

## Installation

These scripts allow me to install the softwares I use and configure some settings automatically after a fresh install of
macOS.

*Warning*: This script is based on my requirements. Before using it, dont forget to modify it based on your
requirements.

## Useage

Here's how to use both scripts:

* Clone or download the repo.
* Open the `setup.sh` file and modify what you want installed by default:
> * Each line that starts withe `install` will begin the installation of the app from Apple store that must have been purchased in your account beforehand;
> * Every line that starts with `brew` installs using the homebrew package;
> * Rvery line that starts with `brew` cask installs applications that are not from the Apple Store;
* Now open the `Terminal` on macOS and execute the `setup.sh`.
* The script will mostly work without the need for any intervention, except in the following steps:
> * Validate the installation of homebrew
> * Enter the root/admin password for homebrew
> * Enter the Apple account ID and password for Apple store;
> * Admin password for Cask.
* If everything is done correctly, then it will finish without throwing any error but incase of error, just restart the script.

* Once the first script has completed, you can execute the `security.sh` which is mostly to configure the security and privacy settings of the macOS.

## Addtional resources

To create these scripts I have used part of some other scripts that are mentioned below. It may be worth checking them for adapting the script for specific requirments of a user.

https://github.com/drduh/macOS-Security-and-Privacy-Guide

https://github.com/joeyhoer/starter
