# Modern development and DevOps with GitHub: Deploying the project

[< Previous](challenge04.md) - [Home](../readme.md)

## Scenario

The board of the shelter is rather pleased. You've updated the application with a new feature, configured security checks, and created an environment in Azure to host the project. The time has come to deploy the project!

Because the application will continue to grow with new features in the near future, the board wants to ensure the deployment process is streamlined. Whenever new code is pushed to `main` it should be deployed to production.

## Challenge

You will complete this hack by creating one last [GitHub Action](https://docs.github.com/actions/learn-github-actions/understanding-github-actions) to deploy the project to Azure. Deploying a project can be rather complex depending on the services being used and [service level agreement (SLA)](https://en.wikipedia.org/wiki/Service-level_agreement) which needs to be met. For example, you may need to configure [blue/green deployment](https://martinfowler.com/bliki/BlueGreenDeployment.html) to ensure no downtime when new features are published. You can talk about different scenarios with your coach.

For purposes of this hack, you will deploy to the [environment you created earlier](./challenge04.md) when code is pushed into `main`.

## Challenge tips

- Create the [secrets necessary for the Action including](https://docs.github.com/actions/security-guides/encrypted-secrets) to store the name of the Azure Container Registry:
  - **AZURE_CONTAINER_REGISTRY**
  - **AZURE_RG**
  - **AZURE_CONTAINER_APP**
  - **AZURE_CONTAINER_APP_ENVIRONMENT**
- The name of the Azure Container Registry will be **`<your_prefix>`acr**
- The name of the Azure Container App will be **`<your_prefix>`containerapp**
- The name of the Azure Container App Environment will be **`<your_prefix>`containerappenvironment**

## Success Criteria

- A GitHub Action is created which deploys the website to [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/overview) when code is pushed into `main`
- The PR you created earlier is pushed to `main`
- The public site displays the shelter's application, including the hours information from the [component you created earlier](./challenge01.md)

### Learning Resources

- [Understanding GitHub Actions](https://docs.github.com/actions/learn-github-actions/understanding-github-actions)
- [Triggering a workflow](https://docs.github.com/actions/using-workflows/triggering-a-workflow)
- [Publish revisions with GitHub Actions in Azure Container Apps](https://learn.microsoft.com/azure/container-apps/github-actions)
- [Azure Container Apps Build and Deploy - GitHub Actions](https://github.com/marketplace/actions/azure-container-apps-build-and-deploy)
- [GitHub Actions contexts](https://docs.github.com/en/actions/learn-github-actions/contexts)
- [GitHub Actions encrypted secrets](https://docs.github.com/actions/security-guides/encrypted-secrets)

[< Previous](challenge04.md) - [Home](../readme.md)
