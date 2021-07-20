# Challenge 0: Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./01-assessment.md)

## Pre-requisites

You will need an Azure subscription with "Owner" permissions.  

Before starting, you should decide how and where you will want to work on the challenges of this hackathon.

You can complete the entirety of this hack's challenges using the [Azure Cloud Shell](#work-from-azure-cloud-shell) in a web browser (fastest path), or you can choose to install the necessary tools on your [local workstation (Windows/WSL, Mac, or Linux)](#work-from-local-workstation).

### Work from Azure Cloud Shell

Azure Cloud Shell (using Bash) provides a convenient shell environment with all of the tools you will need to run these challenges already included such as the Azure CLI, kubectl, helm, MySQL and PostgreSQL client tools, and editors such as vim, nano, code, etc. 

This is the fastest path. To get started, simply open [Azure Cloud Shell](https://shell.azure.com) in a web browser and you are good to go.

### Work from Local Workstation

As an alternative to Azure Cloud Shell, this hackathon can also be run from a Bash shell on your computer. You can use the Windows Subsystem for Linux (WSL2), Linux Bash or Mac Terminal. While Linux and Mac include Bash and Terminal out of the box respectively, on Windows you will need to install the WSL: [Windows Subsystem for Linux Installation Guide for Windows 10](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

If you choose to run it from your local workstation, you need to install the following tools into your Bash environment (on Windows, install these into the WSL environment, **NOT** the Windows command prompt!):

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/)
- Kubectl (using `az aks install-cli`)
- [Helm3](https://helm.sh/docs/intro/install/) 
- MySQL command line client tool (or optional GUI tool mentioned below)
- PostgreSQL command line client tool (or GUI optional tool mentioned below)

You should carefully consider how much time you will need to install these tools on your own computer. Depending on your Internet and computer's speed, this additional local setup will probably take around 30-60 minutes. You will also need a text editor of your choice if it is not already installed. 

### Optional Database Management GUI Tools

While it is possible to run the entire hacakathon using CLI tools only, it may be convenient for you to install some GUI tools on your own computer for accessing the MySQL/PostgreSQL databases for running database queries or changing data. If you feel less comfortable working from the command line, you may wish to do this. Some common database GUI tools are listed below. 

Some GUI tools which run on Windows/Mac include:

- [DBeaver](https://dbeaver.io/download/) - can connect to MySQL and PostgreSQL (and other databases)
- [pgAdmin](https://www.pgadmin.org/download/) - PostgreSQL only
- [MySQL Workbench](https://www.mysql.com/products/workbench/) - MySQL only
- [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) - PostgreSQL only (with PostgreSQL extension, besides SQL server)

## Introduction

Now that you have your pre-requisites set up, it is time to get the hack's environment set up.  

This hack is designed to help you learn how to migrate open source databases to Azure. But where will you migrate databases FROM? The hack has a pre-canned "on-premises" environment that you will deploy into your Azure subscription. This "on-prem" environment will act 
as the source from which you will migrate data to Azure.

The "on-premises" environment runs entirely in an AKS cluster in Azure. It consists of:
 - Two instances of the "Pizzeria" sample app (one for MySQL and one for PostgreSQL)
 - A MySQL database
 - A PostgesSQL database

## Description

The "on-premises" environment is deployed in two steps by scripts that invoke ARM Templates & Helm charts to create the AKS cluster, databases, and sample application.  Your coach will provide you with a Resources.zip file that contains the files needed to deploy the "on-premises" environment.

   - Download the required Resources.zip file for this hack. You should do this in Azure Cloud Shell or in an Mac/Linux/WSL environment which has the Azure CLI installed. 
   - Unzip the Resources.zip file

### Deploy "on-prem" AKS Environment

Run the following command to setup the on-prem AKS environment:

```bash
cd ~/Resources/ARM-Templates/KubernetesCluster
chmod +x ./create-cluster.sh
./create-cluster.sh

```

   **NOTE:** Creating the cluster will take around 10 minutes

   **NOTE:** The Kubernetes cluster will consist of two containers "mysql" and "postgresql". For each container it is possible to use either the database tools within the container itself or to connect remotely using a database client tool such as psql/mysql. 

### Deploy the Sample Applications

Deploy the Pizzeria applications - it will create two web applications - one using PostgreSQL and another using MySQL database.

```bash
cd ~/Resources/HelmCharts/ContosoPizza
chmod +x ./*.sh
./deploy-pizza.sh

```

**NOTE:** Deploying the Pizzeria application will take around 5 minutes

### View the Sample Application

Once the applications are deployed, you will see links to two web sites with different IP addresses running on ports 8081 and 8082, respectively. In Azure Cloud Shell, these are clickable links. Otherwise, you can cut and paste each URL in your web browser to ensure that it is running.
   
```bash
      Pizzeria app on MySQL is ready at http://some_ip_address:8081/pizzeria      
      Pizzeria app on PostgreSQL is ready at http://some_other_ip_address:8082/pizzeria
```

### Secure Access to "On-Prem" Databases

   - Run the [shell script](./Resources/HelmCharts/ContosoPizza/modify_nsg_for_postgres_mysql.sh) in the files given to you for this hack at this path: `HelmCharts/ContosoPizza/modify_nsg_for_postgres_mysql.sh` 
    
This script will block public access to the "on-premises" MySQL or PostgreSQL databases used by the Pizza app and allow access only from your computer or Azure Cloud Shell. The script is written to obtain your public IP address automatically depending on where you run it (either locally on your own computer or within Azure Cloud Shell).

**NOTE:** If you are running in Azure Cloud Shell, keep in mind that Azure Cloud Shell times out after 20 minutes of inactivity. If you start a new Azure Cloud Shell session, it will have a different public IP address and you will need to run the NSG script again to allow the new public IP address to access your databases. 

**NOTE:** If you are running this hack from Azure Cloud Shell AND you also want to connect to the Azure databases from your own computer using the GUI tools mentioned above like MySQL Workbench or pgAdmin, then you will need to edit the script file and change the line with "my_ip" to your computer's IP address. This will add your computer's IP address to the NSG rule as an allowed IP address (as well as allowing Azure Cloud Shell's public IP address).

**NOTE:** If your Shell IP address is already whitelisted and you run this script again, it does not make any changes.

## Success Criteria

* You have a Unix/Linux Shell for setting up the Pizzeria application (e.g. Azure Cloud Shell, WSL2 bash, Mac zsh etc.)
* You have validated that the Pizzeria applications (one for PostgreSQL and one for MySQL) are working
* [Optional] You have database management GUI tools for PostgreSQL and MySQL installed on your computer and are able to connect to the PostgreSQL and MySQL databases.
* Once connected to the database, explore the "wth" database used for the application by running SELECT statements on some tables to ensure data is present 


## Hints

* The on-prem MySQL and PostgreSQL databases have a public IP address that you can connect to. 
* In order to get those public IP addresses, run these commands and look for the "external-IP"s.

```bash

 kubectl -n mysql get svc
 kubectl -n postgresql get svc

```

There are more useful kubernetes commands in the reference section below.


## References

* [AKS cheatsheet](./K8s_cheetsheet.md)
* [pgAdmin](https://www.pgadmin.org) (optional)
* [MySQL Workbench](https://www.mysql.com/products/workbench/) (optional)
* [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver15) (optional)
* [Visual Studio Code](https://code.visualstudio.com/) (optional)

