# Challenge 08 - Visual Studio Code authoring

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)**

## Introduction

Editing the Logic App in the Azure portal is fine, but you also need to be able to check in your changes to source control.  This challenge will help you get started with Visual Studio Code. You can also do some editing directly in VS Code.

## Description

In this challenge, you will use Visual Studio Code to edit the Logic App that you created in the previous challenge.

- Download your app content from the Azure portal on the Logic App Overview blade (`Download app content` button)
- Copy the code into the `src/logic` directory of your repo
- Open the `workflow.json` files in both `code` & `Designer` view to compare them

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that you can download the Logic App from the Azure portal
- Verify that you can open the Logic App in Visual Studio Code

## Learning Resources

- [Logic Apps in VS Code](https://learn.microsoft.com/en-us/azure/logic-apps/create-single-tenant-workflows-visual-studio-code)
- [Logic Apps in Azure DevOps](https://learn.microsoft.com/en-us/azure/logic-apps/set-up-devops-deployment-single-tenant-azure-logic-apps?tabs=azure-devops)

## Tips
- You may have to open a new VS Code instance and just open the `src/logic` directory for the Logic App extension to work correctly.
- Select the `Content and Visual Studio project` and `Include app settings in the download`.
- Note that connectors that use `Managed Identity` may not work correctly in VS Code.