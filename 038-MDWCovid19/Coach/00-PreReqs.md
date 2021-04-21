# Challenge 0: Coach's Guide

**[Home](README.md)** - [Next Challenge >](./01-Background.md)

## Setting up Permissions 

Before continuing ensure you understand the permissions needed to run the WhatTheHack on your Azure subscription.

Attendees should have Azure subscription permissions which allow the creation of resources in their resource group. Additionally, attendees should have sufficient subscription permissions to create service principals in Azure AD and to register applications in Azure AD. Typically, all that is required is a user account with `Owner` role on their resource group.

## Common Azure Resources

The following is a list of common Azure resources that are deployed and utilized during the WhatTheHack. 

Ensure that these services are not blocked by Azure Policy.  As this is an WhatTheHack, the services that attendees can utilize are not limited to this list so subscriptions with a tightly controlled service catalog may run into issues if the service an attendee wishes to use is disabled via policy.

| Azure resource           | Resource Providers |
| ------------------------ | --------------------------------------- |
| Azure Cosmos DB          | Microsoft.DocumentDB 
| Azure Data Factory       | Microsoft.DataFactory                   |
| Azure Databricks         | Microsoft.Databricks                    |
| Azure SQL Database       | Microsoft.SQL                           |
| Azure Storage            | Microsoft.Storage                       |
| Azure Data Lake Store    | Microsoft.DataLakeStore                 |
| Azure Virtual Machines   | Microsoft.Compute                       |
| Azure Synapse            | Microsoft.Synapse                       |

> Note:  Resource Provider Registration can be found at https://portal.azure.com/_yourtenantname_.onmicrosoft.com/resource/subscriptions/_yoursubscriptionid_/resourceproviders

## Attendee Computers

Attendees will be required to install software on the workstations that they are performing the WhatTheHack on. Ensure they have adequate permissions to perform software installation.

## Deployment Instructions 

1. Open a **PowerShell 7** window, run the following command, if prompted, click **Yes to All**:

   ```PowerShell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   ```

2. The latest version of the Azure PowerShell cmdlets do **NOT** work with this script. You will need to use an earlier version (noted below)

    ```PowerShell
    Install-Module -Name Az -RequiredVersion 4.2.0 -Force -AllowClobber -SkipPublisherCheck
    ```

    > Note: If you need to uninstall first: [Uninstall the Azure PowerShell Module](https://docs.microsoft.com/en-us/powershell/azure/uninstall-az-ps)

3. If you installed an update, **close** the PowerShell 7 window, then **re-open** it. This ensures that the latest version of the Az module is used.

4. Execute the following to sign in to the Azure account that has the **Owner** role assignment in your subscription.

    ```PowerShell
    Connect-AzAccount
    ```

5. If you have more than one subscription, be sure to select the right one before the next step. Use `Get-AzSubscription` to list them and then use the command below to set the subscription you're using:

    ```powershell
    Select-AzSubscription -Subscription <The selected Subscription Id>
    ```

6. Assign the `$sqlpwd` and `$vmpwd` variables in your PowerShell session as **Secure Strings**. Be sure to use a strong password for both. Follow [this link](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/faq#what-are-the-password-requirements-when-creating-a-vm) for Virtual Machine password requirements and [this link](https://docs.microsoft.com/en-us/sql/relational-databases/security/password-policy?view=sql-server-2017#password-complexity) for SQL Server.

    ```powershell
    $sqlpwd = "ThePasswordYouWantToUseForSQL" | ConvertTo-SecureString -AsPlainText -Force
    $vmpwd = "ThePasswordYouWantToUseForTheVM" | ConvertTo-SecureString -AsPlainText -Force
    ``` 

7. If you have not already done so, you will need to download the `LabDeployment` folder from the repository.  You can use the following command to clone the repo to the current directory:

   ```shell
   git clone https://github.com/microsoft/WhatTheHack.git
   ```
   
8. Execute the following from the `LabDeployment\deploy` directory of the WhatTheHack repository clone to deploy the environment (this process may take 10-15 minutes):

    ```powershell
     .\deployAll.ps1 -sqlAdminLoginPassword $sqlpwd -vmAdminPassword $vmpwd
    ```

### Manual step - Assigning Users to Each Resource Group 

After deployment, manually add the appropriate users with owner access on the appropriate resource group for their team. 

**Some functionality within Synapse Studio will require the Storage Blob Data Contributor role for each user.**

See the following for detailed instructions for assigning users to roles.

[Add or remove Azure role assignments using the Azure portal](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal)

## Validate 
Resource Groups exist for each of the teams, members are in each team appropriately with owner permission on the resource group.

Prerequisites/other things to check for each team:

The deployment of the COVID19 Modern Data Warehousing WhatTheHack Lab environment includes the following for each team.

##### COVID Policy Resources

- A Cosmos DB account with a single collection for the covid policy tracker data

##### COVID Case Resources

- One Azure SQL DB in a single logical server
- A VM with a SQL DB

##### COVID Data Warehouse Resources

- Synapse Workspace as a potential target data store

## More detail on the usage of the services

##### azuredeploy.json

This deployment template links each of the others. The only dependency between the linked templates is that the deploysqlvm.json template depends on deploycosmosdb.json; the SQL VM's extension populates the Cosmos DB.

##### Parameters

Note that using the `azuredeploy.parameters.json` will supply most of these parameters for you. The ones which need attention at deployment time have been marked in **bold** below.

- sqlAdminLogin: The SQL administrator username for **all** SQL DBs in this deployment.
- **sqlAdminLoginPassword**: The password for the SqlAdminLogin on **all** SQL DBs in this deployment.
- covid19DacPacFileName: The filename for the .bacpac imported into the covid19 DB.
- vmAdminUsername: The administrator username for **all** VMs in this deployment
- **vmAdminPassword**: The password the for administrator on **all** VMs in this deployment
- covid19BackupFileName: The filename for the .bak imported into the "on-premises" VM
- covid19DatabaseName: The name of the "on-premises" database restored into the VM
- cloudFictitiousCompanyNamePrefix: The fictitious company name (prefix) for the resources deployed in a subscription
- **location**: The target Azure region