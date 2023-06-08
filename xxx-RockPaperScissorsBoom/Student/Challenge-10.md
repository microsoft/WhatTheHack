# Challenge 10 - Send a Winner Notification

[< Previous Challenge](./Challenge-09.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-11.md)

## Introduction

Imagine if you had this requirement: After each game is played, a notification should be sent to someone about who won the game. Guess what? That is what this challenge is all about!

## Description

1. You want to automate sending the winner notification after every game is played.
1. You need to build this feature using Azure's serverless capabilities to make sure it's done quickly and to keep costs at a minimum.
1. The application is already wired-up to raise an event when the game completes. The event contains details about the winner. Can you use this event to complete the Winner Notification feature?

## Success Criteria

To complete this challenge successfully, you should be able to:

1. After a game is played, a person gets a notification that includes
   1. Team Name
   1. Server Name
   1. Winner Name
   1. Game Id
1. The notification comes automatically and relatively quickly after the game is played (within 30 seconds).

## Learning Resources

- [Event Grid Trigger for Azure Functions](https://docs.microsoft.com/en-us/azure/azure-functions/functions-bindings-event-grid)

## Tips

1. This feature was previously implemented with this architecture
   - Event Grid Topic --> Event Grid Subscription (Webhook to Azure Function)
   - Azure Function Initiates a Logic App HTTP trigger.
   - The Logic App has a step that sends an email.
1. You can see an example of the Azure Function in the [Func](../../Resources/Code/Func) folder in this repository.
   - Note that this requires a Windows-based Azure Function.
1. If you're sending emails as the notifications, don't bombard your own inbox. Use a free service like [maildrop.cc](http://maildrop.cc) to create dummy email accounts.
