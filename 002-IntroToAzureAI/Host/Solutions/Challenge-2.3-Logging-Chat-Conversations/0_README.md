---
layout: default
---

# Logging with Microsoft Bot Framework

Unless your bot is logging the conversation data somewhere, the bot framework will not perform any logging for you automatically. This has privacy implications, and many bots simply can't allow that in their scenarios.

This workshop demonstrates how you can perform logging using Microsoft Bot Framework and store chat conversations. More specifically, the aim of this lab is to:

1. Understand how to intercept and log message activities between bots and users.

2. Log conversations to a file using global events and activity logger.

3. Extend the logging to SQL DB using global events and activity logger.

## Uses of logging chat conversations

In the advanced analytics space, there are plenty of uses for storing log converstaions. Having a corpus of chat conversations can allow developers to: 
1. Build question and answer engines specific to a domain.
2. Introduce a personality to bots.
3. Perform analysis on specific topics or products to identify trends.

## Prerequisites

* The latest update of Visual Studio 2015 or higher. You can download the community version [here](http://www.visualstudio.com) for free.

* The Bot Framework Emulator. To install the Bot Framework Emulator, download it from [here](https://emulator.botframework.com/). Please refer to [this documentation article](https://github.com/microsoft/botframework-emulator/wiki/Getting-Started) to know more about the Bot Framework Emulator.

* Access to portal and be able to create resources on Azure. We will not be providing Azure passes for this workshop.

* Be familiar with C# and have some experience developing bots with Microsoft Bot Framework.

## Lab structure

The folder structure is arranged as follows:

__docs__: Contains all the hands-on labs

__code__: Contains all the code for the hands-on labs

The order of Hands-on Labs to carry out the solution is as follows:
1. [Activity Logger](docs/1_Activity_Logger.md):
The aim of this hands-on lab is to implement the IActivityLogger interface that writes message activities when running in debug. 
2. [File Logger](docs/2_File_Logger.md):
This hands-on lab is to demonstrate how you can log conversations to a file using global events.
3. [SQL Logger](docs/3_SQL_Logger.md):
This hands-on lab is an extension of the file logger. The same code from the previous task is extended to log conversations in SQL.

Follow the hands-on labs in the sequential manner listed above.

## Extra credit

After finishing all the activities, can you take an existing bot and selectively log conversations from the bot to a flat file?

### Continue to [Lab 2.4 - Testing your bot](../challenge2.4-testing_bots/0_README.md)
