### <img src="../../../documentation/assets/UnicornSAPBlack256x256.png" width="64px"> SAP Automation > V2 <!-- omit in toc -->
# Automated SAP Deployments in Azure Cloud <!-- omit in toc -->

Master Branch's status: [![Build Status](https://dev.azure.com/azuresaphana/Azure-SAP-HANA/_apis/build/status/Azure.sap-hana.v2?branchName=master)](https://dev.azure.com/azuresaphana/Azure-SAP-HANA/_build/latest?definitionId=6&branchName=master)

<br>

## Table of contents <!-- omit in toc -->

- [Supported Scenarios](#supported-scenarios)
  - [Available](#available)
  - [Coming Soon](#coming-soon)
- [Usage](#usage)
- [What will be deployed](#what-will-be-deployed)

<br>

## Supported Scenarios

### Available

- [HANA Scale-Up Stand Alone](/deploy/v2/template_samples/single_node_hana.json)

### Coming Soon

- HANA Scale-Up High Availability

<br>

## Usage

A typical deployment lifecycle will require the following steps:
1. [**Initialize the Deployment Workspace**](/documentation/terraform/deployment-environment.md)
2. [**Adjusting the templates**](/documentation/json-adjusting-template.md#adjusting-the-templates)
3. [**Running Terraform deployment**](/documentation/terraform/running-terraform-deployment.md)
4. [**Running Ansible Playbook**](/documentation/ansible/running-ansible-playbook.md)
5. [**Deleting the deployment**](/documentation/terraform/deleting-the-deployment.md) (optional)

   *(**Note**: There are some script under [sap-hana/util](https://github.com/Azure/sap-hana/tree/master/util) would help if you are using Linux based workstation)*

<br><br><br><br>

---

## What will be deployed

TODO 20200423 - Update Table

| <sub>NAME   (Examples)</sub>         | <sub>TYPE</sub>                   | <sub>Explain</sub>                                                                                                                                     |
|--------------------------------------|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| <sub>hdb01</sub>                     | <sub>Virtual machine</sub>        | <sub>HANA database server(s)</sub>                                                                                                                     |
| <sub>hdb01-admin-nic</sub>           | <sub>Network interface</sub>      | <sub>Nic to admin IP</sub>                                                                                                                             |
| <sub>hdb01-backup-0</sub>            | <sub>Disk</sub>                   | <sub>Disks attach to HANA database server(s) (e.g. os, sap, data,   log, shared, backup)</sub>                                                         |
| <sub>hdb01-db-nic</sub>              | <sub>Network interface</sub>      | <sub>Nic to database</sub>                                                                                                                             |
| <sub>jumpbox-linux</sub>             | <sub>Virtual machine</sub>        | <sub>Linux jumpboxe(s) [1..n]. At least one linux jumpbox is   required to execute ansible-playbook, which has destroy_after_deployed to   true.</sub> |
| <sub>jumpbox-linux-nic1</sub>        | <sub>Network interface</sub>      | <sub>Nic for linux jumpboxe(s)</sub>                                                                                                                   |
| <sub>jumpbox-linux-osdisk</sub>      | <sub>Disk</sub>                   | <sub>Disks for linux jumpboxe(s)</sub>                                                                                                                 |
| <sub>jumpbox-linux-public-ip</sub>   | <sub>Public IP address</sub>      | <sub>Public IP for linux jumpboxe(s)</sub>                                                                                                             |
| <sub>jumpbox-windows</sub>           | <sub>Virtual machine</sub>        | <sub>Windows jumpboxe(s) [0..n]</sub>                                                                                                                  |
| <sub>jumpbox-windows-nic1</sub>      | <sub>Network interface</sub>      | <sub>Nic for Windows jumpboxe(s)</sub>                                                                                                                 |
| <sub>jumpbox-windows-osdisk</sub>    | <sub>Disk</sub>                   | <sub>Disks for Windows jumpboxe(s)</sub>                                                                                                               |
| <sub>jumpbox-windows-public-ip</sub> | <sub>Public IP address</sub>      | <sub>Public IP for Windows jumpboxe(s)</sub>                                                                                                           |
| <sub>nsg-admin</sub>                 | <sub>Network security group</sub> | <sub>NSG for admin vnet</sub>                                                                                                                          |
| <sub>nsg-db</sub>                    | <sub>Network security group</sub> | <sub>NSG for db vnet</sub>                                                                                                                             |
| <sub>nsg-mgmt</sub>                  | <sub>Network security group</sub> | <sub>NSG for management vnet</sub>                                                                                                                     |
| <sub>sabootdiag5f49a971</sub>        | <sub>Storage account</sub>        | <sub>Storage account for all VMs</sub>                                                                                                                 |
| <sub>sapbits5f49a971</sub>           | <sub>Storage account</sub>        | <sub>Storage account for download SAP media</sub>                                                                                                      |
| <sub>vnet-mgmt</sub>                 | <sub>Virtual network</sub>        | <sub>Vnet for management (jumpboxes)</sub>                                                                                                             |
| <sub>vnet-sap</sub>                  | <sub>Virtual network</sub>        | <sub>Vnet for sap (HANA database servers)</sub>                                                                                                        |
                                        

