# Challenge 03 - Azure Pipelines: Infrastructure as Code - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

- Use classic version in the ARM deployment
- Override template parameters, student should have this solution:
  - Students can archive this item by clicking on the 3 dots and opening a new window with the name/value table.
  - Solution tested: `-webAppName "updevdevops-dev" -hostingPlanName "updevdevops-asp" -appInsightsLocation "Central US" -appInsightsName "updevdevops-ai" -sku "S1" -registryName "updevdevopsreg" -imageName "updevdevopsimage" -registryLocation "Central US" -registrySku "Standard" -startupCommand`


- We should be focused on the YAML approach to creating pipelines.  This is due to it being a best practice for scalability and being able to leverage the benefits of source control.  While we can have students utilize the UI to poke around, they should stick with YAML based pipelines.

- Step by step guide
  - Under Pipelines select "Create Pipeline"
  - Select "Azure Repos Git" as we are focused on YAML
  - Select your repo where the code is located
  - Select "Starter pipeline"
  - Leverage the assistant to link your pipeline
    - Select "Show Assistant" on the right hand side while editing your YAML pipeline
    - Search for "ARM template deployment" and select the task.
    - Under "Azure Resource Manager Connection", select your subscription.  If this is your first time, you may need to authorize the connection by selecting "Authorize" below the field.
    - Select your subscription under "Subscription"
    - Select the resource group you will be deploying to
    - Select the location for the resource group
    - In the template location select linked artifact
    - For the template name they will need to enter the path to the ARM template.  For example: '$(System.DefaultWorkingDirectory)/ARM-Templates/container-webapp-template.json'.  This is the path to the ARM template file once the job starts running.  When the pipeline starts, it will checkout the code from the repository, the jobs then run in the directory with access to those files
    - In the override template parameters they should enter the override values for each environment



- Check the YAML in the solutions **[`S03ARMtemplatedeployment.yaml`](./Solutions/S03ARMtemplatedeployment.yaml)** for the prefix part
- Check the **[Solution-03](./Solutions/Solution-03.json)** for entire possible solution for this challenge in UI form.
