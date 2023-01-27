# Challenge 01 - Alerts, Activity Logs, and Service Health

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Logs show everything that is happening to your resources at the API level. Platform logs from Azure in Datadog provide insights into subscription-level events. This includes information such as when a resource is modified or when a virtual machine is started.

In the eShopOnWeb Azure environment, there are three compute resources to be aware of:
- **`vmss-wth-monitor-d-XX`** - Virtual Machine Scale Set (VMSS) hosting the eShopOnWeb web site
- **`vmwthdbdXX`** - Virtual Machine running SQL Server 2019 hosting the eShopOnWeb database
- **`vmwthvsdXX`** - Virtual Machine running Windows Server 2022 + Visual Studio 2022 + SQL Management Studio to act as a "jumpbox" that you will login to for administrative tasks.

>**Note** The "XX" in each resource name will vary based on the Azure region the eShopOnWeb Azure environment has been deployed to.

Azure Bastion has been configured to enable you to securely login to any of these VMs with a Remote Desktop session through a web brower. 

To login to a VM via Azure Bastion, navigate to the blade for any of these VMs in the Azure portal, click the "Connect" button, and select "Bastion". Use the username and password provided in Challenge 0.


## Description

For this challenge, your goal is to understand Azure platform logs, configure a monitor to get notified if a VM has been turned off, and view the service health.

You will do this by configuring monitors with Datadog on the SQL Server VM (`vmwthdbdXX`).

### Install & Configure Datadog Agent
- On the SQL Server VM, complete the Datadog install and configure database monitoring
- Configure the Datadog agent's API key

### Configure Monitors with Datadog

There are multiple ways to configure monitoring in Datadog.  You can configure monitoring manually in the Datadog portal or via the Datadog API.  This is a great way to learn how Datadog works and what settings are available to choose from. 

However, this method does not scale when you need to configure monitoring across 10s, 100s, or even 1000s of resources in Azure. It is easier to configure monitoring at scale across many Azure resources if you use a declarative infrastructure-as-code tool such as Terraform.

> **Note** Terraform is an open-source infrastructure as code software tool that provides a consistent CLI workflow to manage hundreds of cloud services. Terraform codifies cloud APIs into declarative configuration files. It's often best practice to use infrastructure as code (IAC) to deploy resources into Azure for repeatability, fewer mistakes from manual processes, and leverage the organization's CI/CD pipeline.

For this challenge, you will use Terraform to deploy the Datadog monitor. We have provided you with a sample Terraform file that can be used to configure monitoring in Datadog. 

You can find the sample Terraform file, `GenerateMonitors.tf`, in the `/Challenge-01` folder of the `Resources.zip` file provided by your coach. To complete the challenge, navigate to the location of this file using your terminal client (WSL or Azure Cloud Shell).

- Update the parameters of the `GenerateMonitors.tf` file 
- Add the names of your VMs for your monitors
- Deploy the `GenerateMonitors.tf` template using: 

    ```terraform init && terraform apply -auto-approve```
 
- Modify the `GenerateMonitors.tf` to include “Disk Write Operations/Sec” and set a threshold of 20
- Rerun your template and verify your new Monitors are created for each of your VMs

Bonus question/task:
- Will the Monitor get triggered if the VM was turned off from the OS? Or if the VM was not available? Why? What if it takes longer than expected to turn on?

## Success Criteria

To complete this challenge successfully, you should be able to:
 - Verify you have new Monitors in Datadog or using the API.
 - Show the Monitor which got fired and explain what you have done.

## Learning Resources

- [Create Datadog Monitor Types](https://docs.datadoghq.com/monitors/types/)
- [Datadog Monitor Resource for Terraform](https://registry.terraform.io/providers/DataDog/datadog/latest/docs/resources/monitor)
- [Automate Monitoring with the Terraform Datadog Provider](https://learn.hashicorp.com/tutorials/terraform/datadog-provider?in=terraform/use-case)
- [Introduction to Terraform](https://www.youtube.com/watch?v=h970ZBgKINg&t=943s&ab_channel=HashiCorp)
