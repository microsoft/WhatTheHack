# Challenge 00 - Prerequisites - Ready, Set, GO

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the WanderAI: Your Travel Planning Startup What The Hack. Before you can hack, you will need to set up some prerequisites.

## Common Prerequisites

We have compiled a list of common tools and software that will come in handy to complete this hack!

- [Visual Studio Code](../../000-HowToHack/WTH-Common-Prerequisites.md#visual-studio-code)
- [GitHub Account](https://github.com/signup) - Required for GitHub Codespaces
- [Microsoft Foundry Account](https://foundry.microsoft.com/) - Required for Azure OpenAI access
- [Azure Native New Relic Service](https://learn.microsoft.com/en-us/azure/marketplace/new-relic-azure-monitoring/overview) - Required for New Relic Observability

## Description

In this challenge, you will set up the necessary prerequisites and environment to complete the rest of the hack.

You can use GitHub Codespaces where we have a pre-configured development environment set up and ready to go for you, or you can set up the developer tools on your local workstation.

**NOTE:** We highly recommend using GitHub Codespaces to make it easier to complete this hack.

### Use GitHub Codespaces

A GitHub Codespace is a development environment that is hosted in the cloud that you access via a browser. All of the prerequisite developer tools for this hack are pre-installed and available in the codespace.

GitHub Codespaces is available for developers in every organization. All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month. You can see your balance of available codespace hours on the [GitHub billing page](https://github.com/settings/billing/summary).

The GitHub Codespace for this hack will host the developer tools, sample application code, configuration files, and other data files needed for this hack.

- A GitHub repo containing the student resources and Codespace for this hack is hosted here:
  - [WTH WanderAI: Your Travel Planning Startup Codespace Repo](https://aka.ms/wth/openaiapps/codespace/)
  - Please open this link and sign in with your personal GitHub account.

**NOTE:** Make sure you do not sign in with your enterprise managed GitHub account.

- Verify that the `Dev container configuration` drop down is set to `xxx-AgentFrameworkObservabilityWithNewRelic`
- Click on the green "Create Codespace" button
- Your Codespace environment should load in a new browser tab. It will take approximately 3-5 minutes the first time you create the codespace for it to load.
- When the codespace completes loading, you should find an instance of Visual Studio Code running in your browser with the files needed for this hackathon.

**NOTE:** If you close your Codespace window, or need to return to it later, you can go to [GitHub Codespaces](https://github.com/codespaces) and you should find your existing Codespaces listed with a link to re-launch it.

**NOTE:** GitHub Codespaces time out after 20 minutes if you are not actively interacting with it in the browser. If your codespace times out, you can restart it and the developer environment and its files will return with its state intact within seconds. You can also update the default timeout value in your personal setting page on GitHub. Refer to this page for instructions: [Default Timeout Period](https://docs.github.com/en/codespaces/setting-your-user-preferences/setting-your-timeout-period-for-github-codespaces#setting-your-default-timeout-period)

**NOTE:** Codespaces expire after 30 days unless you extend the expiration date. When a Codespace expires, the state of all files in it will be lost.

### Use Local Workstation

**NOTE:** You can skip this section if you are using GitHub Codespaces!

If you want to set up your environment on your local workstation, expand the section below and follow the requirements listed.

<details markdown=1>
<summary markdown="span">Click to expand/collapse Local Workstation Requirements</summary>

#### Set Up Local Dev Container

You will next be setting up your local workstation so that it can use dev containers. A Dev Container is a Docker-based environment designed to provide a consistent and reproducible development setup. The VS Code Dev Containers extension lets you easily open projects inside a containerized environment.

**NOTE:** On Windows, Dev Containers run in the Windows Subsystem for Linux (WSL).

On Windows and macOS (**NOTE:** only tested on Apple Silicon):

- Download and install Docker Desktop
- (macOS only) In Docker Desktop settings, choose Apple Virtualization Framework for the Virtual Machine Manager. Also, click the checkbox to use Rosetta for x86_64/amd64 emulation on Apple Silicon
- (Windows only) Install the Windows Subsystem for Linux along with a Linux distribution such as Ubuntu
- Open the root folder of the Student resource package in Visual Studio Code
- You should get prompted to re-open the folder in a Dev Container. You can do that by clicking the Yes button, but if you miss it or hit no, you can also use the Command Palette in VS Code and select `Dev Containers: Reopen in Container`

</details>

### Gather Your Credentials

Before proceeding with the hack, you will need to gather the following credentials from your provided environment:

#### Microsoft Foundry Credentials

1. Navigate to your Microsoft Foundry environment (typically at [https://ai.azure.com/nextgen](https://ai.azure.com/nextgen))
2. Locate and copy your **Foundry Endpoint URL**
3. Locate and copy your **Foundry API Key**

Keep these credentials in a safe place as you will need them to configure your application in the upcoming challenges.

#### New Relic License Key

1. Access your New Relic account at [https://one.newrelic.com/](https://one.newrelic.com/)
2. Navigate to your account settings or API keys section at [https://one.newrelic.com/launcher/api-keys-ui.api-keys-launcher](https://one.newrelic.com/launcher/api-keys-ui.api-keys-launcher)
3. Locate and copy your **New Relic License Key** (also known as Ingest License Key)

This license key will be used to send telemetry data from your application to New Relic for observability and monitoring.

## Success Criteria

To complete this challenge successfully, you should be able to:

- [ ] Verify that you have a GitHub Codespace running with the dev container configuration set to `xxx-AgentFrameworkObservabilityWithNewRelic`
- [ ] Verify that Visual Studio Code is available in your browser (or locally) with the hack files loaded
- [ ] Verify that you have access to the sample application code and resource files
- [ ] Verify that you have collected your Microsoft Foundry endpoint and API key
- [ ] Verify that you have collected your New Relic license key

## Learning Resources

- [Microsoft Agent Framework](https://learn.microsoft.com/en-us/agent-framework/overview/agent-framework-overview)
- [Semantic Kernel](https://github.com/microsoft/semantic-kernel)
- [AutoGen](https://github.com/microsoft/autogen)
- [GitHub Models](https://docs.github.com/en/github-models)
- [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/)
- [OpenTelemetry](https://opentelemetry.io/)
- [OpenTelemetry & New Relic](https://docs.newrelic.com/docs/opentelemetry/opentelemetry-introduction/)
