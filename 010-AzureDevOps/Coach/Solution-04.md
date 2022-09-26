# Challenge 04 - Azure Pipelines: Infrastructure as Code - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

- Use classic version in the ARM deployment
- Override template parameters, student should have this solution:
  - Students can archive this item clicking in the 3 dots, open a new window with the name/value table.
  - Solution tested: -webAppName "updevdevops-dev" -hostingPlanName "updevdevops-asp" -appInsightsLocation "Central US" -appInsightsName "updevdevops-ai" -sku "S1" -registryName "updevdevopsreg" -imageName "updevdevopsimage" -registryLocation "Central US" -registrySku "Standard" -startupCommand ""
  - check the YAML in the solutions **[S04ARMtemplatedeployment.yaml](./Solutions/S04ARMtemplatedeployment.yaml)** for the prefix part
- Check the **[Solution-04](./Solutions/Solution-04.json)** for entire possible solution for this challenge. 


