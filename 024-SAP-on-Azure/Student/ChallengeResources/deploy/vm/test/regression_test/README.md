Regression test
-------------------

This directory contains the resources to do regression testing. The current regression test does the following:

1. Creates VM
2. Installs the required packages and tools for the deployment to work

How to run:
-----------

ansible-playbook create_ubuntu_vm.yml --extra-vars="{resource_group: "< resource group> ", ssh_private_key_file: "<path to private key file>", ssh_public_key_file: "<path to public key file>", vm_user: "< user name >", allowed_source_ip_prefix: "<range of ip address allowed to ssh to this tester vm. e.g. "X.X.X.X/16">"}"
