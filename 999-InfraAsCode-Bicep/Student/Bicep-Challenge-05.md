# Challenge 4 - Deploy a Virtual Machine Scale Set

[< Previous Challenge](./Bicep-Challenge-04.md) - [Home](../readme.md) - [Next Challenge>](./Bicep-Challenge-06.md)

## Introduction

The goal for this challenge includes understanding:
- Create a more complex deployment using Bicep modules

Use your learning from the previous challenges you will use Bicep modules to deploy Linux Virtual Machine Scale Sets (VMSS).

## Description

In this challenge you will write Bicep files that make use of modules to achieve the following:

- Separate networking resources (Virtual Network & Network Security Groups) into their own Bicep file.
- Separate the load balancer, VMSS, and its dependencies into their own Bicep files.
- Create a new Bicep template that deploys each of the modules you created.

## Success Criteria

1. Verify that the Bicep CLI does not show any errors and correctly emits an ARM template.
1. Verify in the Azure portal that all resources has been deployed.

## Learning Resources

- [Creating and consuming modules](https://github.com/Azure/bicep/blob/main/docs/tutorial/06-creating-modules.md)
- [Example Bicep templates covering many different scenarios and resources](https://github.com/Azure/bicep/tree/main/docs/examples)
- [VMSS - Azure Resource Manager reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/virtualmachinescalesets?tabs=json)

## Tips

- Install the Bicep tooling - [follow these instructions to install the Bicep CLI and VS Code extension](https://github.com/Azure/bicep/blob/main/docs/installing.md#bicep-vs-code-extension).
- Validate your Bicep files regularly by executing `bicep build mybicepfile.bicep`.
- Remember Bicep is still in preview so there may be bugs or missing features.
