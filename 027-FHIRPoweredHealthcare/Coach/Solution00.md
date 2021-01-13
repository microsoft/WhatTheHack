# Coach's Guide: Challenge 0 - Pre-requisites - Ready, Set, GO!

**[Home](./readme.md)** - [Next Challenge>](./Solution01.md)

# Notes & Guidance
## Pre-requiste: Lab Environment Setup
- **[Install the WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)**, needed for shell script examples in hack or use cli on browser via shell.azure.com
    - Install Windows Subsystem for Linux: open PowerShell as Administrator and run:
        - $ Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
- Install your Linux Distro, download and install ubuntu from the Windows Store
    - Initialize newly installed distro
    - Setup a new Linux user account for use with sudo: create a new user and password
- **[Install the Azure CLI in the WSL](https://docs.microsoft.com/en-us/cli/azure/install-azurecli?view=azure-cli-latest)** if you haven’t already.
    - For windows OS, use bash shell in Windows Subsystem for Linux (see WLS install under tool-set below)
- **[Install VS Code](https://code.visualstudio.com/)**
- Install VS Code Extensions
    - Install Azure Function core tools via PowerShell: $ npm i -g azure-functions-core-tools@2
        - Validate installation: $ func
- **Optionally, [Install Azure Storage Explorer](http://storageexplorer.com)**
- Download and install latest **[Node pre-built installer](https://nodejs.org/en/download/)** for your platform
- Install the latest version of nodejs (at least 10.x) on your machine, if using Windows, use the bash shell in the Windows Subsystem for Linux
    - Install dotenv npm module: $ npm install dotenv --save
    - Install FHIR npm library: $ npm install fhir




