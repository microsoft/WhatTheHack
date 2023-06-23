# Challenge 06 - Parameterize with app settings

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

An important part a well-architected solution is the ability to parameterize values that will change between environments/deployments/etc. Logic Apps supports similar app settings to what you may be familiar with in Azure Functions, Web Apps, etc. 

## Description

In this challenge, you will parameterize the storage account container name in the `storage` workflow using an app setting.

- Look at the `Configuration->Application Settings` section of your Logic App and note the app setting names & values for the following parameter:
  - STORAGE_ACCOUNT_CONTAINER_NAME
- Add a `parameter` to the `storage` workflow and pull the name of the storage account container from App Settings
  - `@appsetting('STORAGE_ACCOUNT_CONTAINER_NAME')`
- Modify the `Upload blob to storage container` action to use the new parameter
- Save & test your workflow to ensure it still works

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the storage account container name is being pulled from app settings instead of being hard-coded.

## Learning Resources

- [Create cross-environment parameters for workflow inputs in Azure Logic Apps](https://learn.microsoft.com/en-us/azure/logic-apps/create-parameters-workflows?tabs=standard)

## Tips
- You will need to remove the double quotes surrounding the parameter definition value if the Logic App designer adds them. You may have to play with this a bit get it to save without them (let it add them, save the workflow, then remove them & save again).

  ![parameter-container-name](../images/Challenge-06//parameter-container-name.png)