# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack from the [WTH Coach's Repo](https://aka.ms/wthrepo) into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Local Workstation or Azure Cloud Shell

The majority of challenges of this hack can be completed using the Azure Cloud Shell in a web browser. However, it is worth the students taking the time to install all of the tools on their local workstation if they will be working with Azure and AKS going forward.

If students will use the Azure Cloud Shell, they should upload the `Resources.zip` file provided by the coach and unzip its contents there to complete the challenges.

### Windows Subsystem for Linux and the Azure CLI

Here are some things to be aware of that we have run into when hosting this hack previously:

- Installing the Windows Subsystem for Linux requires administrator priviledges on a Windows 10 or 11 device.  If the student does not have administrator priviledges on their workstation, they will need to use the Azure Cloud Shell.
- We recommend students install the Azure CLI into their WSL environment on Windows.
- We have observed that if students install the Azure CLI on Windows (via PowerShell or the Command Prompt), then install the Azure CLI again in the WSL environment, it can cause issues with the WSL environment's PATH environment variable.
  - The Azure CLI will show up twice in the PATH, once for Windows, and once for WSL.
  - WSL will attempt to call the Azure CLI version installed on Windows, not the WSL environment.
  - To resolve this, either:
    - Modify the PATH environment variable to move the Azure CLI + WSL location higher in the priority.
    - Uninstall the Azure CLI from Windows (PowerShell or Command Prompt)

### Docker Desktop

Installing [Docker Desktop](https://www.docker.com/products/docker-desktop/) is optional for students. Docker Desktop will install the Docker CLI and container engine on a Windows or Mac workstation.  Students can use Docker Desktop in Challenge 1 to build, run, and publish the sample application's container images on their local workstation.

Docker Desktop requires administrator priviledges on a Windows 10 or 11 device. If the student does not have administrator privileges on their workstation, they can use the Azure CLI (az acr build) to build and publish their container images to the Azure Container Registry from their local workstation OR from the Azure Cloud Shell. However, they will not be able to run the containers locally before attempting to deploy them to AKS in Challenge 2. 

Instead, students can test the containers out by running them in Azure Container Instances.  See the [Coach Guide for Challenge 1](Solution-01.md) for more information.

