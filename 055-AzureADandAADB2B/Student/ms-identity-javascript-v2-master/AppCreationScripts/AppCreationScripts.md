# Registering the sample apps updating the configuration files using PowerShell

## Quick summary

1. On Windows run PowerShell as **Administrator** and navigate to the root of the cloned directory
1. In PowerShell run:

  ```PowerShell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

1. Run the script to create your Azure AD application and configure the code of the sample application accordingly.

  ```PowerShell
    cd .\AppCreationScripts
    .\Configure.ps1 -TenantId "ENTER_TENANT_ID"
  ```

## More details

This sample comes with two PowerShell scripts, which automate the creation of the Azure Active Directory applications, and the configuration of the code for this sample. Once you run them, you will only need to build the solution and you are good to test.

These scripts are:

- `Configure.ps1` which:
  - creates Azure AD applications and their related objects (permissions, dependencies, secrets),
  - changes the configuration files in the source code.
  - creates a summary file named `createdApps.html` in the folder from which you ran the script, and containing, for each Azure AD application it created:
    - the identifier of the application
    - the AppId of the application
    - the url of its registration in the [Azure portal](https://portal.azure.com).

- `Cleanup.ps1` which cleans-up the Azure AD objects created by `Configure.ps1`. Note that this script does not revert the changes done in the configuration files, though. You will need to undo the change from source control (from Visual Studio, from VS Code, or from the command line using, for instance, `git reset`).

The `Configure.ps1` will stop if it tries to create an Azure AD application which already exists in the tenant. For this, if you are using the script to try/test the sample, or in DevOps scenarios, you might want to run `Cleanup.ps1` just before `Configure.ps1`. This is what is shown in the steps below.

### Pre-requisites

1. Open PowerShell (On Windows, press  `Windows-R` and type `PowerShell` in the search window)
1. Navigate to the root directory of the project.
1. Until you change it, the default [Execution Policy](https:/go.microsoft.com/fwlink/?LinkID=135170) for scripts is usually `Restricted`. In order to run the PowerShell script you need to set the Execution Policy to `RemoteSigned`. You can set this just for the current PowerShell process by running the command:

    ```PowerShell
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```

The scripts install the required PowerShell module (Microsoft.Graph.Applications) for the current user if needed. However, if you want to install if for all users on the machine, you can follow the steps below:

  1. Open PowerShell as admin (On Windows, Search Powershell in the search bar, right click on it and select Run as administrator).
  2. Type: `Install-Module Microsoft.Graph.Applications`

### Running the script
  
- Open the [Azure portal](https://portal.azure.com)
- Select the Azure Active directory you are interested in (in the combo-box below your name on the top right of the browser window)
- Find the "Active Directory" object in this tenant
- Go to **Properties** and copy the content of the **Directory Id** property
- Then use the full syntax to run the scripts:

```PowerShell
  $tenantId = "yourTenantIdGuid"
  .\Cleanup.ps1 -TenantId $tenantId
  .\Configure.ps1 -TenantId $tenantId
```
