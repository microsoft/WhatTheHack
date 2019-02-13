# Tournament Challenge - Deploy Your Bot!  

## Prerequisities

1. [Challenge 1 - Setup](./Setup.md) is required. You need the code repo cloned to your Azure Cloud Shell.

## Introduction

It's time for a Rock Paper Scissors Boom! Battle. These instructions will help you deploy the example bot. Once the bot is up and running, tell us the URL on Teams and we include it in the tournament.

The steps below will help you quickly create the Azure Resources you need to deploy the bot to Azure.

Note that you may have built some of these Azure resources already while going through the challenges. If you'd like you can re-use those existing Azure resources instead of using these scripts to create new ones.

## Steps

#### Step 1 - Create Azure Container Registry.

Run the following in Azure Cloud Shell. 

**Make Sure you are in the `WhatTheHack/005-RockPaperScissorsBoom/Student/Resources/Code/` directory.**

Replace &lt;Your Alias&gt; with your name or work alias. Keep this instance of Azure Cloud Shell open - you will need it for the next steps.

```
ALIAS=<Your Alias>
LOC=eastus
RG=bot
PLAN=plan
PLANNAME=$ALIAS$PLAN
APP=gamebot
APPNAME=$ALIAS$APP
ACR=acr
ACRNAME=$ALIAS$ACR

az group create -n $RG -l $LOC
az acr create -n $ACRNAME -g $RG --sku Basic --admin-enabled true -l $LOC
az acr credential show -n $ACRNAME -g $RG -o json
```

What is happening here?
* You created a new Resource Group called "bot"
* You created a new Azure Container Registry.

Note for use in the following steps:
* The ACR Login URL
* The ACR Username and password

#### Step 2 - Build the ExampleBot into a Docker Image.

Run the following in the Azure Cloud Shell.

```
az acr build -r $ACRNAME -f Dockerfile-ExampleBot -t examplebot:1 .
```
What is happening here?
* You are using the Azure Container Registry **Build** feature to build your image (rather than requiring your own Docker Host to build images). It is using the `Dockerfile-ExampleBot` file for instructions on how to build the examplebot image. It is tagging the image as `examplebot:1`.

#### Step 3 - Deploy Bot to the Web App

Run the following in the same instance of Azure Cloud Shell.

Replace &lt;ACR LOGIN URL&gt;, &lt;ACR User Name&gt;, &lt;ACR password&gt; with the correct values gathered in step 1.

```
az appservice plan create -n $PLANNAME -g $RG --is-linux -l $LOC
az webapp create -n $APPNAME --p $PLANNAME -g $RG --deployment-container-image-name <ACR LOGIN URL>/examplebot:1
az webapp config container set -n $APPNAME -i <ACR LOGIN URL>/examplebot:1  -r <ACR LOGIN URL> -g $RG --docker-registry-server-user <ACR User Name> --docker-registry-server-password <ACR password>
az webapp show -n $APPNAME-g $RG
```
What is happening here?
* You are building a Linux app service plan.
* You built a Linux web app and deployed an examplebot container to it from your Azure Container Registry.

It may take a few minutes after these commands run to see your bot live. Navigate to your webapp URL. If you see the word `Decision` wrapped in some json brackets. It worked!

#### Step 4 - Report your Bot's URL

Just tell us your bot's URL (in the Teams channel will work) and we'll include it in the Tournament. Good luck! 

## Advanced

1. The bot you deployed is the standard example bot which is just an instance of the Clever bot. You can edit the Clever bot's code and try to make it even more clever. This might be a fun exercise to do later. 
