# Challenge 00 - Setup Azure & Tools - Coach's Guide

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Setup Guidance
This hackathon is authored so that it can be run a couple of different ways. 

   - Manual setup - The first would require students bring their own Azure Subscription and will complete the hackathon from a GitHub repository that they setup themselves and publish the code to themselves from files that the coach packages & provides `Resources.zip` file from contents of `/Student/Resources`
    
OR 
   
   - Automated setup - The other approach is an opinionated automated setup approach whereby the Coach uses scripts in `/Coach/Setup` folder to generate GitHub repos for each student with the sample application already committed to it.

## Automated Setup    
The opinionated automated setup will enable a coach to run the hackathon from a single Azure Subscription with each team having access to an Azure Resource Group where all their Azure resources during the hackathon will be deployed to.

This automated setup will then for each team and their resource group generate a service principal in AAD and a principal (user) in AAD that has the contributor role on the resource group so that during the hackathon the service principal can be used in GitHub Actions to deploy resources and the (user) principal can be used to login to the portal should teams want to have the portal UI to see the results of their deployments, look at logs etc.. inside of the Azure portal.

From a GitHub perspective the automation is also opinionated as it requires a GitHub organisation to be in place so that again for every team participating in the hackathon a GitHub repository and GitHub team can be created and all the files from the `/Student/Resources` can be committed and published to the repository as a start point for the hackathon.

Lastly the automation creates a WTH-Teams repository that all Teams in the hackathon have access to where credentials are shared with each team as issues. This is particularly useful for teams to see the JSON representing a service principal that has access to their Azure Resource Group created in this automation.

*** 
NOTE: It is advised when teams cut and paste out this service principal details they to this from the raw text rather than the markdown. This is because we have seen instances where credentials generated will have the '~' character within that means the rendered markdown misses vital characters when cut and pasted into GitHub Actions secrets
***

### Pre-resquisites for the automation scripts

Prerequisites for execution of the scripts are:
- Azure Subscription and AAD rights - You need to have access to the Azure Subscription that you will use on  and that you have rights to create principals within the AAD associated with this subscription.
NOTE: To create service principals you will need Owner or User access administrator role and requires permissions in the linked Azure Active Directory to register applications. It will be running the az ad sp create-for-rbac command as per [the docs](https://learn.microsoft.com/en-us/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create-for-rbac).

- GitHub organisation - A GitHub organisation. This can be a free, teams or GitHub Enterprise Organisation.

### Running the automation scripts

The `/Coach/Setup` folder contains the automation via two shell scripts for creation (`wth-setup.sh`) and teardown (`wth-teardown.sh`) for post hackathon removal of resources.

These shell scripts both require some variables to be edited inline in the files before execution. (note you may also need to run `chmod -x *.sh` so that the shell scripts can execute)

Variables to be set are:
- GROUP_COUNT - This is number of teams you want in your hackathon. Note: it may be better to overprovision here and just have some unused in the hackathon.

- SUBSCRIPTION_ID - This is the Azure Subscription ID that you will be using for the hackathon and will contain the resource groups for each of the teams in the hack. e.g. `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`

- ORGANISATION - This is the name of the GitHub organisation e.g. for https://github.com/wth-devops-london the value here should be `wth-devops-london`

- RESOURCE_DIR - This is the directory of the student resources files. If you run the scripts from the `Coach/Setup` directory this likely will need to be `../../Student/Resources`

- PASSWORD - This will be the password that students can use for their user principal to login to the Azure Portal.
