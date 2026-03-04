#!/bin/bash


echo "Cleaning up Terraform resources..."

# Remove Terraform state files and directories 
rm -vrf .terraform*
rm -vrf .terraform.lock.hcl
rm -vrf terraform.tfstate
rm -vrf terraform.tfstate.backup
rm -vrf *.tfplan

echo "Terraform resources cleaned up successfully."
