### <img src="../../documentation/assets/UnicornSAPBlack256x256.png" width="64px"> SAP Automation > V2 <!-- omit in toc -->
# Automated SAP Deployments in Azure Cloud <!-- omit in toc -->
Master Branch's status: [![Build Status](https://dev.azure.com/azuresaphana/Azure-SAP-HANA/_apis/build/status/Azure.sap-hana.v2?branchName=master)](https://dev.azure.com/azuresaphana/Azure-SAP-HANA/_build/latest?definitionId=6&branchName=master)

This repository contains code that can be used to automatically deploy SAP landscapes in the Azure Cloud.

The templates are split into:
- **Terraform modules**
which deploy the infrastructure components (such as VMs, network, storage) in Azure.
- **Ansible playbooks**
which run different roles to configure and VMs and install SAP HANA and required applications on the already deployed infrastructure.

<br>

## Table of contents <!-- omit in toc -->

- [Usage](#usage)
- [Terraform Deployment Units](#terraform-deployment-units)
- [Contributions](#contributions)
- [License & Copyright](#license--copyright)
- [Contact](#contact)

<br>

## Usage

A typical deployment lifecycle will require the following steps:

Step 1) [**Preparing your environment**](/documentation/getting-started.md#preparing-your-environment) (this has to be done only once)

Step 2) [**Select Terraform Deployment Unit**](#terraform-deployment-units)

   *(**Note**: There are some script under [sap-hana/util](https://github.com/Azure/sap-hana/tree/master/util) would help if you are using Linux based workstation)*

<br>

## Terraform Deployment Units

- [HANA single-node instance](terraform/HANA.md) (Primary Entry Point)
- [SAP Library](terraform-units/workspace/SAP_Library/Readme.md)
- Deployment Portal (Coming Soon)
- Logical SAP Network Foundation (Coming Soon)
- SDU - SAP Deployment Unit (Coming Soon)


<br><br><br><br>  

---

## Contributions

If you want to contribute to our project, be sure to review the [contributing guidelines](/CONTRIBUTING.md).

We use [GitHub issues](https://github.com/Azure/sap-hana/issues/) for feature requests and bugs.

<br>

## License & Copyright

Copyright © 2018-2020 Microsoft Azure.

Licensed under the [MIT License](LICENSE).

<br>

## Contact

We look forward to your feedback and welcome any contributions!

Please feel free to reach out to our team at ![image](/documentation/assets/contact.png).
