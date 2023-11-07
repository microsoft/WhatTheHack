# What The Hack - Intro to Artificial Intelligence (ARCHIVED)

**NOTE: This hack has been marked as "archived" since one of the data sources used by students is no longer available.**

**NOTE:** Please see our NEW hack on [Azure OpenAI Fundamentals](../066-OpenAIFundamentals/README.md) which should replace this hack.

If you would like to update this hack so we can "un-archive" it, please submit a proposal to the What The Hack team as per our [WTH Contribution Guide](https://aka.ms/wthcontribute). We welcome contributions and can provide you more details on what would be needed to update it.

## Introduction
AI-oriented services such as Azure Bot Services, Azure Search, and Cognitive Services
Welcome to the What The Hack Intro to AI Challenge! We will focus on hands-on activities that develop proficiency in AI-oriented services such as Azure Bot Services, Azure Search, and Cognitive Services. These challenges assume an introductory to intermediate knowledge of these services, and if this is not the case, please spend time working through related resources.

## Learning Objectives
Most challenges observed by customers in these realms are in stitching multiple services together. As such, we have tried to place key concepts in the context of a broader example.

Once all hackathon challenges are completed, you should be able to:
- Configure your apps to call Cognitive Services
- Build an application that calls various Cognitive Services APIs (specifically Computer Vision) 
- Effectively leverage the custom vision service to create image classification services that can then be leveraged by an application
- Implement Azure Search features to provide a positive search experience inside applications
- Configure an Azure Search service to extend your data to enable full-text, language-aware search
- Build, train, and publish a LUIS model to help your bot communicate effectively
- Build an intelligent bot using Microsoft Bot Framework that leverages LUIS and Azure Search
- Effectively log chat conversations in your bot
- Perform rapid development/testing with Ngrok and test your bots with unit tests and direct bot communication

## Background Knowledge
This workshop is meant for an AI Developer on Azure. Since our time today is limited, there are certain things you will need to read or setup after you arrive. If you do not have this background knowledge, please work closely with your team to learn from others or use the links below.
- Visual Studio
    - Previous exposure to Visual Studio will be helpful. Your team will be using it for everything we are building today, so you should be familiar with how to use it to create applications. We assume each team will have some familiarity with C# (intermediate level - you can learn here), but you do not know how to implement solutions with Cognitive Services.
- Bot Framework
    - You should have some experience developing bots with [Microsoft's Bot Framework](https://dev.botframework.com). We won't spend a lot of time discussing how to design them or how dialogs work.
- Azure Portal
    - You should have experience with the [Azure Portal](https://portal.azure.com) and understand how to create resource groups and configure individual services. 

## Challenges
Your team’s mission today is to learn more about AI capabilities through hands-on practice by completing challenges in two key areas: Cognitive Services and Bots.

Your team will start by building a simple C# application that allows you to ingest pictures from your local drive, then invoke the Computer Vision API to analyze the images and obtain tags and a description. Once you have this data, you will process it to pull out the details we need, and store it all into Cosmos DB.

You'll continue by build an Azure Search Index (Azure Search is our PaaS offering for faceted, fault-tolerant search) on top of Cosmos DB, then you’ll build a Bot Framework bot to query it. Finally, you'll extend this bot with Language Understanding (LUIS) to automatically derive intent from your queries and use those to direct your searches intelligently. 

### Part 1: Cognitive Services
This set of challenges involves building an end-to-end application that allows you to pull in your own pictures, use Cognitive Services to obtain a caption and some tags about the images, and then store that information in Cosmos DB. Build on your work by using the NoSQL store (Cosmos DB) to populate an Azure Search index, and then build a Bot Framework bot using LUIS to allow easy, targeted querying.

- Challenge 1: **[Simplifying Cognitive Services App Development using Portable Class Libraries](Student/Guides/StudentGuide.docx)**
- Challenge 2: **[Custom Vision API C\# Tutorial 1](Student/Guides/StudentGuide.docx)**
- Challenge 3: **[Custom Vision API C\# Tutorial 2](Student/Guides/StudentGuide.docx)**
- Challenge 4: **[Custom Vision API C\# Tutorial 3](Student/Guides/StudentGuide.docx)**
- Challenge 5: **[Developing Intelligent Applications with LUIS](Student/Guides/StudentGuide.docx)**
- Challenge 6: **[Contoso Automated Orders](Student/Guides/StudentGuide.docx)**


### Part 2: Bots
You are working with Contoso LLC, which sells bicycles and bicycle equipment to its customers. Contoso currently processes new product orders and queries through human operators and is starting to devise a plan to implement your proposed solution using bots. The solution will provide an automated approach that allows Contoso to seamlessly scale up to handle a large call volume while maintaining zero wait times and freeing up staff to manage other tasks.  

- Challenge 1: **[Developing Intelligent Applications with Azure Search](Student/Guides/StudentGuide.docx)**
- Challenge 2: **[Developing Intelligent Applications with LUIS and Azure Search](Student/Guides/StudentGuide.docx)**
- Challenge 3: **[Logging with Microsoft Bot Framework](Student/Guides/StudentGuide.docx)**
- Challenge 4: **[Testing Bots with Microsoft Bot Framework](Student/Guides/StudentGuide.docx)**
- Challenge 5: **[Contoso Bot and Search Integration](Student/Guides/StudentGuide.docx)**

## Prerequisites
This is a list of pre-requisites needed to successfully complete the challenges.  Some of these are items to deploy to your development machine.  Some are decisions you should discuss and define as a team, like the language to use for development.

1. Azure Account
    - You must have an Azure account to complete the hackathon. Either use your existing subscription or setup a free trial to complete today’s challenges. We will not be providing Azure passes for this workshop.

1. Custom Vision Training Key
    - The training API key allows you to create, manage and train Custom Vision project programmatically.  You can obtain a key by creating a new project at <https://customvision.ai> and then clicking on the “setting” gear in the top right.

## Repository Contents
- `../Coach/Guides`
  - Coach's Guide and Kick Off presentation
- `../Coach/Demos`
  - Demos for ML, Text & Speech and Vision
- `../Coach/Solutions`
  - Solution code for each challenge
- `../Student/Guides`
  - Student's Guide
- `../Student/Resources`
  - Code and other resources needed for each challenge

## Contributors
- Laura Edell
- Diana Phillips

## Resources & Helpful Links
- Intelligent Kiosk Sample Application
    - <https://github.com/Microsoft/Cognitive-Samples-IntelligentKiosk/tree/master/Kiosk/ServiceHelpers>
    - Utilizing these resources makes it easy to add and remove the service helpers in your future projects as needed.
- Cognitive Services
    - <https://www.microsoft.com/cognitive-services>
- Cosmos DB
    - <https://docs.microsoft.com/en-us/azure/cosmos-db>
- Azure Search
    - <https://azure.microsoft.com/en-us/services/search>
- Bot Developer Portal
    - <http://dev.botframework.com>
- Natural Language Understanding (LUIS)
    - <https://azure.microsoft.com/en-us/services/cognitive-services/language-understanding-intelligent-service>
- Understanding LUIS
    - <https://docs.microsoft.com/en-us/azure/cognitive-services/LUIS/Home>
- Bot Framework Emulator
    - <https://emulator.botframework.com>
- Bot Framework Emulator documentation
    - <https://github.com/microsoft/botframework-emulator/wiki/Getting-Started>