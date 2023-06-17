# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

There are a lot of important things covered in each challenge's Coach guide. Be sure to read this one all the way.  It's one of the most important!

### Solution Files & In-Line Sample Scripts

If you clone or download this repo to your local workstation, you will find YAML files that represent the solutions for the challenges in the `/Solutions` folder of this hack: [`039-AKS-EnterpriseGrade/Coach/Solutions`](./Solutions/). 

The YAML files have multiple placeholders in them that need to be replaced with values in order to deploy them to an AKS cluster.

Throughout this hack's coach guide, you will fine multiple in-line bash script blocks that demonstrate how to solve the challenges. These scripts:
- Deploy and configure the Azure resources that are needed to solve the challenges. (i.e. VNet, AKS cluster, Azure SQL Database, etc).
- Deploy (apply) the YAML files to the AKS cluster.

These script blocks are designed to be run from the `/Solutions` folder.  The script blocks reference the YAML files in the relative sub-folders for each challenge and replace the placeholders in the YAML files with values when the script blocks are run. 

To use these script blocks:
- Open a bash prompt (WSL/Terminal)
- Navigate to the `/Solutions` folder on your workstation
- Copy the script blocks from this guide, then paste and run them

**NOTE**: The code snippets provided in this Coach's Guide are just an orientation for you as a coach, and might not work 100% in your particular environment. They have been tested, but the rapid nature of Azure CLI versions, Kubernetes, AKS, helm, etc makes it very difficult constantly reviewing them on a regular basis. If you find errors in the code, please send a PR to this repo with the correction.

## Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack from the [WTH Coach's Repo](https://aka.ms/wthrepo) into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

**HINT: The students cannot complete Challenge 0 until you do this for them!**

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Local Workstation or Azure Cloud Shell

The majority of challenges of this hack can be completed using the Azure Cloud Shell in a web browser. However, it is worth the students taking the time to install all of the tools on their local workstation if they will be working with Azure and AKS going forward.

If students will use the Azure Cloud Shell, they should upload the `Resources.zip` file provided by the coach and unzip its contents there to complete the challenges.

### Windows Subsystem for Linux and the Azure CLI

Here are some things to be aware of that we have run into when hosting this hack previously:

- Installing the Windows Subsystem for Linux requires administrator privileges on a Windows 10 or 11 device.  If the student does not have administrator privileges on their workstation, they will need to use the Azure Cloud Shell.
- We recommend students install the Azure CLI into their WSL environment on Windows.
- We have observed that if students install the Azure CLI on Windows (via PowerShell or the Command Prompt), then install the Azure CLI again in the WSL environment, it can cause issues with the WSL environment's PATH environment variable.
  - The Azure CLI will show up twice in the PATH, once for Windows, and once for WSL.
  - WSL will attempt to call the Azure CLI version installed on Windows, not the WSL environment.
  - To resolve this, either:
    - Modify the PATH environment variable to move the Azure CLI + WSL location higher in the priority.
    - Uninstall the Azure CLI from Windows (PowerShell or Command Prompt)

### Docker Desktop

Installing [Docker Desktop](https://www.docker.com/products/docker-desktop/) is optional for students. Docker Desktop will install the Docker CLI and container engine on a Windows or Mac workstation.  Students can use Docker Desktop in Challenge 1 to build and run the sample application's container images on their local workstation. They can also use Docker desktop to publish those container images to Azure Container Registry.

The SQL Server container image referenced in Challenge 1 will not run in Docker Desktop on a Mac device with Apple Silicon (ARM).

Docker Desktop requires administrator privileges on a Windows 10 or 11 device. 

If the student does not have administrator privileges on their workstation, or is using a Mac with Apple Silicon, they can use the Azure CLI (`az acr build`) to build and publish their container images to the Azure Container Registry from their local workstation OR from the Azure Cloud Shell. However, they will not be able to run the containers locally before attempting to deploy them to AKS in Challenge 2. 

Instead, students can test the containers out by running them in Azure Container Instances.  See the [Coach Guide for Challenge 1](Solution-01.md) for more information.

