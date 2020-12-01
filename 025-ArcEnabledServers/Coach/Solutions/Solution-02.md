# Challenge 02: Policy for Azure Arc connected servers - Coach's Guide

[< Previous Challenge](./Solution-01.md) - **[Home](../readme.md)** - [Next Challenge>](./Solution-03.md)

## Notes & Guidance

1. Assign a policy that adds a resource tag to all resources in the resource group where your Azure Arc connected servers are located.

- In the Azure portal, create a policy assignment targeting the **arc-enabled-servers-rg** resource group based on the built-in policy definition **Add or replace a tag on resources**. 

   >**Note**: Do not use **Append a tag and its value to resources**, since you need a policy definition with **modify** effect in order to apply it to existing resources. Make sure to create a remediation task and enable **Managed Identity**. Set **Tag name** to **arcchallenge2a** and **Tag value** to **Completed**.

   >**Note**: Do not wait for the policy processing to take place but proceed to the next step.

2. Create a suitable Log Analytics workspace to use with your Azure Arc resources. Make sure it is in the same region as your Azure Arc resources to avoid egress charges.

- In the Azure portal, create a Log Analytics workspace in a new resource group named **arc-challenge-infra**.

3. Assign a policy that automatically deploys the Log Analytics agent to Azure Arc connected servers if they do not have the agent.

- In the Azure portal, create a policy assignment targeting the **arc-enabled-servers-rg** resource group and the newly created Log Analytics workspace. Use the built-in policy definition **[Preview]: Deploy Log Analytics agent to Windows Azure Arc machines**. Make sure to create a remediation task and enable **Managed Identity** in the location matching the location of Arc enabled Server resource. Do not use the built-in definition **Deploy Log Analytics agent for Windows VMs**.

   >**Note**: Do not wait for the policy processing to take place but proceed to the next step. 

4. Configure the Log Analytics agent to collect performance metrics of the connected machine.

- In the Azure portal, on the blade of the newly provisioned Log Analytics workspace, navigate to the **Advanced Settings** blade, select **Data** and configure collection of **Windows Performance Counters**.
- Navigate to the **Policy | Remediation** blade and track the progress of the remediation task associated with the policy assignment that controls the installation of the Log Analytics agent. Wait until that task reports the **Complete** remediation status.
- Navigate back to the Log Analytics workspace, display its **Logs** blade, select **Virtual machines** as the resource type, and select one of the sample performance-related queries (e.g. **Chart CPU usage trends**).

### Success Criteria

1. Azure Arc connected servers should have a tag applied by the policy you created in Challenge #1. 
2. Azure Arc connected servers should have the Log Analytics agent deployed and working.
3. You can use the Log Analytics workspace to query performance metrics about your Azure Arc connected machine.
