# What The Hack - Rock Paper Scissors Boom

## Introduction

Rock Paper Scissors Boom is a collaborative competition among developers. It's based on a project idea from a Microsoft Developer Evangelist that was called "Rock Paper Azure".

This server project provides an API that developers can use to develop bots that play the Rock Paper Scissors Boom game.

Rules of the Game:

- A match is played between two bots and will consist of 100 rounds of Rock-Paper-Scissors
- Rock beats Scissors
- Scissors beats Paper
- Paper beats Rock
- A dynamite will defeat Rock, Paper, or Scissors played by the opponent.
- A water balloon will defeat a dynamite.
- Rock, Paper, and Scissors all beat water balloon.
- Each bot receives 10 sticks of dynamite to use during a match.
- All matching choices will be a tie with the same choice by opponent.
- Each bot may also throw a water balloon whenever it likes.

## Learning Objectives

In this hack, we are going to take a web app called "Rock Paper Scissors Boom" and deploy it on Azure! This app is a game server that allows bots to play the classic Rock/Paper/Scissors game. The web app is built on .NET core - it runs on Linux and Windows! The web app is open source and built by [DevChatter](https://www.twitch.tv/devchatter). This hack's repo was forked from `DevChatter's` [original repo](https://github.com/DevChatter/RockPaperScissorsBoom).

Through progressive challenges we will build the web app, deploy it to Azure, monitor it, protect it, enhance and extend it.

At the end, each team will be able to build their own bot and compete with each other.

## Technologies

Here are the technologies and services you will leverage:

- GitHub
- ASP.NET Core & .NET 6
- SQL Server on Linux
- Docker
- Azure SQL Database
- Azure App Service Container on Linux
- Azure Container Registry
- Azure AD B2C
- Azure CDN
- Azure Application Insights
- Logic Apps
- Azure Event Grid

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
  - Prepare your workstation to work with Azure.
- Challenge 01: **[Run the app](Student/Challenge-01.md)**
  - Get the app running locally
- Challenge 02: **[Move to Azure SQL Database](Student/Challenge-02.md)**
  - Modify the locally running app to use an Azure SQL database
- Challenge 03: **[Run the app on Azure](Student/Challenge-03.md)**
  - Deploy the containerized app to Azure
- Challenge 04: **[Run the Game Continuously](Student/Challenge-04.md)**
  - Set up automation to run the game continuously
- Challenge 05: **[Add Application Monitoring](Student/Challenge-05.md)**
  - Add Application Monitoring to the app
- Challenge 06: **[Implement AAD B2C](Student/Challenge-06.md)**
  - Implement authentication for the application
- Challenge 07: **[Leverage SignalR](Student/Challenge-07.md)**
  - Set up a bot to play the game & communicate with SignalR
- Challenge 08: **[Leverage CDN](Student/Challenge-08.md)**
  - Set up a CDN to serve static content
- Challenge 09: **[Send a Winner Notification](Student/Challenge-09.md)**
  - Send a notification when a game is won
- Challenge 10: **[Run a Load Test](Student/Challenge-10.md)**
  - Run a load test against the app
- Challenge 11: **[Tournament Instructions](Student/Challenge-11.md)**
  - Build a bot and compete in a tournament

## Prerequisites

- Your own Azure subscription with Owner access
- Visual Studio Code
- Docker
- NET 6.0 SDK
- Azure CLI

## Contributors

- Mike Richter
- Jordan Bean
- Brian Cheng
