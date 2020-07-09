# What The Hack - Azure Arc for Servers Hack

## Introduction
	This hack will guide you through Arc for Servers technology. It will cover 


## Learning Objectives

This hack will help you learn:

1. Thing 1
2. Thing 2

## Challenges
 - [Challenge 0](./Student/challenge00.md) - Setup (Pre-day)
 - [Challenge 1](./Student/challenge01.md) - Deploy Arc Servers
 - [Challenge 2](./Student/challenge02.md) - Inventory Management
 - [Challenge 3](./Student/challenge03.md) - Operations
 - [Challenge 4](./Student/challenge04.md) - Policy
 - [Challenge 5](./Student/challenge05.md) - Arc Value Add: Security Center
 - [Challenge 6](./Student/challenge06.md) - Arc Value Add: Log Analytics Dashboard and Queries
 - [Challenge 7](./Student/challenge07.md) - Arc Value Add: Enable Sentinel 
 - [Challenge 8](./Student/challenge08.md) - Arc Value Add: Azure Lighthouse
 - [Challenge 9](./Student/challenge09.md) - Arc Value Add: Functionality Roadmap
 

## Prerequisites
- Your own Azure subscription with Owner access
- [Visual Studio Code](https://code.visualstudio.com)
- [Git SCM](https://git-scm.com/download)

## Repository Contents (Optional)
- `../Student`
  - Student Challenge Guides
- `../Student/Resources`
  - Student's resource files, code, and templates to aid with challenges

## Contributors
- Dale Kirby
- Lior Karmat
- Ali Hussain

# Random Notes

Learning Objectives

In this hack, you will be working on a set of "Day 2" operational best practices for Arc for K8s. You will learn:

## Pre-Day
  - Azure Arc Overview
  - Pre-day Requirements
  - Laptop admin access
  - GCP access to deploy GKE
  - An Azure Subscription which can deploy an AKS cluster
	- SSH Keys
	- Access to a Bash Shell (Cloud Shell, WSL, etc.)
	- With contributor Role
	- Docker on laptop

## Day 1
 - How to deploy Arc K8s in competitive clouds (90 mins)
	- K8s on GKE
	- minikube on laptop
		- If minikube not possible
			- Azure Kubernetes Service (automate if chosen)
			- Rancher on laptop 
	- Onboard ( 60 mins)
		- GKE to Arc for K8s 
		- Minikube (or alternative) to Arc for K8s
	- Inventory Management ( 60 mins)
		- Tagging Assets
		- Query with Resource Graph Explorer
		- Best practices around tagging
	- Operations (2 Hours)
		- Onboard Azure Monitor for Containers Log analytics – Easy Way (90 min)
		- Enable Alerts (CPU/Mem constraints) (30 mins)

	Total Day 1: 5.5 Hours
	
## Day 2 - Arc for K8s Scenarios

- GitOps ( 1.5 Hours )
	- Use GitOps in a connected Cluster
		- Technologies involved (Flux, etc)
	- Policy (3.5 Hours)
		- Enable Azure Policy add-on (30 mins)
			- Nuts and bolts of enabling Azure Policy
			- Technologies involved (OPA, Gatekeeper, Language)
		- Policies for Arc for K8s
			- Audit Policy ( Check if gatekeeper and OPA installed)
			- GitOps policy
			- Resource Limits Policy 
		- Build automation demo to apply policy across inventory 
			- (maybe Lior to investigate)

	Day 2: 5.5
	
# Different Hack or 3 Day hack

  - GitOps with Helm
  - Observability on Arc (Advanced Monitoring)
  - Real world example using Prometheus, Grafana (and/or) Azure Monitor
  - Deploy a full stack monitoring solution to Arc clusters
  - Fleet management
	- Deploy to a remote cluster - Get a new Cluster to a desired state with 1 configuration
	- Deploy to multiple clusters - Get 2 clusters to a desired state with 2 different configurations along with a base configuration
  - Bonus – Real world implementation
    - Deploy policy via ARM Template
    - To be investigated
  - Terraform Deployment
	
Assumptions
	Before starting this hack you should have hands-on experience with the following:
			
Prerequisites
	• Pre-day Requirements
		○ Laptop admin access
		○ GCP access to deploy GKE
		○ An Azure Subscription which can deploy an AKS cluster
			▪ SSH Keys
		○ Access to a Bash Shell (Cloud Shell, WSL, etc.)
			▪ With contributor Role
		○ Docker on laptop
		○ IDE of your choice, preferably VSCode
