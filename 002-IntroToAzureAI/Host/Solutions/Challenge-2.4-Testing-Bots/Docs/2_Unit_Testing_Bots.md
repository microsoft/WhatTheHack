# Unit Testing Bots

## 1.	Objectives

Writing code using Microsoft Bot Framework is fun and exciting. But before rushing to code bots, you need to think about unit testing your code. Chatbots bring their own set of challenges to testing including testing across environments, integrating third party APIs, etc. Unit testing is a software testing method where individual units/components of a software application are tested.

Unit tests can help:

* Verify functionality as you add it
* Validate your components in isolation
* People unfamiliar with your code verify they haven't broken it when they are working with it

The goal of this lab is to introduce unit testing for bots developed using Microsoft Bot Framework.

## 2.	Setup

Import the EchoBot Solution in VisualStudio from code\EchoBot. On successful import, you will see two projects (EchoBot, a Bot Application and EchoBotTests, a Test Project) as shown below. 

![Setup](images/Setup.png)

## 3.	Echobot

In this lab, we will use EchoBot to develop unit tests. EchoBot is a very simple bot that echos back to the user with any message typed. For example, if the user types "Hello", EchoBot responds with the message "You sent: Hello". The core of EchoBot code that uses Dialogs can be found below (MessagesController.cs). MessageReceivedAsync echos back to the user with "You said: "

````c#
public class EchoDialog : IDialog<object>
{
    public async Task StartAsync(IDialogContext context)
    {
        context.Wait(MessageReceivedAsync);
    }

public async Task MessageReceivedAsync(IDialogContext context, IAwaitable<IMessageActivity> argument)
    {
        var message = await argument;
        await context.PostAsync("You said: " + message.Text);
        context.Wait(MessageReceivedAsync);
    }
}
````

## 4.	Echobot - Unit Tests

With complex chatbots, you will have conversation state and conversation flow to worry about. There is also the fact that chatbots can respond multiple times to a single user message and that after sending a message, you don't immediately get a response. Given these complexities, mocking can help with unit testing. Mocking is primarily used in unit testing. An object under test may have dependencies on other (complex) objects. To isolate the behaviour of the object you want to test you replace the other objects by mocks that simulate the behavior of the real objects. This is useful if the real objects are impractical to incorporate into the unit test.

Unit tests can be created using Visual Studio's *Unit Test Project* within the EchoBot Solution. On importing EchoBot.sln, you will see EchoBotTests project which is a Unit Test Project. This project contains a few helper classes (developed by reusing the Bot Builder code) to help develop Unit Tests for Dialogs:

* DialogTestBase.cs
* FiberTestBase.cs
* MockConnectorFactory.cs

Inside EchoBotTests.cs, you will find a TestMethod called *ShouldReturnEcho*. *ShouldReturnEcho* verifies the result from EchoBot. The below line in EchoBotTests.cs mocks the behavior of EchoBot using RootDialog. RootDialog is used to provide the functionality of EchoBot.

````c#
using (new FiberTestBase.ResolveMoqAssembly(rootDialog))
````

Run all Tests by selecting  **Test -> Run -> All Tests** as shown below and verify the tests run successfully.

![Echo Bot](images/Echobot.png)

## 5.	Finish early? Try this for extra credit:

A.   Write another TestMethod called *EchoStartsWith* that verifies echo prompt begins with "You sent".

*Hint:* The TestMethod would be very similar to ShouldReturnEcho() and you would check if toUser.Text starts with "You sent". 

B.   Can you verify that the echoed messages were sent by a bot?

*Hint:* This would involve checking the properties of IMessageActivity response recieved.


 ### Continue to [3_Direct_Line_Testing](3_Direct_Line_Testing.md)

 Back to [README](../0_README.md)