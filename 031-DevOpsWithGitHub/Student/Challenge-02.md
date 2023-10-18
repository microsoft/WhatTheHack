# Challenge 02 - Setup a Codespace

[< Previous Challenge](Challenge-01.md) - [Home](../README.md) - [Next Challenge >](Challenge-03.md)

## Introduction

Developer environments are critical to ensuring your development teams are setup to do their best work. Right now everyone on your team likely has a slightly different setup of their environment (editor, extensions, tools) installed on their local machine.

GitHub includes the ability to create a cloud based development environment called a codespace that is configured via a dev container (`devcontainer.json`) code file detailed within a repository. The file details how a developer environment should be supplied consistently from the cloud to every developer in the team who wants to create one in a self-serve manner. This can include the editor, extensions and tools we want to have available. 

Our repository includes an application written in .NET that will deploy to Azure using Infrastructure-as-Code via a language called Bicep. We will want to configure our codespace to have tooling included to work with .NET, ARM (infrastructure-as-code) and the Azure CLI.

## Description

- Add a new devcontainer file in your repository placed in a `.devcontainer` directory that defines your codespace. Ensure your devcontainer file is based on a docker image for .NET, notably "mcr.microsoft.com/devcontainers/dotnet:0-6.0" for the hackathon supplied application on .NET 6.0. 

  **HINT:** - VS Code Dev Containers Extension has a feature here that will simplify the process of creating a devcontainer file for many scenarios, or the below code snippet should be a good starter for our hackathon.

```
{
	"name": "C# (.NET)",
	"image": "mcr.microsoft.com/devcontainers/dotnet:0-6.0",
	"features": {
		"ghcr.io/devcontainers/features/azure-cli:1": {
			"installBicep": true,
			"version": "latest"
		}
	}
}
```

- Configure your devcontainer to add a feature for the Azure CLI. (the above code snippet includes this)

- Start a new codespace in your repository testing .NET and Azure CLIs are available.

## Success Criteria

- You will have created a `devcontainer.json` placed in a `.devcontainer` directory.
- You have created a codespace to provide a cloud based instance of the environment described in your devcontainer file. 
- Your codespace will have tooling available for both the .NET and Azure CLIs


## Learning Resources
- [Overview of Codespaces](https://docs.github.com/en/codespaces/overview)
- [Introduction to devcontainers](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers)
- [Setting up a C# (.NET) project in Codespaces](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/setting-up-your-dotnet-project-for-codespaces)
- [Adding features to your devcontainer](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/configuring-dev-containers/adding-features-to-a-devcontainer-file?tool=webui)
- [Visual Studio Code Dev Containers on VS Code Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
- [Visual Studio Code Dev Containers extension](https://code.visualstudio.com/docs/devcontainers/create-dev-container)


## Advanced Challenges (optional)
- Add to your `devcontainer.json` details of an extension to install into Visual Studio Code and your Codespace so that it is available by default for all your team. An example here may be GitHub Copilot (which you can enable a free trial to give AI suggestions throughout the hackathon) or the GitHub Actions extension from GitHub both are available alongside thousands of others in the [Visual Studio Code Marketplace](https://marketplace.visualstudio.com/vscode)
- Add a `postCreateCommand` to your `devcontainer.json` that will restore NuGet packages for the .NET app in the Application directory of the repo.  

[< Previous Challenge](Challenge-01.md) - [Home](../README.md) - [Next Challenge>](Challenge-03.md)
