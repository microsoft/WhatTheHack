# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance


Days before the hack you will need to:
- Make sure the students increase the VM quotas to use a minimum of 40 cores. Docs on how to do that can be found here: [Increase VM-family vCPU quotas](https://docs.microsoft.com/en-us/azure/azure-portal/supportability/per-vm-quota-requests) 
  - To check your current subscription quota of the smallest supported virtual machine family SKU "Standard DSv3", run this command: `az vm list-usage -l $LOCATION --query "[?contains(name.value, 'standardDSv3Family')]" -o table`
- Make sure that all students are able to download a [Red Hat Pull Secret](https://cloud.redhat.com/openshift/install/azure/aro-provisioned) at least 2 business days **BEFORE** the hack.
  - **NOTE:** Quotas are set per region.  If you increase the quota in a single region, you need to ensure that all students deploy to the same region.  Or else, they will bump up against the quota limits in the region they deploy to.
