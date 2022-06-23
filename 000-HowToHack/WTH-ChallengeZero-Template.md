# Challenge 00 - Prerequisites - Ready, Set, GO!

<!-- REMOVE_ME ${navigationLine} (remove this from your MD files if you are writing them manually, this is for the automation script) REMOVE_ME -->

<!-- REPLACE_ME (this section will be removed by the automation script) -->
<!-- If you are using and editing this template manually, ensure the navigation link below is updated to link to next challenge relative to the current challenge. The "Home" link should always link to the homepage of the hack which is the README.md in the hack's parent directory. -->

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

<!-- REPLACE_ME (this section will be removed by the automation script) -->

**_This is a template for "Challenge Zero" which focuses on getting prerequisites set up for the hack. The italicized text provides hints & examples of what should or should NOT go in each section._**

**_We have included links to some common What The Hack pre-reqs in this template. All common prerequisite links go to the WTH-CommonPrerequisites page where there are more details on what each tool's purpose is._**

**_You should remove any common pre-reqs that are not required for your hack. Then add additional pre-reqs that are required for your hack in the Description section below._**

**_You should remove all italicized & sample text in this template and replace with your content._**

## Introduction

<!-- REMOVE_ME Thank you for participating in the ${nameOfHackArg} What The Hack. Before you can hack, you will need to set up some prerequisites. (remove this from your MD files if you are writing them manually, this is for the automation script) REMOVE_ME -->

<!-- REPLACE_ME (this section will be removed by the automation script) -->

Thank you for participating in the IoT Hack of the Century What The Hack. Before you can hack, you will need to set up some prerequisites.

<!-- REPLACE_ME (this section will be removed by the automation script) -->

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Windows Subsystem for Linux](../../000-HowToHack/WTH-Common-Prerequisites.md#windows-subsystem-for-linux)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)
- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
  - [VS Code plugin for ARM Templates](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code-plugins-for-arm-templates)
- [Azure Storage Explorer](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-storage-explorer)

## Description

_This section should clearly state any additional prerequisite tools that need to be installed or set up in the Azure environment that the student will hack in._

_While ordered lists are generally not welcome in What The Hack challenge descriptions, you can use one here in Challenge Zero IF and only IF the steps you are asking the student to perform are not core to the learning objectives of the hack._

_For example, if the hack is on IoT Devices and you want the student to deploy an ARM/Bicep template that sets up the environment they will hack in without them needing to understand how ARM/Bicep templates work, you can provide step-by-step instructions on how to deploy the ARM/Bicep template._

_Optionally, you may provide resource files such as a sample application, code snippets, or templates as learning aids for the students. These files are stored in the hack's \`Student/Resources\` folder. It is the coach's responsibility to package these resources into a Resources.zip file and provide it to the students at the start of the hack. You should leave the sample text below in that refers to the Resources.zip file._

**\*NOTE:** Do NOT provide direct links to files or folders in the What The Hack repository from the student guide. Instead, you should refer to the Resources.zip file provided by the coach.\*

**\*NOTE:** Any direct links to the What The Hack repo will be flagged for review during the review process by the WTH V-Team, including exception cases.\*

_Sample challenge zero text for the IoT Hack Of The Century:_

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specifc to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

- [Azure IoT Tools](https://marketplace.visualstudio.com/items?itemName=vsciot-vscode.azure-iot-tools) extension for Visual Studio Code
- .NET SDK 6.0 or later installed on your development machine. This can be downloaded from [here](https://www.microsoft.com/net/download/all) for multiple platforms.

In the \`/Challenge00/\` folder of the Resources.zip file, you will find an ARM template, \`setupIoTEnvironment.json\` that sets up the initial hack environment in Azure you will work with in subsequent challenges.

Please deploy the template by running the following Azure CLI commands from the location of the template file:
\`\`\`
az group create --name myIoT-rg --location eastus
az group deployment create -g myIoT-rg --name HackEnvironment -f setupIoTEnvironment.json
\`\`\`

## Success Criteria

_Success criteria goes here. The success criteria should be a list of checks so a student knows they have completed the challenge successfully. These should be things that can be demonstrated to a coach._

_The success criteria should not be a list of instructions._

_Success criteria should always start with language like: "Validate XXX..." or "Verify YYY..." or "Show ZZZ..." or "Demonstrate you understand VVV..."_

_Sample success criteria for the IoT prerequisites challenge:_

To complete this challenge successfully, you should be able to:

- Verify that you have a bash shell with the Azure CLI available.
- Verify that the ARM template has deployed the following resources in Azure:
  - Azure IoT Hub
  - Virtual Network
  - Jumpbox VM

## Learning Resources

_List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge._

_Think of this list as giving the students a head start on some easy Internet searches. However, try not to include documentation links that are the literal step-by-step answer of the challenge's scenario._

**\*Note:** Use descriptive text for each link instead of just URLs.\*

_Sample IoT resource links:_

- [What is a Thingamajig?](https://www.bing.com/search?q=what+is+a+thingamajig)
- [10 Tips for Never Forgetting Your Thingamajic](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
- [IoT & Thingamajigs: Together Forever](https://www.youtube.com/watch?v=yPYZpwSpKmA)
