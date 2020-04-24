# Prerequisites for Ansible challenges

## Install and Configure Ansible

You have several options to install Ansible. You can choose from the following options:
1) Install Ansible on a Linux VM in Azure
2) Install Ansible on Windows Services for Linux 
3) Use Azure Cloud Shell which already has Ansible installed

Using Azure Cloud Shell is the quickest method but you may wish to have more control of your editor and so one of the other options may be more desirable for you.

You will need to create Azure credentials using your Azure subscription ID and service principal values. Once you have done that you will create an Ansible credentials file with your subscription Id, tenant Id, secret and client Id. 

Reference: 
https://docs.microsoft.com/en-us/azure/virtual-machines/linux/ansible-install-configure#install-ansible-on-an-azure-linux-virtual-machine
https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html#providing-credentials-to-azure-modules
https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal

