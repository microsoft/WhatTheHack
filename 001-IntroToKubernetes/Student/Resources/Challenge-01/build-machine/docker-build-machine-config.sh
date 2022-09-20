#!/bin/bash

#Set up Linux Build Agent VM to install Docker & Node.js

# The first parameter passed in is the user we're going to add
# to the docker group, if one isn't passed in, use the current user
REPOURL="https://github.com/Microsoft/WhatTheHack"
CURUSER=${1:-$USER}
CURUSERHOME=$(eval echo ~$(echo $CURUSER))
ADMINUSER=wthadmin
ADMINUSERHOME=$(eval echo ~$(echo $ADMINUSER))

#1. Update the Ubuntu packages and install curl and support for repositories over HTTPS
#in a single step by typing the following in a single line command.
#When asked if you would like to proceed, respond by typing “y” and pressing enter.
sudo apt-get -qy update && sudo apt -qy install apt-transport-https ca-certificates curl software-properties-common

#2. Add Docker's official GPG key by typing the following in a single line command
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#2.5. Add Azure's official GPG key by typing the following in a single line command
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

#3. Add Docker's stable repository to Ubuntu packages list by typing the following in a single line command
sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
#3.5. Add Azure's CLI repository to Ubuntu
sudo add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli $(lsb_release -cs) main"

#4. Update the Ubuntu packages and install Docker engine, node.js and the node package manager
#in a single step by typing the following in a single line command.
#When asked if you would like to proceed, respond by typing “y” and pressing enter.
sudo apt-get -qy update && sudo apt -qy install docker-ce nodejs npm git
#4.5. Install the Azure CLI packages
sudo apt -qy install azure-cli

#5. Now, upgrade the Ubuntu packages to the latest version by typing the following in a single line command.
#When asked if you would like to proceed, respond by typing “y” and pressing enter.
sudo apt-get -qy upgrade

#6. Add your user to the Docker group so that you do not have to elevate privileges with sudo for every command.
sudo usermod -aG docker $CURUSER

#7. Clone the WTH repo so we can get our source code
git clone $REPOURL $CURUSERHOME/wth

#8. Move the needed source we'll use in our docker container images to the home dir
mv -v $CURUSERHOME/wth/001-IntroToKubernetes/Student/Resources/Challenge-01/content* $CURUSERHOME

#9. Delete the git repo now, we don't want to leave it behind
rm -rfv $CURUSERHOME/wth

#10. Give yourself full ownership of your home directory
sudo chown -R $ADMINUSER.$ADMINUSER $ADMINUSERHOME

#11. Change sshd port to 2266 and restart it
sudo systemctl stop sshd.service
sudo chown $ADMINUSER.$ADMINUSER /etc/ssh/sshd_config 
sudo cat <<EOF >> /etc/ssh/sshd_config 

# WTH: Change to run on a custom port for security reasons
Port 2266
EOF
sudo chown root.root /etc/ssh/sshd_config 
sudo systemctl start sshd.service
