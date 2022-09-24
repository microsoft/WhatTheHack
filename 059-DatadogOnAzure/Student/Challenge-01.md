# Challenge 01 - Alerts, Activity Logs, and Service Health

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Logs show everything that is happening to your resources at the API level. Platform logs from Azure in Datadog provide insights into subscription-level events. This includes information such as when a resource is modified or when a virtual machine is started.

## Description

Understand Azure platform logs, configure a monitor to get notified if a VM has been turned off, and view the service health.

- Update the parameters file and deployment script for the [GenerateMonitors.tf](Resources/Challenge-01/GenerateMonitors.tf?raw=true) template located in the `Challenge-01` folder of the `Resources.zip` file provided by your coach.
- Add the names of your VMs for your monitors
- Deploy the `GenerateMonitors.tf` template using the sample shell script (`deployMonitorTemplate.sh`).
- Verify you have new Monitors in Datadog or using the API. 
- Modify the `GenerateMonitors.tf` to include “Disk Write Operations/Sec” and set a threshold of 20
- Rerun your template and verify your new Monitors are created for each of your VMs
- Create a new Monitor configuration that suppresses alerts from the scale set and virtual machines

Bonus question/task:
- Will the Monitor get triggered if the VM was turned off from the OS? Or if the VM was not available? Why? What if it takes longer than expected to turn on?

## Success Criteria

To complete this challenge successfully, you should be able to:
 - Show the Monitor which got fired and explain what you have done.

## Learning Resources

- [Create Datadog Monitors](https://docs.datadoghq.com/monitors/create/)
- [Datadog Monitor Resource for Terraform](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor)
- [Automate Monitoring with the Terraform Datadog Provider](https://learn.hashicorp.com/tutorials/terraform/datadog-provider?in=terraform/use-case)

