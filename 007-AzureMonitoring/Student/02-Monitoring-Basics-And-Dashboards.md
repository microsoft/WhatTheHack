# Challenge 2: Monitoring Basics and Dashboards

[Previous Challenge](./01-Alerts-Activity-Logs-And-Service-Health.md) - **[Home](../README.md)** - [Next Challenge>](./03-Azure-Monitor-For-Virtual-Machines.md)

## Introduction

## Description

1. Update the parameters file and deployment script for the GenerateAlertRules.json template located in the AlertTemplates folder
    - Add the names of your VMs and ResouceId for your Action Group
2. Deploy the GenerateAlertRules.json template using the sample PowerShell script (deployAlertRulesTemplate.ps1) or create a Bash script (look at the example from the initial deployment)
3. Verify you have new Monitor Alert Rules in the Portal or from the command line (sample command is in the PowerShell deployment script using new Az Monitor cmdlets)
4. Modify the GenerateAlertsRules.json to include “Disk Write Operations/Sec” and set a threshold of 20
5. Rerun your template and verify your new Alert Rules are created for each of your VMs
6. Create a new Action Rule that suppress alerts from the scale set and virtual machines

## Success Criteria

## Learning Resources
