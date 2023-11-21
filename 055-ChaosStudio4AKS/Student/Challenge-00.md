# Challenge 00: Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Pre-requisites

You will need an Azure subscription with "Contributor" permissions.  

Before starting, you should decide how and where you will want to work on the challenges of this hackathon.

You can complete the entirety of this hack's challenges using the [Azure Cloud Shell](#work-from-azure-cloud-shell) in a web browser (fastest path), or you can choose to install the necessary tools on your [local workstation (Windows/WSL, Mac, or Linux)](#work-from-local-workstation).

We recommend installing the tools on your workstation. 

### Work from Azure Cloud Shell

Azure Cloud Shell (using Bash) provides a convenient shell environment with all tools you will need to run these challenges already included such as the Azure CLI, kubectl, helm, and MySQL client tools, and editors such as vim, nano, code, etc. 

This is the fastest path. To get started, simply open [Azure Cloud Shell](https://shell.azure.com) in a web browser, and you're all set!

### Work from Local Workstation

As an alternative to Azure Cloud Shell, this hackathon can also be run from a Bash shell on your computer. You can use the Windows Subsystem for Linux (WSL2), Linux Bash or Mac Terminal. While Linux and Mac include Bash and Terminal out of the box respectively, on Windows you will need to install the WSL: [Windows Subsystem for Linux Installation Guide for Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

If you choose to run it from your local workstation, you need to install the following tools into your Bash environment (on Windows, install these into the WSL environment, **NOT** the Windows command prompt!):

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
- Kubectl (using `az aks install-cli`)
- [Helm3](https://helm.sh/docs/intro/install/) 

Take into consideration how much time you will need to install these tools on your own computer. Depending on your Internet and computer's speed, this additional local setup will probably take around 30 minutes.

## Introduction

Once the pre-requisites are set up, now it's time to build the hack's environment.  

This hack is designed to help you learn chaos testing with Azure Chaos Studio, however you should have a basic knowledge of Kubernetes (K8s). The hack uses pre-canned Azure Kubernetes (AKS) environments that you will deploy into your Azure subscription. You many bring your own AKS application versus using the pre-canned AKS Pizza Application.

If you are using the Pizzeria Application, the Pizzeria Application will run in 2 Azure regions and entirely on an AKS cluster, consisting of the following:
 - 1 instance of the "Pizzeria" sample app (1 per region)
 - A MySQL database (1 per region)

## Description

The Pizzeria Application is deployed in two steps by scripts that invoke ARM Templates & Helm charts to create the AKS cluster, database, and the sample Pizzeria application.  Your coach will provide you with a link to the Pizzeria.zip file that contains deployment files needed to deploy the AKS environment into EastUS and WestUS. Since the end goal is to test a multi-region application, deploy the application into each region. For best results, perform all experiments in your nearest region.

   - Download the required Pizzeria.zip file (or you can use your own AKS application) for this hack. You should do this in Azure Cloud Shell or in a Mac/Linux/WSL environment which has the Azure CLI installed. 
   - Unzip the file 

### Deploy the AKS Environment

Run the following command to setup the AKS environments (you will do this for each region):

```bash
cd ~/REGION-NAME-AKS/ARM-Templates/KubernetesCluster
chmod +x ./create-cluster.sh
./create-cluster.sh

```

   **NOTE:** Creating the cluster will take around 10 minutes

   **NOTE:** The Kubernetes cluster will consist of one container contosoappmysql. 

### Deploy the Sample Application

Deploy the Pizzeria application as follows:

```bash
cd ~/REGION-NAME/HelmCharts/ContosoPizza
chmod +x ./*.sh
./deploy-pizza.sh

```

**NOTE:** Deploying the Pizzeria application will take around 5 minutes

### View the Sample Application

Once the applications are deployed, you will see a link to a websites running on port 8081. In Azure Cloud Shell, these are clickable links. Otherwise, you can cut and paste the URL in your web browser.
   
```bash
      Pizzeria app on MySQL is ready at http://some_ip_address:8081/pizzeria      
```

## Success Criteria

* You have a Unix/Linux Shell for setting up the Pizzeria application or your AKS application (e.g. Azure Cloud Shell, WSL2 bash, Mac zsh etc.)
* You have validated that the Pizzeria or your application is working in both regions (EastUS & WestUS)


## Tips

* The AKS "contosoappmysql" web front end has a public IP address that you can connect to. At this time you should create a Network Security Group on the Vnet, call is PizzaAppEastUS / PizzaAppWestUS and enable (allow) TCP port 8081 priority 200 and disable (deny) TCP port 3306 priority 210  --you will need this NSG for future challenges. 

```bash

 kubectl -n mysql get svc

```

There are more useful kubernetes commands in the reference section below.


## Learning Resources

* [Kubernetes cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)


