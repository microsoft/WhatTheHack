# What The Hack: DevOps with GitHub 

## Challenge 6 – Continuous Delivery (CD)

[< Previous](challenge05.md) - [Home](../readme.md) - [Next >](challenge07.md)

### Introduction

In DevOps after we automate our build process, we want to automate our release process, we do this with a technique called Continuous Delivery (CD). Please take a moment to review this brief article talking about why this is important. 

- [What is Continuous Delivery?](https://docs.microsoft.com/en-us/azure/devops/learn/what-is-continuous-delivery)

### Challenge

In this challenge, we will use GitHub Actions to deploy our container image to the dev environment. 

OPTIONAL: Use your code editor (VS Code) to update your workflow file locally on your machine. Remember to commit and push any changes.

Extend the workflow you created in Challenge #4 to:

1. Configure your `dev` environment to pull the latest container image from ACR. 
   - Login to Azure using your service principal, if needed ([hint](https://docs.microsoft.com/en-us/azure/app-service/deploy-container-github-action?tabs=service-principal#tabpanel_CeZOj-G++Q-3_service-principal))
   - Use the `Azure/webapps-deploy@v2` [action](https://github.com/Azure/webapps-deploy) to update the Web App to pull the latest image from ACR. Key parameters to configure:
      - `app-name` - the name of the wep app instance to target
      - `images` - the path to the image you pushed to ACR

2. Make a small change to your application  (i.e.,`/Application/aspnet-core-dotnet-core/Views/Home/Index.cshtml`), commit, push, monitor the workflow and see if the change shows up on the dev instance of the website.

**NOTE**: Normally, we would have you configure [release gates](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/approvals/?view=azure-devops) next - which would require some type of manual approval/human intervention *before* deploying to test and prod respectively. But, as of 10/7/20, GitHub doesn't offer this natively - although it is on the [GitHub roadmap](https://github.com/github/roadmap/issues/99), due to be available by the end of 2020.

### Success Criteria

1. A small change to `/Application/aspnet-core-dotnet-core/Views/Home/Index.cshtml` automatically shows up on the website running in the dev environment (i.e., `<prefix>devops-dev`.azurewebsites.net).

### Learning Resources

- [Deploy a custom container to App Service using GitHub Actions](https://docs.microsoft.com/en-us/azure/app-service/deploy-container-github-action?tabs=service-principal#tabpanel_CeZOj-G++Q-3_service-principal)

[< Previous](challenge05.md) - [Home](../readme.md) - [Next >](challenge07.md)
