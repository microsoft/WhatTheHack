# Challenge 00 - Setup Azure & Tools - Coach's Guide

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Coming Soon:

- Guidance on Coach pre-reqs:
   - Coach packages & provides `Resources.zip` file from contents of `/Student/Resources`
    
    OR
   
   - Coach uses scripts in `/Coach/Setup` folder to generate GitHub repos for each student with the sample application already committed to it.
    
- Instructions on how to use the scripts in the `/Coach/Setup` folder to generate Azure service principals for a shared student environment and GitHub repos for each student. 

Regardless of the option you choose, you'll have to consider:
- [Azure default quotas and resource limits](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits) (for example, # of VMs allowed per region or subscription)
- Unique naming of resources - many services may require a globally unique name, for example, App service, container registry.

