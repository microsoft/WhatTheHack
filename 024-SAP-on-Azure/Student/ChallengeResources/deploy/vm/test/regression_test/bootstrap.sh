#!/bin/sh

#get the terraform package
wget "https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip"

#install unzip to unzip terraform
apt-get -y install unzip

#unzip terraform
unzip terraform_0.11.10_linux_amd64.zip

#add terraform to the PATH
cp terraform /usr/local/bin/

#install Ansible:
apt-get -y update
apt-get -y install python-pip
apt-get -y install ansible
apt-get -y install gcc python python-dev musl-dev libffi-dev
apt-get -y install libssl-dev
sudo -H pip install  cffi>=1.4.1
pip install packaging
pip install --ignore-installed pyyaml ansible[azure]
sudo -H pip install msrest==0.6.0
