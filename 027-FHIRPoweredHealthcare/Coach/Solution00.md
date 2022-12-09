# Coach's Guide: Challenge 0 - Pre-requisites - Ready, Set, GO!

**[Home](./README.md)** - [Next Challenge>](./Solution01.md)

## Notes & Guidance

**Install the recommended tool set:** 
- Access to an **Azure subscription** with Owner access. **[Sign Up for Azure HERE](https://azure.microsoft.com/en-us/free/)**
- **[Windows Subsystem for Linux (Windows 10-only)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)**
    -  WSL is needed for shell script examples in hack or use cli on browser via shell.azure.com
        - Install Windows Subsystem for Linux: open PowerShell as Administrator and run:
            ```PowerShell
            $ Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
            ```
- **[Windows PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7)** version 5.1
  - Confirm PowerShell version is **[5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616)** `$PSVersionTable.PSVersion`
  - **[PowerShell modules](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_modules?view=powershell-7)**
    - Confirm PowerShell module versions.  Re-install the required version below (if needed):
      - Az version 4.1.0 
      - AzureAd version 2.0.2.4
        ```PowerShell
        Get-InstalledModule -Name Az -AllVersions
        Get-InstalledModule -Name AzureAd -AllVersions
        ```
- **[Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)**
   - (Windows-only) Install Azure CLI on Windows Subsystem for Linux
   - Update to the latest
   - Must be at least version 2.7.x
- Alternatively, you can use the **[Azure Cloud Shell](https://shell.azure.com/)**
- **[.NET Core 3.1](https://dotnet.microsoft.com/download/dotnet-core/3.1)**
- **[Java 1.8 JDK](https://www.oracle.com/java/technologies/javase/javase-jdk8-downloads.html)** (needed to run Synthea Patient Generator tool)
- **[Visual Studio Code](https://code.visualstudio.com/)**
- Install VS Code Extensions
    - **[Node Module Extension for VS Code](https://code.visualstudio.com/docs/nodejs/extensions)**
    - **[App Service extension for VS Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureappservice)**
- Download and install latest **[Node pre-built installer](https://nodejs.org/en/download/)** for your platform
- Download and install **[Node.js and npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)**
    - Install the latest version of **[nodejs](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)** (at least 10.x) on your machine, if using Windows, use the bash shell in the Windows Subsystem for Linux
        - Install dotenv npm module: 
        ```bash
        $ npm install dotenv --save
        ```
        - Install FHIR npm library: 
        ```bash
        $ npm install fhir
        ```
- Install **[Postman](https://www.getpostman.com)**




