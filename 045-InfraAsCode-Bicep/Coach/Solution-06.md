# Challenge 06 - Bicep Modules - Coach's Guide

[< Previous Challenge](./Solution-05.md) - **[Home](./README.md)** - [Next Challenge >](./Solution-07.md)

## Notes & Guidance

In this challenge, the student is learning about modules.  A VM and VNET are separated into modules to show how to break up monoliths and promote reuse.

- A dependent module should not assume anything about how a prior module operated. 
- It's not a good practice to pass in the name of a resource-to-be-created to a module and then recreate a resource ID in the next module using that same name. 
- Instead, the module that created the resource should output its resource ID, name, and other properties that might be required. 
- The dependent module should use those output values as input parameters. 
- This has the added benefit of creating an automatic dependency between the modules when the Bicep is transpiled to ARM JSON.

## Tips

- [Bicep Modules](https://learn.microsoft.com/azure/azure-resource-manager/bicep/modules)
- Validate your Bicep files regularly by executing `bicep build mybicepfile.bicep`.
