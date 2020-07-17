# What The Hack - Azure Arc for Servers Hack

## Introduction
 [Azure Arc for Servers](https://docs.microsoft.com/en-us/azure/azure-arc/servers/overview) allows customers to use Azure management tools on any server running in any public cloud or on-premises environment. In this hack, you will be working on a set of progressive challenges to showcase the core features of Azure Arc. 
 
 In the first few challenges, you will set up your lab environment and deploy servers somewhere other than Azure. Then, you will use Azure Arc to project these servers into Azure, and begin to enable Azure management and security tools on these servers. On successive challenges, you will apply [Azure Policy](https://docs.microsoft.com/en-us/azure/governance/policy/overview) and enable other Azure services like [Azure Security Center](https://docs.microsoft.com/en-us/azure/security-center/) on your projected workloads.

## Learning Objectives

This hack will help you learn:

1. Azure Arc for Servers basic technical usage
2. How Azure Arc for Servers works with other Azure services
3. How Azure Arc for Servers enables Azure to act as a management plane for any workload in any public or hybrid cloud

## Challenges
 - [Challenge 0](./Student/challenge00.md) - Complete Prerequisites (Do before you attend the hack)
 - [Challenge 1](./Student/challenge01.md) - Deploy Arc Servers
 - [Challenge 2](./Student/challenge02.md) - Inventory Management
 - [Challenge 3](./Student/challenge03.md) - Operations
 - [Challenge 4](./Student/challenge04.md) - Policy
 - [Challenge 5](./Student/challenge05.md) - Arc Value Add: Security Center
 - [Challenge 6](./Student/challenge06.md) - Arc Value Add: Log Analytics Dashboard and Queries
 - [Challenge 7](./Student/challenge07.md) - Arc Value Add: Enable Sentinel *Coming Soon*
 - [Challenge 8](./Student/challenge08.md) - Arc Value Add: Azure Lighthouse *Coming Soon*
 - [Challenge 9](./Student/challenge09.md) - Arc Value Add: Functionality Roadmap *Coming Soon*
 

## Prerequisites
- Your own Azure subscription with Owner RBAC rights at the subscription level
- [Visual Studio Code](https://code.visualstudio.com)
- [Git SCM](https://git-scm.com/download)

## Repository Contents (Optional)
- `../Student`
  - Student Challenge Guides
- `../Student/Resources`
  - Student's resource files, code, and templates to aid with challenges

## Contributors
- Dale Kirby
- Lior Kamrat
- Ali Hussain

# Random Notes

Learning Objectives
* In this hack, you will be working on a set of "Day 2" operational best practices for Arc for Servers. You will learn:
  - Day 1
  		1. How to deploy Arc servers in competitive clouds (45 mins)
		   * Windows / Ubuntu on AWS
		   * Windows / Ubuntu on Vagrant
		2. Onboard servers to Arc (45 mins)
		3. Inventory Management (60 mins)
		   * Tagging Assets
			* Query with Resource Graph Explorer
			* Best practices around tagging
		4. Operations (2 Hours)
			* MMA extension onboarding (Windows)
			* Enable Alerts (CPU/Mem constraints)
			* Enable Update Management
	- Day 2
		1. Policy (2 Hours)
			* Define core set of policies for day 2
			* Build automation demo to apply policy across inventory
				1.  Install MMA agent via policy (Linux)
			* Bonus: Arc consumption drivers 
				1. Security Center ( 30 mins )
					- Onboarding security center - Manually (30 mins)
					- Advance challenge - Automate deployment (30 mins)
					- Note: log analytics workspace (Default)
				2. Log Analytics Dashboard and Queries (1 Hours)
					- Resource utilization scenario
					- Missing updates scenario (Time permitted)
				3. Enable Sentinel 
					- Ask to see if Sentinel part of 
				4. Azure Lighthouse (Optional) (Discussion + Demo = 45 mins)
					- MSP Perspective
					- Customer Perspective
			* Future Capabilities:
				1. Security Center functionality - Automation
				2. Sentinel 
				3. Policy 

Assumptions
	Before starting this hack you should have hands-on experience with the following:
			
Prerequisites
  * Pre-day
	* Checklist of items to do for Day 1 of hack
	* An Azure Subscription which can deploy an AKS cluster
	* Create SSH Keys
	* Access to a Bash Shell (Cloud Shell, WSL, etc.)
	* IDE of your choice, preferably VSCode