# What The Hack - Azure Arc enabled Kubernetes Hack

## Challenge 0 - Setup (Pre-day)
[Home](../readme.md) - [Next](challenge01.md)

### Introduction

The prerequisites for completing this hack are as follows:

* Access to a local computer with admin access to install or have access to tools such as VSCode, Terraform, Docker, and SSH Terminal 

* Access to a competetive cloud platform to standup and work with a managed Kubernetes service
   * Recommended: Access to Google Cloud Platform (GCP) to deploy Google Kubernetes Engine (GKE) cluster.
   * The hack can be performed using Amazon Web Services (AWS) platform by deploying an Elastic Kubernetes Service (EKS) cluster.

* Access to Azure subscription with appropriate rights to be able to deploy and manage Azure Arc enabled Kubernetes resources.

There are multiple ways to complete the challenges layed out on this hack. And as such there are many different tools that can be utilized to solve the challenges. However, having access to the prerequisites outlined above at the minimum will be sufficient to complete the hack.


### Challenge

In this challenge we will setup the core components needed to complete this What the Hack.
1. In a local environment insure the following tools are avaliable:
   * Install [VSCode](https://code.visualstudio.com/) suitable for your operating system
   * Install [Docker](https://www.docker.com/get-started) suitable for your operating system
   * Install and configure [Terraform](https://www.terraform.io/downloads.html)
   * Install and configure [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) command line tool
   * Install and configure [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) command line tool
   * Ensure you have a local terminal with appropriate access to be able to:
      * Create SSH Keys
      * SSH into remote VMs
2. Ensure you have access to [Google Cloud Platform (GCP)](https://cloud.google.com/) to be able to deploy GKE clusters.
   * If you are planning on using AWS, ensure you have the [portal](https://aws.amazon.com/) to be able to deploy EKS clusters.
3. Create an [Azure](https://azure.microsoft.com/) Subscription that you can use for this hack. If you already have a subscription you can use it or you can get a free trial [here](https://azure.microsoft.com/free/).

### Success Criteria

1. You should have access to a local environment with the following tools installed:
   * VSCode
   * Docker
   * Terraform
   * Kubectl
2. Ensure you have access to the GCP platform and Azure platform to be able to deploy GKE and Azure Arc enabled Kubernetes resources.
   
[Home](../readme.md) - [Next](challenge01.md)