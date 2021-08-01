# What The Hack - Conversational AI Attach Play

## Introduction
The Conversational AI Attach Play WhatTheHack will take you through architecting a Chatbot with an FSI industry focus that is more intelligent that an out of the box chatbot. This is a challenge-based hack. It's NOT step-by-step. Don't worry, you will do great whatever your level of experience! You will be guided through different tasks to implement the FSI ChatBot by leveraging a serverless architecture within Azure using a combination of Azure Bot Composer, QnA Maker, LUIS, Azure Databricks, and Azure Communication Services. The focus is on building on top of what you know from Azure Bot Services and attaching further services to enable a truly Enterprise scale bot.  The intent is to have you practice the tools, technologies and services our partners are asking you about. Let's try to go out of your comfort zone, try and learn something new. And let's have fun! And don't forget there are proctors around you, just raise your hand at any time! 


## Learning Objectives

This Conversational AI Attach Play hack will help you to learn:
1. How to use QNA maker to create multi-turn knowledge base
1. How to use Bot Framework Composer to build a code free Bot
1. Understand the Azure AI services within Bot Solution (LUIS, Direct Line Speech)
1. Publish your Bot into Azure and Embedded into our sample web Application 
1. Integrate your Bot into Microsoft Teams which enables human interactions Teams Channel
1. Integrate your Bot with Azure Communication Services which enables human interactions via phone, videos, and SMS
1. Implement DevOps best practices
1. Extend the bot with Azure Data Services to enable advanced ML and big data capabilities. (Optional)

## Solution Architecture

The solution starts with a user likely a Finance Manager who is looking at companies to invest in. The user cares about the ESG ratings and stock prices of potential companies. The user sends a request to the Azure Web App front end that then uses Azure Functions to generate direct line and direct line speech tokens for the Bot Service.  Bot Service is then called and the user is authenticated using Azure AD to ensure that they have the access necessary to communicate with the bot. Once the tokens have been passed Bot Service makes queries to the Bot Logic. In this hack, we are setting up all of the bot logic and conversations using Azure Bot Composer. Depending on the query the bot will call one or more of the following: Speech Services (in the case that the query comes in the form of Speech from the Speech Enabled Web App), LUIS (which is always called to detect the intent and entities from the request), QnA Maker (in our case if the user is asking an ESG related question about the company), Text Analytics (to run sentiment analysis), or make an HTTP request to an outside API (here we are using Finnhub.io to get real-time stock price of the company in question). The results of the bot cognition determine how the bot will proceed in the conversation, but all of the conversations and uses are stored using Application Insights, Cosmos DB, and Azure Storage. This way IT can see how the bot is being used and build further extensions as necessary. We are also using Azure DevOps to handle the CI/CD pipeline of the bot, which is necessary for the further improvement and development of the solution. 

Although in the above example we exemplify the user making a request through the web front end the user can also access the bot through Azure Communication Services or Microsoft Teams. With these improvements, the user can now interact using phone calls, texts, or on their computer with Teams if that is the environment they are used to working with. 

Below is a diagram of the solution architecture you will build in this hack. Please study this carefully, so you understand the whole of the solution as you are working on the various components.

![Solution Architecture](https://github.com/Microsoft-US-OCP-Conversational-AI/Conversational-AI-Attach-Play/blob/master/Coach/SolutionArchitecture.PNG?raw=true)

## Challenges
 - [Challenge 0](./Student/Challenge0-Setup.md) - Setup and Introduction
 - [Challenge 1](./Student/Challenge1-QnA.md) - Create Multi-Turn QNA Knowledge Base
 - [Challenge 2](./Student/Challenge2-LUIS.md) - Create LUIS Intents to direct conversations
 - [Challenge 3](./Student/Challenge3-API.md) - Make API Calls from your Bot  
 - [Challenge 4](./Student/Challenge4-Deployment.md) - Publish your Bot to Azure and enable Teams Channel
 - [Challenge 5](./Student/Challenge5-FrontEnd.md) - Embed your Bot to the sample Front End Web Application and enable Direct Line Speech 
 - [Challenge 6](./Student/Challenge6-ACS.md) - Integrate your Bot with Azure Communication Services 
 - [Challenge 7](./Student/Challenge7-CICD.md) - Implement DevOps best practices into your Bot 
 - [Challenge 8](./Student/Challenge8-Data.md) - Add Advanced intelligence to your Bot using Azure Data Services

## Prerequisites
- Your own Azure subscription with **owner** access. See considerations below for additional guidance.
- [Visual Studio Code](https://code.visualstudio.com)
- [Git SCM](https://git-scm.com/download)

## Contributors
- Annie Xu
- Anthony Franklin
- Ariel Luna
- Claire Rehfuss
- Praveen Rawat
- Sowmyan Soman Chullikkattil
- Wayne Smith
