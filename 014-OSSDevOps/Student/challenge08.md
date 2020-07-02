# What the Hack: OSS DevOps 

## Challenge 08 - Infrastructure as Code: Deploying via Terraform
[Back](challenge07.md) // [Home](../readme.md) // [Next](challenge09.md)

### Introduction

Organizations of all sizes are adopting cloud-based services for application workloads. The development teams using these cloud-based services are able to operate with greater independence from the operational constraints of their underlying infrastructure. For most organizations, this means navigating a transition:

* from a relatively static pool of homogeneous infrastructure in dedicated data centers,
* to a distributed fleet of servers spanning one or more cloud providers.

To handle this shift, many organizations treat their cloud-based infrastructure as code—managing and provisioning it collaboratively. [Terraform](https://www.terraform.io/docs/index.html) uses infrastructure as code to provision any cloud infrastructure. Terraform provides a collaborative workflow for teams to safely and efficiently create and update infrastructure at scale.

### Challenge

In this challenge, the objective is to get familiar with Terraform's command line interface (CLI) and use its templating mechnism along with the [Azure provider](https://www.terraform.io/docs/providers/azurerm/index.html) to deploy the voting application that has been containerized and stored in Azure Container Registry (ACR).

The tasks for this challenge are:
1. Download and setup Terraform locally
2. Create a Terraform template file that will deploy the containerized voting application onto Azure Container Instance



### Success Criteria

The complete this challenge successfully:
*   Ensure Terraform CLI is installed locally
*   Create a Terraform  ```*.tf``` template file utilizing the Azure provider
* Deploy the containerized voting application to ACI via Terraform
   
[Back](challenge07.md) // [Home](../readme.md) // [Next](challenge09.md)