# Challenge 07 - Leverage SignalR

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-08.md)

## Introduction

With this challenge you will deploy and add your own `SmartBot` by leveraging `SignalR`, you will add a new competitor in your games.

## Description

- There is already the `RockPaperScissorsBoom.ExampleBot` project in your solution implementing a `SignalR` bot, let's just use it and deploy it!
- Deploy it on a new Azure Web App for Containers instance.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Validate that your new Azure Web App & Docker image are deployed using `az webapp list` and `az cr repository show-tags`.
- In your web browser, navigate to the main web app (Server), add this Bot as a new competitor and play a game, make sure it's working without any error.

## Learning Resources

- [SignalR](https://dotnet.microsoft.com/en-us/apps/aspnet/signalr)

## Tips

- To add this new Bot deployed in your Game, just navigate to the `Competitors` menu of your main web app (Server) and create a new competitor. You will have to provide the URL of your Bot and add `/decision` to the end of the URL.
