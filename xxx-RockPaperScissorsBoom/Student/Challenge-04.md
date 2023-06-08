# Challenge 04 - Run the Game Continuously

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

This is a simple challenge to get your Rock Papers Scissors Boom Server app to play the game continuously. This will help you generate telemetry for your application. As you develop your own bots to play the game, you can use this feature to have the bots automatically play each other and see how your bot compares to the others.

![Run the game continuously](../docs/RunTheGameContinuously.png)

## Description

1. Find the API URL that you can hit to start a game.
1. Use an Azure resource to automate hitting this URL.

## Success Criteria

To complete this challenge successfully, you should be able to:

1. The game is playing at a continuous interval. (e.g. every 5 minutes)
1. In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Learning Resources

- [Recurring Tasks with Logic Apps](https://docs.microsoft.com/en-us/azure/connectors/connectors-native-recurrence)

## Tips

- Logic Apps would be a good solution for this!
- The path will be https://[yourwebsite]**/api/rungame**
- Make sure you use the right HTTP Method (**POST**).
- Try testing with [Postman](https://www.getpostman.com/) before setting your automation.
