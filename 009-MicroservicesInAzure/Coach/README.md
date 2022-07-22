# What The Hack - Microservices in Azure

## Introduction

Welcome to the coach's guide for the Microservices in Azure What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

The intent of this hack is to give attendees the ability to quickly deploy a running microservices application in Azure.  There are a few caveats that should be emphasized up front:

- Everything being deployed is a container:  As a core tenet, microservices are smaller, independent services that focus more on team independence (ie: to allow a polygot approach) that de-emphasizes platform.  Pick the right platform (.Net/Java/NodeJS/etc) that fits both the problem at hand and skills of the team.
- This hack models a dev/test model, with the pick of technologies and configuration management approach.  In a Production mode, a given solution would have a container orchestrator (Kubernetes, Docker Swarm, etc) and the management of secrets for the application would use something like Azure Key Vault.
- The goal of this hack is to not only emphasize the ease of standing up a solution in Azure but also some of the underlying complexities that more components in an architecture bring.  Remember microservices aren’t the solution to everything.

This hack also includes a [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the coach present each short presentation before attendees kick off that challenge.

## Coach's Guides

- Pre-Hack Setup: **[Setting up the Coach's Environment](PreHack-Setup.md)**
  - Coaches need to have access to a running version of the solution to demonstrate the end goal.
- Challenge 0: **[Pre-requisites - Ready, Set, GO!](Challenge-00.md)**
  - A smart cloud solution architect always has the right tools in their toolbox. 
- Challenge 1: **[First Thing is First - A Resource Group](Challenge-01.md)**
  - All work in Azure begins with the resource group.
- Challenge 2: **[Always Need App Insights](Challenge-02.md)**
  - Getting Application Insights turned on and used by default.
- Challenge 3: **[Get Some Data](Challenge-03.md)**
  - Setting up Cosmos DB as our data store.
- Challenge 4: **[Deploying to ACI](Challenge-04.md)**
  - Deploying our back-end microservices as Azure Container Instances.
- Challenge 5: **[Deploy the Website](Challenge-05.md)**
  - Deploying our front-end microservice as a container web app running on Linux App Services

## Resources

- `../Solutions/Code`
  - Code for the microservices used in this hack.
  - Run `buildContainers.cmd` to rebuild the containers and publish them to the `microservicesdiscovery` account.
- `../Solutions/Scripts`
  - Scripts for deploying the microservices to Azure and creating all the necessary Azure infrastructure.
