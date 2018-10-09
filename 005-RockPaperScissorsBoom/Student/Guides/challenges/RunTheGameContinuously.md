# Challenge 5 - Run the Game Continuously

## Prerequisities

1. [Challenge 4 - Run the app on Azure](./RunOnAzure.md) should be done successfully.

## Introduction

This is a simple challenge to get your Rock Papers Scissors Boom Server app to play the game continuously. This will help you generate telemetry for your application. As you develop your own bots to play the game, you can use this feature to have the bots automatically play each other and see how your bot compares to the others.

![Run the game continuously](../docs/RunTheGameContinuously.png)

## Challenges

1. Find the API URL that you can hit to start a game.
1. Use an Azure resource to automate hitting this URL.

## Success criteria

1. The game is playing at a continuous interval. (e.g. every 5 minutes)
1. In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Tips

* Logic Apps would be a good solution for this!

## Learning resources

* [Recurring Tasks with Logic Apps](https://docs.microsoft.com/en-us/azure/connectors/connectors-native-recurrence)

[Next challenge (Add Application Monitoring) >](./AddApplicationMonitoring.md)