# What The Hack - Azure Serverless

## Introduction

The Azure Serverless What The Hack will take you through architecting a serverless solution on Azure for the use case of a Tollbooth Application that needs to meet demand for event driven scale. This is a challenge-based hack. It's NOT step-by-step. Don't worry, you will do great whatever your level of experience! 

You will be guided through different tasks to implement the "Tollbooth" app by leveraging a serverless architecture within Azure using a combination of Azure Functions, Logic Apps, Event Grid, Cosmos DB, and Azure Storage. The focus is on removing server management from the equation, breaking down the solution into smaller components that are individually scalable, and allowing the customer to only pay for what they use.  

The intent is to have you practice the tools, technologies and services our partners are asking you about. Let's try to go out of your comfort zone, try and learn something new. And let's have fun!

And don't forget there are coaches around you, just raise your hand at any time!

## Learning Objectives

In this hack, you will be solving the business problem of event driven scale for the Tollbooth Application.

1. Provision an Azure Storage Blob Container to store vehicle photos.
2. Set up Azure Functions to process the vehicle photos leveraging Event Grid.
3. Use Cognitive Services Computer Vision API OCR to comprehend the license plate data from the vehicle photos.
4. Store the license plate data in Azure Cosmos DB.
5. Provision a Logic App for obtaining the stored license plate data from Cosmos DB and exporting it to a new CSV file saved to Blob storage.
6. Use Application Insights to monitor the Azure Functions in real-time as data is being processed through the serverless architecture.

## Solution Architecture

The solution begins with vehicle photos being uploaded to an Azure Storage blob storage container, as they are captured. A blob storage trigger fires on each image upload, executing the photo processing **Azure Function** endpoint (on the side of the diagram), which in turn sends the photo to the **Cognitive Services Computer Vision API OCR** service to extract the license plate data. 

If processing was successful and the license plate number was returned, the function submits a new Event Grid event, along with the data, to an Event Grid topic with an event type called &quot;savePlateData&quot;. However, if the processing was unsuccessful, the function submits an Event Grid event to the topic with an event type called &quot;queuePlateForManualCheckup&quot;. 

Two separate functions are configured to trigger when new events are added to the Event Grid topic, each filtering on a specific event type, both saving the relevant data to the appropriate **Azure Cosmos DB** collection for the outcome, using the Cosmos DB output binding. 

A **Logic App** that runs on a 15-minute interval executes an Azure Function via its HTTP trigger, which is responsible for obtaining new license plate data from Cosmos DB and exporting it to a new CSV file saved to Blob storage. If no new license plate records are found to export, the Logic App sends an email notification to the Customer Service department via their Office 365 subscription. 

**Application Insights** is used to monitor all of the Azure Functions in real-time as data is being processed through the serverless architecture. This real-time monitoring allows you to observe dynamic scaling first-hand and configure alerts when certain events take place.

Below is a diagram of the solution architecture you will build in this hack. Please study this carefully, so you understand the whole of the solution as you are working on the various components.

![The Solution diagram is described in the text following this diagram.](images/preferred-solution.png 'Solution diagram')


## Technologies

Azure services and related products leveraged to create this one possible solution architecture are:
*	Azure Functions
*	Azure Cognitive Services
*	Azure Event Grid
*	Application Insights
*	Azure Cosmos DB
*	Azure Key Vault
*	Logic Apps

## Azure Solution Architecture
This one possible Cloud Solution Architecture classifies under the **Application Modernization** category.

## Challenges

- Challenge 01: **[Setup](Student/Challenge-01.md)**
	 - Prepare your workstation to develop your Serverless Solution
- Challenge 02: **[Create a Hello World Function](Student/Challenge-02.md)**
	 - Create your first "Hello World" Azure Function in Visual Studio Code
- Challenge 03: **[Create Resources](Student/Challenge-03.md)**
	 - Provision the basic resources in Azure to prepare your deployment ground
- Challenge 04: **[Configuration](Student/Challenge-04.md)**
	 - Configure application settings on the Microsoft Azure Portal and update the TollBooth application code
- Challenge 05: **[Deployment](Student/Challenge-05.md)**
	 - Deploy the Tollbooth project to the "App" in the Azure Portal Function App and configure the Event Grid
- Challenge 06: **[Create Functions in the Portal](Student/Challenge-06.md)**
	 - Create the event triggered functions in the Azure Portal to respond to Event Grid Topics
- Challenge 07: **[Monitoring](Student/Challenge-07.md)**
	 - Configure application monitoring with Application Insights Resource on Azure Portal
- Challenge 08: **[Data Export Workflow](Student/Challenge-08.md)**
	 - Deploy a Logic App to periodically export the license plate data and conditionally send an email

## Optional Challenges
- Challenge 07A: **[Scale the Cognitive Service](Student/Challenge-07A.md)**
	 - Witness the dynamic scaling of the Function App demonstrating the true Serverless behaviour
- Challenge 07B: **[View Data in Cosmos DB](Student/Challenge-07B.md)**
	 - Use the Azure Cosmos DB Data Explorer in the portal to view saved license plate data

## Prerequisites

- Your laptop: Win, MacOS or Linux OR A development machine that you have **administrator rights**.
- Active Azure Subscription with **contributor level access or equivalent** to create or modify resources.
- [Node.js 8+](https://www.npmjs.com/): Install latest long-term support (LTS) runtime environment for local workstation development. A package manager is also required. Node.js installs NPM in the 8.x version. The Azure SDK generally requires a minimum version of Node.js of 8.x. Azure hosting services, such as Azure App service, provides runtimes with more recent versions of Node.js. If you target a minimum of 8.x for local and remove development, your code should run successfully.
- Visual Studio 2022 or Visual Studio Code
- Azure development workload for Visual Studio 2022
- Azure Functions and Web jobs tools
- .NET 6 SDK
- Any extentions required by your language of choice

*To setup Azure Functions on Visual studio Code, [follow this guide.](https://docs.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=csharp)*

## Contributors

- Ali Sanjabi
- Devanshi Joshi
- Nikki Conley
- Gwyneth Peña-Siguenza
