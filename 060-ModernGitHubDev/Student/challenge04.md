# Modern development and DevOps with GitHub: Creating a deployment environment

[< Previous](challenge03.md) - [Home](../readme.md) - [Next >](challenge05.md)

## Scenario

With the application updated, the shelter is ready to begin configuring deployment! They have elected to use Azure to host the application. The website will be hosted on [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/overview), and the database on [Azure Cosmos DB for MongoDB](https://learn.microsoft.com/azure/cosmos-db/mongodb/introduction). The first step of the process will be creating and configuring the environment on Azure. In a later challenge you'll configure continuous deployment for the project.

## Challenge

For this challenge, you will create a [GitHub Action](https://docs.github.com/actions/learn-github-actions/understanding-github-actions) which uses an [Azure Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview?tabs=bicep) file to configure the necessary resources on Azure. You will create a resource group to house the Azure resources, configure a service identity to grant permissions to the Action, and run the Action to create the resources.

Configuration as Code (CaC), or config as code, is an approach to managing system configuration which involves defining configuration settings in machine-readable files or scripts. This allows for more efficient, automated, and consistent management of system configuration, as changes can be made and deployed more easily and with greater control. With config as code, configuration settings are stored in version-controlled files, often using a declarative syntax such as YAML, JSON, or HCL. These files can be stored alongside application code, making it easier to manage the entire software development life cycle.

This challenge uses [Azure Bicep](https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview?tabs=bicep), which is a domain specific language for defining Azure infrastructure. A [Bicep file](resources/main.bicep) has already been created for you to use, and is in the config folder of the repository. The Bicep file will:

- create a serverless instance of Azure Cosmos DB for MongoDB.
- create the resources to support an Azure Container App.
- create the Azure Container App with a default image.
- configure the Azure Container App with the connection string for the Azure Cosmos DB for MongoDB database.

The Bicep file accepts one parameter named `prefixName`, which is to be set to 6 random alphanumeric characters. This will ensure all resources created have a unique name.

## Success Criteria

- A prefix is created of 6 random alphanumeric characters to ensure uniqueness
- You created a new GitHub Action named **create-cloud.yml** with the following options:
  - Workflow can be run manually
  - Reads the prefix and other parameters from secrets
- Navigating to the URL for the Azure Container App displays a screen with the message **Welcome to Azure Container Apps**

> **IMPORTANT:** The default image configured in the Bicep file has the appropriate message configured. **No** code needs to be updated in the application. You will deploy the application in a later challenge.

## Tips

### Commands

- To login with the [Azure CLI](https://learn.microsoft.com/cli/azure/what-is-azure-cli) in your codespace, use `az login --use-device-code`
- To find your Azure subscription ID, use `az account show --query id -o tsv`
- To display the URL for the newly generated Azure Container App, use the command `az containerapp list --query "[].properties.configuration.ingress.fqdn" -o tsv`

### Configuration

- Use **westus** as the location for the resource group
- You will need to create the following secrets for the Action:
  - **AZURE_CREDENTIALS**
  - **AZURE_SUBSCRIPTION**
  - **AZURE_RG**
  - **AZURE_PREFIX**

## Learning resources

- [What is Infrastructure as Code?](https://docs.microsoft.com/azure/devops/learn/what-is-infrastructure-as-code)
- [Introduction to GitHub Actions](https://docs.github.com/actions/learn-github-actions/understanding-github-actions)
- [Deploy Bicep files by using GitHub Actions](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-github-actions?tabs=userlevel%2CCLI)
- [Manually running a workflow](https://docs.github.com/actions/managing-workflow-runs/manually-running-a-workflow)
- [GitHub Actions contexts](https://docs.github.com/en/actions/learn-github-actions/contexts)
- [GitHub Actions encrypted secrets](https://docs.github.com/actions/security-guides/encrypted-secrets)
- [Create Actions secrets using GitHub CLI](https://cli.github.com/manual/gh_secret_set)

[< Previous](challenge03.md) - [Home](../readme.md) - [Next >](challenge05.md)
