# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

The most common issue is missing dependencies. Check that all the prerequisite dependencies are installed and configured correctly.

If the Azure CLI commands are failing due to checking for the latest version of Azure Bicep, you can disable this check globally.

```shell
az config set bicep.version_check=False
```