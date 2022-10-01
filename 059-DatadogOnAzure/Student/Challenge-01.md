# Challenge 01 - Alerts, Activity Logs, and Service Health

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Logs show everything that is happening to your resources at the API level. Platform logs from Azure in Datadog provide insights into subscription-level events. This includes information such as when a resource is modified or when a virtual machine is started.

## Description

Understand Azure platform logs, configure a monitor to get notified if a VM has been turned off, and view the service health.

There are multiple ways to configure monitoring in Datadog.  You can configure monitoring manually in the Datadog portal or via the Datadog API.  This is a great way to learn how Datadog works and what settings are available to choose from. 

However, this method does not scale when you need to configure monitoring across 10s, 100s, or even 1000s of resources in Azure. It is easier to configure monitoring at scale across many Azure resources if you use a declarative infrastructure-as-code tool such as Terraform.

> **Note** Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files. It's often best practice to use infrastructure as code (IAC) to deploy resources into Azure for repeatability, fewer mistakes from manual processes, and leverage the organization's CI/CD pipeline.

For this challenge, you will use Terraform to deploy the Datadog monitor. We have provided you with a sample Terraform file that can be used to configure monitoring in Datadog. 

You can find the sample Terraform file, `GenerateMonitors.tf`, in the `/Challenge-01` folder of the `Resources.zip` file provided by your coach. To complete the challenge, navigate to the location of this file using your terminal client (WSL or Azure Cloud Shell).

- Update the parameters of the `GenerateMonitors.tf` file 
- Add the names of your VMs for your monitors
- Deploy the `GenerateMonitors.tf` template using: 

    ```terraform apply -f GenerateMonitors.tf```
 
- Modify the `GenerateMonitors.tf` to include “Disk Write Operations/Sec” and set a threshold of 20
- Rerun your template and verify your new Monitors are created for each of your VMs
- Create a new Monitor configuration that suppresses alerts from the scale set and virtual machines

Bonus question/task:
- Will the Monitor get triggered if the VM was turned off from the OS? Or if the VM was not available? Why? What if it takes longer than expected to turn on?

## Success Criteria

To complete this challenge successfully, you should be able to:
 - Verify you have new Monitors in Datadog or using the API.
 - Show the Monitor which got fired and explain what you have done.

## Learning Resources

- [Create Datadog Monitors](https://docs.datadoghq.com/monitors/create/)
- [Datadog Monitor Resource for Terraform](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor)
- [Automate Monitoring with the Terraform Datadog Provider](https://learn.hashicorp.com/tutorials/terraform/datadog-provider?in=terraform/use-case)
- [Introduction to Terraform](https://www.youtube.com/watch?v=h970ZBgKINg&t=943s&ab_channel=HashiCorp)
