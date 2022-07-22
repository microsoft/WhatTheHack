# Challenge 2: Always Need App Insights

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

All app development work in Azure should have Application Insights turned on and used by default. This invaluable tool can be used for standard and custom telemetry and much more.

## Description

- In your shell, deploy the provided ARM Template to create an Application Insights resource we will use for the various applications to log to.
  - ARM Template: `azuredeploy-appinsights.json`
    - This file can be found in the Files section of the General channel in Teams.
    - Two Parameters:
      - `name`:  Name of the App Insights Resource to Create
      - `regionId`: Scripting Name of the region to Provision in
- Put the `InstrumentationKey` of the App Insights resource you just created in a variable called appInsightsKey

## Success Criteria

1. You have used the provided template to create you own App Insights resource.
2. You've saved off the `InstrumentationKey` in a variable for future use.

## Learning Resources

- [Overview of Application Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
- [Authoring ARM Templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-authoring-templates)
