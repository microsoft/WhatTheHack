# What the Hack Networking Bicep Deployment

This directory contains Bicep templates to deploy and configure resources as described in each WTH Networking challenge. These deployments represent one way to meet the challenge requirements--there are many others.

## Who should use these templates?

The WTH philosophy intends to have students learn by doing, and recognizes that one of the best ways to learn is to troubleshoot problems. As such, using these templates instead of building your own lab will detract from your learning experience, and primarily recommended for the scenarios below: 

- Students who will not be completing a challenge which is a prerequisite to a later challenge
- Students who are falling behind in the WTH due to issues unrelated to the core learning goals of this WTH
- Students looking for a reference implementation to compare against their own approach
- Coaches looking to deploy a reference architecture to the lab

## Using these templates

Using Cloud Shell is recommended, as it already has the necessary tools installed. However, Cloud Shell has a timeout of about 20 minutes and may experience timeouts (in which case, run the same command again to pick up the deployments where they stopped).

**Challenges are meant to be deployed sequentially, as the infrastructure builds on itself.** For example, to work with the Challenge 5 infrastructure, deploy Challenges 1-4 first. Also, keep in mind that changes made for testing need to be manually reverted, unless the relevant Challenge and subsequent Challenges are redeployed.  

### Prerequisites

- Azure PowerShell module
- git

### Download Options

#### Clone the Git repo (slow)

1. Clone this repo to your local system or Cloud Shell
   `git clone https://github.com/microsoft/WhatTheHack.git`
1. Navigate to the `035-HubAndSpoke\Student\Resources\bicep` directory in your clone of the repo
1. Run the deploy.ps1 script. For example:
   `./deploy.ps1 -challengeNumber 1`

#### Download a zip of the bicep directory

1. Browse to https://download-directory.github.io/?url=https%3A%2F%2Fgithub.com%2Fmicrosoft%2FWhatTheHack%2Ftree%2Fnetwork-bicep%2F035-HubAndSpoke%2FStudent%2FResources%2Fbicep
1. A zip of the directory will download to your system
1. Expand the downloaded zip file and navigate to it in a PowerShell window
1. Run the deploy.ps1 script. For example:
   `./deploy.ps1 -challengeNumber 1`

## Deployed Configuration

### Challenge 1

- Windows VMs are deployed in the hub, both spokes, and on-prem Resource Groups
- VM usernames are 'admin-wth' and passwords are the one supplied when executing the script
- Windows VM firewalls have been modified to allow Ping traffic
- All Windows VMs have associated Public IP Addresses and are accessible via RDP using alternate port 33899 (ex: `mstsc /v:4.32.1.5:33899`)
- The Cisco CSR deployed in the 'wth-rg-onprem' Resource Group uses the same username and password, but is not accessible from the internet. To access it, RDP to the Windows VM in the onprem Resource Group, then connect to the CSR using ssh and its private IP address

### Challenge 2

- With Azure Firewall deployed and traffic routing through it following the Challenge, the Windows VMs are no longer directly accessible via Public IP. Use the Azure Firewall public IP with the following DNAT port mapping:
  - Hub: 33980
  - Spoke 1: 33891
  - Spoke 2: 33892
  - On-prem (still accessible by Public IP and custom 33899 RDP port)

- All Windows VMs have a diagnostic website configured in IIS called Inspector Gadget. To access it locally, browse to `http://localhost/default.aspx`. Web server DNAT through the Azure Firewall uses the following port mapping:

  - Hub: 8080
  - Spoke 1: 8081
  - Spoke 2: 8082

### Challenge 3

- The routing tables are adjusted to match the Challenge documentation. To correct the inital deployment, run `deploy.ps1 -challengeNumber 3 -correctedConfiguration`

### Challenge 4

An Application Gateway is deployed matching the Challenge requirements. The deployment automates the configuration of a TLS certificate and DNS records when appropriate RFC 2136 credentials are supplied (the default configuration). The deployment options are:

1. Automated: Have automation handle DNS records and TLS certificates for you -- this requires registering for a DNS name, for example, from https://dynv6.com.
1. Manually configured: If you have an existing domain name and TLS certificates, you can manually upload the PFX certificate file to the Key Vault prior to deploying the App GW. 
1. Automated, with self-signed certificate: If there are issues generating the publicly trusted TLS certificate from Let's Encrypt, a self-signed certificate can be used. 

For details on these options and troubleshooting, see: [Application Gateway DNS and Certificates](./appGWCertificateProcess.md)

The application gateway is configured with backend pools for the Spoke 1 and Spoke 2 VMs.

### Challenge 5

The required Azure SQL and App Service resources are deployed, along with their supporting Private Link infrastructure. An Azure Private DNS Resolver is deployed to enable Private Endpoint name resolution for the 'on-prem' resources.

The 'Inspector Gadget' utility is installed on the Web App, which is publicly accessible. It includes functions to verify DNS name resolution and test SQL connectivity, though you may want to take the additional step of [granting your App Service MSI access to the SQL database](https://learn.microsoft.com/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-sql).

Resources deployed:

- Azure SQL Servers and DBs in Spoke 1 and Spoke 1
- Web App in Spoke 1
- Private DNS Resolver in Hub
- Private Endpoints for SQL servers and App Service
- Private DNS Zones for Private Endpoint records
- Subnets for new services (App Service, DNS Resolver, SQL Private Endpoints)
- NSGs for new subnets
- Route table and routes to force Spoke 1 SQL traffic through the Azure Firewall (advanced scenario)

## Resource Cleanup

To cleanup this deployment, delete each create resource group. To do this programmatically with PowerShell, run:

```powershell
    $jobs = @()
    $jobs += Remove-AzResourceGroup -Name 'wth-rg-hub' -Force -AsJob
    $jobs += Remove-AzResourceGroup -Name 'wth-rg-spoke1' -Force -AsJob
    $jobs += Remove-AzResourceGroup -Name 'wth-rg-spoke2' -Force -AsJob
    $jobs += Remove-AzResourceGroup -Name 'wth-rg-onprem' -Force -AsJob
    
    Write-Host "Waiting for all resource group cleanup jobs to complete..."
    $jobs | Wait-Job
    
    $jobs | Foreach-Object {
          $job = $_
          If ($job.Error) {
             Write-Error "A cleanup task experienced an error: $($job.error)"
          }
        }
    
    Write-Host "Cleanup task completed."
```
