# Challenge 10 - Send a Winner Notification

[< Previous Challenge](./Challenge-09.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-11.md)

## Introduction

Imagine if you had this requirement: After each game is played, a notification should be sent to someone about who won the game. Guess what? That is what this challenge is all about!

## Description

- You want to automate sending the winner notification after every game is played.
- You need to build this feature using Azure's serverless capabilities to make sure it's done quickly and to keep costs at a minimum.
- The application is already wired-up to raise an event when the game completes. The event contains details about the winner. Can you use this event to complete the Winner Notification feature?

## Success Criteria

To complete this challenge successfully, you should be able to:

- After a game is played, a person gets a notification that includes
  - Team Name
  - Server Name
  - Winner Name
  - Game Id
- The notification comes automatically and relatively quickly after the game is played (within 30 seconds).

## Learning Resources

- [Event Grid Trigger for Azure Logic Apps](https://learn.microsoft.com/en-us/azure/event-grid/monitor-virtual-machine-changes-logic-app)

## Tips

- You may want to disable to Logic App that has been calling your web app automatically so you don't get a bunch of emails while you are working on this challenge.
- Event Grid Topic --> Event Grid Subscription (Webhook to Azure Logic App)
- The Logic App has a step that sends an email.
- Look at the `RockPaperScissorsBoom.Server/EventGridPayload.json` file to see what data is available in the event.
