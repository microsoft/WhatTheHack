# Challenge 03 - Azure Monitor for Virtual Machines

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

In this challenge you will put together a comprehensive solution to monitor virtual machine operations. This will include exploration of VM Insights, Update Management, and Configuration Management.

## Description

Use Azure Policy to enable VM Insights, Update Management, Configuration Management resources to monitor VM operations and performance.

In this challenge you need to complete the following management tasks:

- Configure VM Insights for all virtual machines
  - Add VM Insights solution to workspace
  - Use Azure Policy to Enable VM Insights for all VMs
  - Pin Performace graphs from the VM Insights workbook to the dashboard

- Configure Update Management for all virtual machines
  - Create Azure Automation Account and link it to Log Analytics workspace - [Supported regions for linked Log Analytics workspace](https://docs.microsoft.com/en-us/azure/automation/update-management/enable-from-portal#enable-update-management)
  - Enable VM Update Management solution
  - Enable Automatic OS image upgrades for VM Scaleset
  - Pin Update Management summary to dashboard

- Monitor in-guest VM configuration drift
  - Enable guest configuration audit through Azure policy
  - Pin policy compliance summary to dashboard

>**Note:** Automatic VM guest patching for Azure VMs available in Public Preview.

## Success Criteria

- Show your dashboard with VM Insights performance graphics, Update Management report, and shortcut to Guest Config policy compliance report.

![Example of Final Dashboard](../Images/03-01-Final-Dashboard.png)

## Learning Resources

- [Cloud Adoption Framework - Management and Monitoring](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/enterprise-scale/management-and-monitoring)
- [Configure Log Analytics workspace for VM Insights](https://docs.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-configure-workspace?tabs=CLI#add-vminsights-solution-to-workspace)
- [Enable VM insights by using Azure Policy](https://docs.microsoft.com/en-us/azure/azure-monitor/vm/vminsights-enable-policy)
- [Azure Monitor Workbooks - Pinning Visualizations](https://docs.microsoft.com/en-us/azure/azure-monitor/visualize/workbooks-overview#pinning-visualizations)
- [Update Management overview](https://docs.microsoft.com/en-us/azure/automation/update-management/overview)
- [Operating systems supported by Update Management](https://docs.microsoft.com/en-Us/azure/automation/update-management/operating-system-requirements#:~:text=Update%20Management%20does%20not%20support%20safely%20automating%20update,managing%20OS%20image%20upgrades%20on%20your%20scale%20set)
- [Enable Update Management from the Azure portal](https://docs.microsoft.com/en-us/azure/automation/update-management/enable-from-portal#enable-update-management)
- [Configure automatic OS image upgrade for VMSS](https://docs.microsoft.com/en-us/azure/virtual-machine-scale-sets/virtual-machine-scale-sets-automatic-upgrade)
- [Understand the guest configuration feature of Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/guest-configuration)
- [Preview: Automatic VM guest patching for Azure VMs](https://docs.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching)
