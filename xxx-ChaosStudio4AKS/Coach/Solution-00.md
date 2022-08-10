# Challenge 00 - <Title of Challenge> - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

The student will need an Azure subscription with "Contributor" permissions.  
The entirety of this hack's challenges using the [Azure Cloud Shell](#work-from-azure-cloud-shell) in a web browser (fastest path), or you can choose to install the necessary tools on your [local workstation (Windows/WSL, Mac, or Linux)](#work-from-local-workstation).
 
We recommend installing the tools on your workstation. 
  
The AKS "contossoappmysql" web front end has a public IP address that you can connect to. At this time you should create a Network Security Group on the Vnet, call is PizzaAppEastUS / PizzaAppWestUS and enable (allow) TCP port 8081 priority 200 and disable (deny) TCP port 3306 priority 210  --you will need this NSG for future challenges. 

```bash

 kubectl -n mysql get svc

```
