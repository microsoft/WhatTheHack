# Challenge 00 - Prerequisites - Ready, Set, GO!

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Thank you for participating in the MongoDB to Azure DocumentDB migration What The Hack. Before you can start hacking, you will need to set up some prerequisites.

## Prerequisites

In this challenge, you will set up the necessary prerequisites and environment to complete the rest of the hack, including:

- [Azure Subscription](#azure-subscription)
- [GitHub Codespaces](#setup-github-codespace)
- [Local Workstation](#setup-local-workstation)

### Azure Subscription

You will need an Azure subscription to complete this hack. If you don't have one, get a free trial here...
- [Azure Subscription](https://azure.microsoft.com/en-us/free/)

#### Use GitHub Codespaces

You must have a GitHub account to use GitHub Codespaces. If you do not have a GitHub account, you can [Sign Up Here](https://github.com/signup).

GitHub Codespaces is available for developers in every organization. All personal GitHub.com accounts include a monthly quota of free usage each month. GitHub will provide users in the Free plan 120 core hours, or 60 hours of run time on a 2 core codespace, plus 15 GB of storage each month.

You can see your balance of available codespace hours on the [GitHub billing page](https://github.com/settings/billing/summary).

The GitHub Codespace for this hack will let you run the sample MFlix application which uses MongoDB as its database.

- A GitHub repo containing the student resources and Codespace for this hack is hosted here:
  - [MongoDB to Azure DocumentDB WTH Codespace Repo](https://aka.ms/wth/<TBD>/codespace)
  - Please open this link and sign in with your personal Github account. 

**NOTE:** Make sure you do not sign in with your enterprise managed Github account.

Once you are signed in:
- Verify that the `Dev container configuration` drop down is set to `xxx-mongodb-toazuredocumentdb-migration`
- Click on the green "Create Codespace" button.
  
Your Codespace environment should load in a new browser tab. It will take approximately 3-5 minutes the first time you create the codespace for it to load.

- When the codespace completes loading, you should find an instance of Visual Studio Code running in your browser with the files needed for this hackathon.

You are ready to setup the MongoDB source database. Skip to section: [Setup the Source MongoDB Database](#setup-the-source-mongodb-database)

**NOTE:** If you close your Codespace window, or need to return to it later, you can go to [GitHub Codespaces](https://github.com/codespaces) and you should find your existing Codespaces listed with a link to re-launch it.

#### Use Local Workstation

**NOTE:** You can skip this section if are using GitHub Codespaces!

If you want to setup this environment on your local workstation, expand the section below and follow the requirements listed. We have provided a Dev Container that will load the development environment on your local workstation if you do not want to use GitHub Codespaces.  

<details markdown=1>
<summary markdown="span"><strong>Click to expand/collapse Local Workstation Setup</strong></summary>

#### Download Student Resources

The Dev Container with the Mflix app is available in a Student Resources package.

- [Download `Resources.zip`](https://aka.ms/wth/<TBD>/resources) package to your local workstation. 

The rest of the challenges will refer to the relative paths inside the Codespace or `Resources.zip` file where you can find the various resources to complete the challenges.

#### Set Up Local Dev Container

You will next be setting up your local workstation so that it can use Dev Containers. A Dev Container is a Docker-based environment designed to provide a consistent and reproducible development setup. The VS Code Dev Containers extension lets you easily open projects inside a containerized environment. 

**NOTE:** On Windows, Dev Containers run in the Windows Subsystem for Linux (WSL). 

On Windows and Mac OS (**NOTE:** only tested on Apple Silicon):
- (Windows only) Install the Windows Subsystem for Linux along with a Linux distribution such as Ubuntu. You will need to copy the `Resources.zip` to your Linux home directory and unzip it there. 
- Download and install Docker Desktop
- Open the root folder of the Student Resources package in Visual Studio Code
- You should get prompted to re-open the folder in a Dev Container. You can do that by clicking the Yes button, but if you miss it or hit no, you can also use the Command Palette in VS Code and select `Dev Containers: Reopen in Container`

</details>
<br/>

#### Setup the Source MongoDB Database

You can choose to deploy a MongoDB instance in Docker container in Azure Container Instances with a deployment script or if you prefer, you can set up the source database in MongoDB Atlas instead manually. 

To deploy MongoDB in Azure Container Instances:

**NOTE:** If you are using GitHub Codespaces, the `az login` command will use a Device Code to login. If your organization's Azure policy prevents this, follow these steps first before you run the deployment:
- Open your [Codespace in Visual Studio Code Desktop](https://docs.github.com/en/codespaces/developing-in-a-codespace/using-github-codespaces-in-visual-studio-code)
- From the terminal in Visual Studio Code, run these commands to login:
```
CODESPACES=false
az login
```
- Perform the following steps to create an instance of MongoDB in your Azure subscription
    - Open a New Terminal window in VS Code
    - Type the following commands to deploy MongoDB in a container
    
    ```
    cd infra 

    ./deploy-source-db.sh --administratorLogin mflixadmin --administratorPassword <password>
    ```

    Optional: If you need to, you can specify the `resourceGroupName` and `location` as arguments to the `deploy-target-db.sh` script as follows. ***Note***: It defaults to `rg-mflix-documentdb` and `eastus2` for those, respectively:
    ```
    cd infra 

    ./deploy-source-db.sh --resourceGroupName <your_resource_group_name> --location westus --administratorLogin mflixadmin --administratorPassword <password>
    ```

If you want to deploy to MongoDB Atlas instead, go to this link: [Get Started With Atlas](https://www.mongodb.com/docs/atlas/getting-started/).
- You will need to also load the sample MFlix application into your Atlas cluster.
- You will need to modify the MFlix's `.env` file with your MongoDB connection string from Atlas. 

#### Run the MFlix Application

The sample MFlix application's is implemented as a Node.js application. You will be running this application either within your GitHub Codespace or Dev Container for simplicity. In practice, it would be deployed as a container into Azure. 

In a Terminal session in VSCode, navigate to the `MFlix` folder and run the application:

```
# Starts up the MFlix web application 
npm start
```

You should see a message in Visual Studio Code that your Application running on port 5001 is available. Click the `Open in Browser` button to open the MFlix application. Try it out!

***Note***: If you need the username and password you chose during the MongoDB deployment, they are stored in the `MFlix/.env` file in the `MFLIX_DB_URI` connection string. 

## Success Criteria

To complete this challenge successfully, you should:

- Verify that the MFlix sample application is running in your browser using your source MongoDB database.

## Learning Resources

- [MongoDB Atlas - Get Started](https://www.mongodb.com/docs/atlas/getting-started/)
- [MongoDB Connection String URI Format](https://www.mongodb.com/docs/manual/reference/connection-string/)
- [Azure DocumentDB for MongoDB](https://learn.microsoft.com/azure/cosmos-db/mongodb/)
- [Azure DocumentDB Migration with Azure Data Studio Extension](https://learn.microsoft.com/azure/cosmos-db/mongodb/migrate) 
