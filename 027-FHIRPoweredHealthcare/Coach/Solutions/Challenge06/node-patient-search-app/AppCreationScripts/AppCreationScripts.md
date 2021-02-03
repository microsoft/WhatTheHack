# Registering the sample apps with the Microsoft identity platform and updating the configuration files using PowerShell

## Overview

### Quick summary

1. On Windows run PowerShell and navigate to the root of the cloned directory
1. In PowerShell run:

   ```PowerShell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
   ```

1. Run the script to create your Azure AD application and configure the code of the sample application accordingly. (Other ways of running the scripts are described below)

   ```PowerShell
   cd .\AppCreationScripts\
   .\Configure.ps1
   ```

1. Open the Visual Studio solution and click start

### More details

The following paragraphs:

- [Registering the sample apps with the Microsoft identity platform and updating the configuration files using PowerShell](#Registering-the-sample-apps-with-the-Microsoft-identity-platform-and-updating-the-configuration-files-using-PowerShell)
  - [Overview](#Overview)
    - [Quick summary](#Quick-summary)
    - [More details](#More-details)
  - [Goal of the provided scripts](#Goal-of-the-provided-scripts)
    - [Presentation of the scripts](#Presentation-of-the-scripts)
    - [Usage pattern for tests and DevOps scenarios](#Usage-pattern-for-tests-and-DevOps-scenarios)
  - [How to use the app creation scripts?](#How-to-use-the-app-creation-scripts)
    - [Pre-requisites](#Pre-requisites)
    - [Run the script and start running](#Run-the-script-and-start-running)
    - [Four ways to run the script](#Four-ways-to-run-the-script)
      - [Option 1 (interactive)](#Option-1-interactive)
      - [Option 2 (non-interactive)](#Option-2-non-interactive)
      - [Option 3 (Interactive, but create apps in a specified tenant)](#Option-3-Interactive-but-create-apps-in-a-specified-tenant)
      - [Option 4 (non-interactive, and create apps in a specified tenant)](#Option-4-non-interactive-and-create-apps-in-a-specified-tenant)
    - [Running the script on Azure Sovereign clouds](#Running-the-script-on-Azure-Sovereign-clouds)

## Goal of the provided scripts

### Presentation of the scripts

This sample comes with two PowerShell scripts, which automate the creation of the Azure Active Directory applications, and the configuration of the code for this sample. Once you run them, you will only need to build the solution and you are good to test.

These scripts are:

- `Configure.ps1` which:
  - creates Azure AD applications and their related objects (permissions, dependencies, secrets),
  - changes the configuration files in the C# and JavaScript projects.
  - creates a summary file named `createdApps.html` in the folder from which you ran the script, and containing, for each Azure AD application it created:
    - the identifier of the application
    - the AppId of the application
    - the url of its registration in the [Azure portal](https://portal.azure.com).

- `Cleanup.ps1` which cleans-up the Azure AD objects created by `Configure.ps1`. Note that this script does not revert the changes done in the configuration files, though. You will need to undo the change from source control (from Visual Studio, or from the command line using, for instance, git reset).

### Usage pattern for tests and DevOps scenarios

The `Configure.ps1` will stop if it tries to create an Azure AD application which already exists in the tenant. For this, if you are using the script to try/test the sample, or in DevOps scenarios, you might want to run `Cleanup.ps1` just before `Configure.ps1`. This is what is shown in the steps below.

## How to use the app creation scripts?

### Pre-requisites

1. Open PowerShell (On Windows, press  `Windows-R` and type `PowerShell` in the search window)
1. Navigate to the root directory of the project.
1. Until you change it, the default [Execution Policy](https:/go.microsoft.com/fwlink/?LinkID=135170) for scripts is usually `Restricted`. In order to run the PowerShell script you need to set the Execution Policy to `RemoteSigned`. You can set this just for the current PowerShell process by running the command:

    ```PowerShell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    ```

1. ### (Optionally) install AzureAD PowerShell modules
2. 
The scripts install the required PowerShell module (AzureAD) for the current user if needed. However, if you want to install if for all users on the machine, you can follow the following steps:

1. If you have never done it already, in the PowerShell window, install the AzureAD PowerShell modules. For this:

   1. Open PowerShell as admin (On Windows, Search Powershell in the search bar, right click on it and select Run as administrator).
   2. Type:
 
      ```PowerShell
      Install-Module AzureAD
      ```

      or if you cannot be administrator on your machine, run:
 
      ```PowerShell
      Install-Module AzureAD -Scope CurrentUser
      ```

### Run the script and start running

1. Go to the `AppCreationScripts` sub-folder. From the folder where you cloned the repo,

    ```PowerShell
    cd AppCreationScripts
    ```

1. Run the scripts. See below for the [four options](#four-ways-to-run-the-script) to do that.
1. Open the Visual Studio solution, and in the solution's context menu, choose **Set Startup Projects**.
1. select **Start** for the projects

You're done. this just works!

### Four ways to run the script

We advise four ways of running the script:

- Interactive: you will be prompted for credentials, and the scripts decide in which tenant to create the objects,
- non-interactive: you will provide credentials, and the scripts decide in which tenant to create the objects,
- Interactive in specific tenant:  you will provide the tenant in which you want to create the objects and then you will be prompted for credentials, and the scripts will create the objects,
- non-interactive in specific tenant: you will provide tenant in which you want to create the objects and credentials, and the scripts will create the objects.

Here are the details on how to do this.

#### Option 1 (interactive)

- Just run ``. .\Configure.ps1``, and you will be prompted to sign-in (email address, password, and if needed MFA).
- The script will be run as the signed-in user and will use the tenant in which the user is defined.

Note that the script will choose the tenant in which to create the applications, based on the user. Also to run the `Cleanup.ps1` script, you will need to re-sign-in.

#### Option 2 (non-interactive)

When you know the identity and credentials of the user in the name of whom you want to create the applications, you can use the non-interactive approach. It's more adapted to DevOps. Here is an example of script you'd want to run in a PowerShell Window

```PowerShell
$secpasswd = ConvertTo-SecureString "[Password here]" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("[login@tenantName here]", $secpasswd)
. .\Cleanup.ps1 -Credential $mycreds
. .\Configure.ps1 -Credential $mycreds
```

Of course, in real life, you might already get the password as a `SecureString`. You might also want to get the password from KeyVault.

#### Option 3 (Interactive, but create apps in a specified tenant)

  if you want to create the apps in a particular tenant, you can use the following option:
  
- open the [Azure portal](https://portal.azure.com)
- Select the Azure Active directory you are interested in (in the combo-box below your name on the top right of the browser window)
- Find the "Active Directory" object in this tenant
- Go to **Properties** and copy the content of the **Directory Id** property
- Then use the full syntax to run the scripts:

```PowerShell
$tenantId = "yourTenantIdGuid"
. .\Cleanup.ps1 -TenantId $tenantId
. .\Configure.ps1 -TenantId $tenantId
```

#### Option 4 (non-interactive, and create apps in a specified tenant)

This option combines option 2 and option 3: it creates the application in a specific tenant. See option 3 for the way to get the tenant Id. Then run:

```PowerShell
$secpasswd = ConvertTo-SecureString "[Password here]" -AsPlainText -Force
$mycreds = New-Object System.Management.Automation.PSCredential ("[login@tenantName here]", $secpasswd)
$tenantId = "yourTenantIdGuid"
. .\Cleanup.ps1 -Credential $mycreds -TenantId $tenantId
. .\Configure.ps1 -Credential $mycreds -TenantId $tenantId
```

### Running the script on Azure Sovereign clouds

All the four options listed above, can be used on any Azure Sovereign clouds. By default, the script targets `AzureCloud`, but it can be changed using the parameter `-AzureEnvironmentName`.

The acceptable values for this parameter are:

- AzureCloud
- AzureChinaCloud
- AzureUSGovernment
- AzureGermanyCloud

Example:

 ```PowerShell
 . .\Cleanup.ps1 -AzureEnvironmentName "AzureGermanyCloud"
 . .\Configure.ps1 -AzureEnvironmentName "AzureGermanyCloud"
 ```
