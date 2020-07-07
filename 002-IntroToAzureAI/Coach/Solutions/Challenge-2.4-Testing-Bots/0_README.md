# Testing Bots with Microsoft Bot Framework


Writing code using Microsoft Bot Framework is fun and exciting. But before rushing to code bots that can make tea and send spaceships to Mars, you need to think about testing your code. This workshop demonstrates how you can:

1. Perform rapid development/testing using ngrok
2. Perform unit testing
3. Perform functional testing (using Direct Line).

## Prerequisites

* The latest update of Visual Studio 2015 or higher. You can download the community version [here](http://www.visualstudio.com) for free.

* The Bot Framework Emulator. To install the Bot Framework Emulator, download it from [here](https://emulator.botframework.com/). Please refer to [this documentation article](https://github.com/microsoft/botframework-emulator/wiki/Getting-Started) to know more about the Bot Framework Emulator.

* Access to portal and be able to create resources on Azure. We will not be providing Azure passes for this workshop.

* Be familiar with C# and have some experience developing bots with Microsoft Bot Framework.

* A published bot or a bot that you are ready to publish.

## Lab structure

The folder structure is arranged as follows:

__docs__: Contains all the hands-on labs

__code__: Contains all the code for the hands-on labs

The order of Hands-on Labs to carry out the solution is as follows:
1. [Ngrok](docs/1_Ngrok.md):
The aim of this hands-on lab is to show how you can use ngrok to perform rapid development/testing.
2. [Unit Testing Bots](docs/2_Unit_Testing_Bots.md):
Chatbots bring their own set of challenges to testing including testing across environments, integrating third party APIs, etc. In this hands-on lab, learn how to perform mocking to unit test your bot code.
3. [Direct Line](docs/3_Direct_Line_Testing.md):
This hands-on lab demonstrates how you can communicate directly with your bot from a custom client.

Follow the hands-on labs in the sequential manner described above.