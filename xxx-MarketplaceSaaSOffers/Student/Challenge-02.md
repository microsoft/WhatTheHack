# Challenge 02 - Emulate!

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

The marketplace exposes a set of APIs - the SaaS Fulfillment APIs - for onboarding and managing the SaaS offer lifecycle
for your solution. To publish a transactable SaaS offer in the marketplace you must write code to integrate with these
APIs. This code will be responsible for informing the marketplace of changes of state and responding to messages from
the marketplace.

In order to authenticate with the marketplace APIs you use Partner Center to create and publish a SaaS offer to at least
"preview" stage. To get going quick;y, rather than do this we will use an emulator designed to emulate the behaviour of
the SaaS Fulfillment APIs. This makes it easy to make changes and doesn't require access to Partner Center. It is important
to understand that final testing must always be carried out against the marketplace APIs themselves, the emulator is a
tool to accelerate development.

## Description

In this challenge you "install" and launch the emulator to be used for testing.

Clone the
[Microsoft Commercial Marketplace API Emulator](https://github.com/microsoft/Commercial-Marketplace-SaaS-API-Emulator)
into a folder on your machine

Your task is to launch the emulator using your preferred method

- The emulator should be made available on `http://localhost:3978`

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that the Azure Marketplace API Emulator home page is available at `http://localhost:3978`

## Learning Resources

- [Readme for Microsoft Commercial Marketplace API Emulator
](https://github.com/microsoft/Commercial-Marketplace-SaaS-API-Emulator/blob/main/README.md)

## Tips

The emulator can be run from VSCode or the command line if you have Node.js installed
(see [Prerequisites](./Challenge-00.md)). If you have Docker installed, the emulator can be run as a Docker container.
If you use Dev Containers with VS Code, you can also use this.

All the information is in the Readme linked from the learning resources.

If you already have Docker installed, this may be the simplest way to get the emulator up and running. Similarly, if
you use Dev Containers in VSCode, this is a good route to follow.

If using Docker, make sure to map the port correctly.
