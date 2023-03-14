# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

**_This is a template for "Challenge Zero" which focuses on getting prerequisites set up for the hack. The italicized text provides hints & examples of what should or should NOT go in each section._**

**_We have included links to some common What The Hack pre-reqs in this template. All common prerequisite links go to the WTH-CommonPrerequisites page where there are more details on what each tool's purpose is._**

**_You should remove any common pre-reqs that are not required for your hack. Then add additional pre-reqs that are required for your hack in the Description section below._**

**_You should remove all italicized & sample text in this template and replace with your content._**

## Introduction

 You are new engineer that is hired to modernize a ecommerce website for company called "DTOrders".  "DTOrders" currently has this website deployed to Azure virtual machines but  wants to containerize this application to run on Kubernetes.  Your job will first be deploy the application to Azure VM and then migrate it run on AKS Cluster.  Along the way, you'll use Dynatrace to  monitor the application on Azure VM and once migrated to AKS, compare the product functionality and how easy it is to monitor and manage your application with Dynatrace.  

 Upon successful migration, you'll present the deployed solution to your company's leadership to seek approval on how quickly and easily you achieve full stack observability in minutes, everything in context including metrics, logs, and trace for all your Azure workloads with Dynatrace.  While at at same time you'll achieve a fully automated, AI-assisted observability across Azure environments.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete most What The Hack Azure-based hacks!

You might not need all of them for the hack you are participating in. However, if you work with Azure on a regular basis, these are all things you should consider having in your toolbox.

<!-- If you are editing this template manually, be aware that these links are only designed to work if this Markdown file is in the /xxx-HackName/Student/ folder of your hack. -->

