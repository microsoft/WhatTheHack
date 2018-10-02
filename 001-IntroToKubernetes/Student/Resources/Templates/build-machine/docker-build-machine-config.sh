#!/bin/bash

#Set up Linux Build Agent VM to install Docker & Node.js

# The first parameter passed in is the user we're going to add
# to the docker group, if one isn't passed in, use the current user
CURUSER=${1:-$USER}
CURUSERHOME=$(eval echo ~$(echo $CURUSER))

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
sudo apt-get -qy update && sudo apt -qy install docker-ce nodejs npm wget
#4.5. Install the Azure CLI packages
sudo apt -qy install azure-cli

#5.     Now, upgrade the Ubuntu packages to the latest version by typing the following in a single line command.
#When asked if you would like to proceed, respond by typing “y” and pressing enter.
sudo apt-get -qy upgrade

#6.     Add your user to the Docker group so that you do not have to elevate privileges with sudo for every command.
sudo usermod -aG docker $CURUSER

#Download and stage source code for the V1 & V2 of the FabMedical application.

#Download FabMedical V1 source code:
curl -sL -o FabMedical.v1.tgz http://aka.ms/FabMedical.v1

#Create new V1 directory
mkdir $CURUSERHOME/FabMedical.v1

#Unpack the archive into the new folder
tar -C $CURUSERHOME/FabMedical.v1 -xzf FabMedical.v1.tgz --no-same-owner

#Change owner and group to match the user and its primary group
chown -R $CURUSER $CURUSERHOME/FabMedical.v1
chgrp -R $(id -gn $CURUSER) $CURUSERHOME/FabMedical.v1

#Download FabMedical V1 source code:
curl -sL -o FabMedical.v2.tgz http://aka.ms/FabMedical.v2

#Create new V1 directory
mkdir $CURUSERHOME/FabMedical.v2

#Unpack the archive into the new folder
tar -C $CURUSERHOME/FabMedical.v2 -xzf FabMedical.v2.tgz --no-same-owner

#Change owner and group to match the user and its primary group
chown -R $CURUSER $CURUSERHOME/FabMedical.v2
chgrp -R $(id -gn $CURUSER) $CURUSERHOME/FabMedical.v2