- [Azure Subscription](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-subscription)
- [Managing Cloud Resources](../../000-HowToHack/WTH-Common-Prerequisites.md#managing-cloud-resources)
  - [Azure Portal](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-portal)
  - [Azure CLI](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cli)
    - [Note for Windows Users](../../000-HowToHack/WTH-Common-Prerequisites.md#note-for-windows-users)
    - [Azure PowerShell CmdLets](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-powershell-cmdlets)
  - [Azure Cloud Shell](../../000-HowToHack/WTH-Common-Prerequisites.md#azure-cloud-shell)


## Description
<!--
_This section should clearly state any additional prerequisite tools that need to be installed or set up in the Azure environment that the student will hack in._

_While ordered lists are generally not welcome in What The Hack challenge descriptions, you can use one here in Challenge Zero IF and only IF the steps you are asking the student to perform are not core to the learning objectives of the hack._

_For example, if the hack is on IoT Devices and you want the student to deploy an ARM/Bicep template that sets up the environment they will hack in without them needing to understand how ARM/Bicep templates work, you can provide step-by-step instructions on how to deploy the ARM/Bicep template._

_Optionally, you may provide resource files such as a sample application, code snippets, or templates as learning aids for the students. These files are stored in the hack's `Student/Resources` folder. It is the coach's responsibility to package these resources into a Resources.zip file and provide it to the students at the start of the hack. You should leave the sample text below in that refers to the Resources.zip file._

**\*NOTE:** Do NOT provide direct links to files or folders in the What The Hack repository from the student guide. Instead, you should refer to the Resources.zip file provided by the coach.\*

**\*NOTE:** Any direct links to the What The Hack repo will be flagged for review during the review process by the WTH V-Team, including exception cases.\*

_Sample challenge zero text for the IoT Hack Of The Century:_
-->

Now that you have the common pre-requisites installed on your workstation, there are prerequisites specific to this hack.

Your coach will provide you with a Resources.zip file that contains resources you will need to complete the hack. If you plan to work locally, you should unpack it on your workstation. If you plan to use the Azure Cloud Shell, you should upload it to the Cloud Shell and unpack it there.

Please install these additional tools:

1) Gain access to an Azure subscription
    - Sign up for Azure [Free Trial Account](https://azure.microsoft.com/en-us/free/)
    - Use an existing Azure Subscription (Note, you will need Owner role assigned to you in order to deploy the Azure resources used in this Hack)
2) Sign-up for free [Trial of Dynatrace](https://www.dynatrace.com/trial/?utm_medium=alliances&utm_source=microsoft_wth&utm_campaign=website&utm_content=none&utm_term=none) with full feature set of our all-in-one performance monitoring platform to monitor Azure.  

3) Familiarize yourself with [Azure Cloud Shell](https://learn.microsoft.com/en-us/azure/cloud-shell/overview).  We'll be using the cloud shell to deploy our Azure resources

### Dynatrace Portal Prep

 For this challenge, you will deploy the DTOrders application and its underlying Azure VM resources to Azure using a set of pre-developed scripts. Once the application and its infrastructure are deployed, you will complete the hack's jumping in and fully analyze the application within Dynatrace.


- If not already done so, go to the [Dynatrace Trial site](https://www.dynatrace.com/trial/?utm_medium=alliance&utm_source=aws&utm_campaign=website&utm_content=none&utm_term=none) and request a free trial tenant
- Login to the Dynatrace tenant and create a Dynatrace API token with the following scopes, after reviewing [docs](https://www.dynatrace.com/support/help/dynatrace-api/basics/dynatrace-api-authentication#create-token) on how to create it
    - Read SLO
    - Write SLO
    - Read Settings
    - Write Settings
    - Read Entities
    - Read Configuration
    - Write Configuration
    - Create ActiveGate Tokens
    - Ingest metrics
    - Access problem and event feed, metrics, and topology    - 
    - PaaS integration - Installer download
    - PaaS integration - Support alert
- In a separate notepad, please write down the following things needed in a future step below  
  1) Keep the API token safe somewhere to be used in future step below, it will be following format: **dt0c01.ABC12345DEFGHI**
  2) Dynatrace tenant url, it should be in format link this: **https://ABC.live.dynatrace.com**
- 
### Azure Portal Prep
 - Login to Azure Portal and click on the **Cloud Shell** button on the menu in upper right hand corner ![](images/portal-shell-button.png)
    - Note: If you get a prompt to to select Bash or Powershell, please select **Bash**
- Lookup your [Azure subscription ID](https://learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id) and save that off in the notepad where you have your dynatrace info
- Within your Azure Cloud Shell window, run a command to clone workshop scripts.
```bash    
    git clone https://github.com/dt-alliances-workshops/azure-modernization-dt-orders-setup.git
```
- Within Azure Cloud Shell window, change directory to  "azure-modernization-dt-orders-setup/provision-scripts" folder and run input-credentials.sh
    ```bash
    cd ~/azure-modernization-dt-orders-setup/provision-scripts
    ./input-credentials.sh
    ```
- Run the script to provision the workshop Azure resources
     ```bash
    cd ~/azure-modernization-dt-orders-setup/provision-scripts
    ./provision.sh wth
    ```
- Validate provisioning completed
    ```bash ...
    ...
    =============================================
    Provisioning workshop resources COMPLETE
    =============================================
    ```

- Download AKS Cluster credentials to manage it using kubectl via Azure CLI.
    - https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli#connect-to-the-cluster




## Success Criteria

To complete this challenge successfully, you should be able to:

- Once provisioning script has completed you will see a total of 12 resources within the resource group **lastname-dynatrace-azure-modernize-wth**.
- Validate the Sample Application DT Orders is accessible
    - Once the deployment has completed, navigate to the Public IP Address resource, dt-orders-monolithPublicIP , in the Azure Portal.
    - In the Overview blade, copy the IP address to your clipboard.
    - Open a web browser, paste your IP address in the address bar and press ENTER. Your browser should render the DT Orders site. ![](images/dtorders-sample-app.png)


## Learning Resources

- [Dynatrace API Token basics](https://www.dynatrace.com/support/help/dynatrace-api/basics/dynatrace-api-authentication)
- [Dynatrace natively available in the Azure portal ](https://www.dynatrace.com/news/blog/using-dynatrace-on-microsoft-azure/)
- [Dynatrace in the Azure Portal](https://www.dynatrace.com/support/help/get-started/saas/azure-native-integration)

- [Dynatrace Monaco](https://dynatrace.github.io/dynatrace-monitoring-as-code/)