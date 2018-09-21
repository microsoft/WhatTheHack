## 1_Topics_and_Regex:
Estimated Time: 45-60 minutes

## Building a Bot

We assume that you've had some exposure to the Bot Framework. If you have, great. If not, don't worry too much, you'll learn a lot in this section. We recommend completing [this Microsoft Virtual Academy course](https://mva.microsoft.com/en-us/training-courses/creating-bots-in-the-microsoft-bot-framework-using-c-17590#!) and checking out the [documentation](https://docs.microsoft.com/en-us/bot-framework/).

### Lab 1.1: Setting up for bot development

We will be developing a bot using the latest .NET SDK (v4).  To get started, we'll need to download the Bot Framework Emulator, and we'll need to clone and build the SDK. We'll emulate everything locally in this lab, and won't need any keys or services at this point.  

#### Download the Bot Framework Emulator  

1. Download the Bot Framework Emulator for testing your bot locally [here](https://github.com/Microsoft/BotFramework-Emulator/releases/download/v3.5.33/botframework-emulator-Setup-3.5.33.exe).  The emulator installs to `c:\Users\`_your-username_`\AppData\Local\botframework\app-3.5.33\botframework-emulator.exe` or your Downloads folder, depending on browser.  

#### Building the SDK

> Note: You can either **install the packages locally**, or use **NuGet Package Manager** and add the packages. Because the product is in pre-release (as of today 5/1/2018), sometimes changes will be reflected in the SDK faster than in the NuGet packages. **We recommend using the NuGet packages** (explained in 1.2) for the purposes of these labs, but if you want to be on the latest build, you can follow the instructions below. 

Follow the [instructions here to build the SDK](https://github.com/Microsoft/botbuilder-dotnet/wiki/Building-the-SDK).  

Make sure you follow the instructions for consuming the NuGet packages. I recommend copying the NuGet packages to a new folder called "botbuilder-dotnet" where the rest of your NuGet packages are stored - **C:\Program Files (x86)\Microsoft SDKs\NuGetPackages**. This is a tedious process, because you need to grab the NuGet packages (they end in ".nupkg") from the following folders:
* C:\Users\[username]\botbuilder-dotnet\libraries\integration\Microsoft.Bot.Builder.Integration.AspNet.Core\bin\Debug - NuGet Packages
* C:\Users\[username]\botbuilder-dotnet\libraries\Microsoft.Bot.Builder\bin\Debug - NuGet Packages
* C:\Users\[username]\botbuilder-dotnet\libraries\Microsoft.Bot.Builder.Core\bin\Debug - NuGet Packages
* C:\Users\[username]\botbuilder-dotnet\libraries\Microsoft.Bot.Builder.Core.Extensions\bin\Debug - NuGet Packages
* C:\Users\[username]\botbuilder-dotnet\libraries\Microsoft.Bot.Builder.AI.LUIS\bin\Debug - NuGet Packages
* C:\Users\[username]\botbuilder-dotnet\libraries\Microsoft.Bot.Connector\bin\Debug - NuGet Packages
* C:\Users\[username]\botbuilder-dotnet\libraries\Microsoft.Bot.Schema\bin\Debug - NuGet Packages  

> **Note**: If you don't have the rights (you need admin rights on your machine) to add the packages to this folder, add them to a local folder, perhaps under **Documents/botbuilder-dotnet**. Then follow the following instructions to add the packages to NuGet Package Manager:  
>1.  Open Visual Studio.
>2.  Select **Tools > NuGet Package Manager > Package Manager Settings > Package Sources**.
>3.  Select the green plus in the top right of the window. Rename the Package source to "botbuilder-dotnet."
>4.  Select the "..." next to the Source field and browse to your local folder with the NuGet packages you copied over, click "Select."
>5.  Hit OK twice.  
>Now, you should be able to add the NuGet packages locally in the followed labs.

### Lab 1.2: Creating a simple bot and running it

In Visual Studio, create a new ASP.NET Core Web Application called "PictureBot":  
* Target **.NET Core ASP.NET Core 2.0**.
* Pick the **Empty** project template.
* Select **No Authentication**, if it isn't selected already. 

>**TIP**:  If you only have one monitor and you would like to easily switch between instructions and Visual Studio, you can add the instruction files to your Visual Studio solution by right-clicking on the project in Solution Explorer and selecting **Add > Existing Item**. Navigate to "lab02.2-bulding_bots," and add all the files of type "MD File." 

Right-click on the solution in Solution Explorer and select "Manage NuGet Packages for Solution." Install all of the packages listed below, starting with "Microsoft.Bot.Builder."  Make sure you check the box "Include prerelease" and are on the "Browse" tab.  After you've installed them, under **Dependencies > NuGet** in your Solution Explorer, you should see the following packages:  
 
* Microsoft.Bot.Builder
* Microsoft.Bot.Builder.Integration.AspNet.Core
* Microsoft.Bot.Builder.Core
* Microsoft.Bot.Connector
* Microsoft.Bot.Schema  
* Microsoft.Bot.Builder.Core.Extensions
* Microsoft.Bot.Builder.AI.LUIS  

> Note: If you built the SDK locally, in the top right of the new window, you will need to change the Package source to "Microsoft Visual Studio Offline Packages" (or "botbuilder-dotnet" if you followed the extra steps to create a package source).

There is one other NuGet package we'll need later. Browse for the "Microsoft.Azure.Search" package and install it (read more about using the NuGet window to install packages [here](https://docs.microsoft.com/en-us/nuget/tools/package-manager-ui)).  

We need to add some code to tell the app what to show us in the browser when we run it. Add an html file called `default.html` under the wwwroot folder (be sure to right-click **wwwroot > Add > New item**), and replace the default contents with the following:
```html
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta charset="utf-8" />
</head>
<body style="font-family:'Segoe UI'">
    <h1>PictureBot</h1>
    <p>Describe your bot here and your terms of use etc.</p>
    </body>
</html>
```


Update the Startup.cs file to this:  

```csharp
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Bot.Builder.BotFramework;
using Microsoft.Bot.Builder.Integration.AspNet.Core;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Bot.Builder.Core.Extensions;
using System.Text.RegularExpressions;

namespace PictureBot
{
    public class Startup
    {
        public IConfiguration Configuration { get; }

        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            Configuration = builder.Build();
        }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddSingleton(_ => Configuration);
            services.AddBot<PictureBot>(options =>
            {
                options.CredentialProvider = new ConfigurationCredentialProvider(Configuration);
            // Add middleware below

            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseDefaultFiles();
            app.UseStaticFiles();
            app.UseBotFramework();
        }
    }
}
```
Create a PictureBot.cs class file. Update the file to this:  
```csharp
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Schema;
using Microsoft.Bot;

namespace PictureBot
{
    public class PictureBot : IBot
    {
        public async Task OnTurn(ITurnContext context)
        {
            if (context.Activity.Type is ActivityTypes.Message)
            {
                await context.SendActivity($"Hello world.");
            }

        }
    }
}
```

>The rest of the **Creating a simple bot and running it** lab is optional. Per the prerequisites, you should have experience working with the Bot Framework. You can hit F5 to confirm it builds correctly, and move on to the next lab (1.3 Organizing Code for Bots).  


Now start your bot (with or without debugging) by pressing the "IIS Express" button that looks like a play button (or hit F5). NuGet should take care of downloading the appropriate dependencies.  
* Your default.html page will be displayed in a browser.
* Note the localhost port number for the page. You will need this information to interact with your bot.  

To interact with your bot:
* Launch the Bot Framework Emulator.  (If you just installed it, it may not be indexed to show up in a search on your local machine, so remember that it installs to c:\Users\your-username\AppData\Local\botframework\app-3.5.27\botframework-emulator.exe.)  Ensure that the Bot URL matches the port number that launched in the web browser, and then api/messages appended to the end (e.g. `http://localhost:portNumber/api/messages`).  You should be able to converse with the bot. 
* Type "hello", and the bot will respond with "Hello World" to every message.

![Bot Emulator](./resources/assets/botemulator2.png) 

> Fun Aside: why this port number?  It is set in your project properties.  In your Solution Explorer, double-click **Properties>Debug** and examine its contents. Does the App URL match what you connected to in the emulator?

Browse around and examine the sample bot code. In particular, note:
+ **Startup.cs** is where we will add services/middleware and configure the HTTP request pipeline.  
+ In **PictureBot.cs**, `OnTurn` is the entry point which waits for a message from the user, and `context.Activity.Type is ActivityTypes.Message` is where we can react to a message once received and wait for further messages.  We can use `context.SendActivity` to send a message from the bot back to the user.  


### Lab 1.3: Organzing Code for Bots

There are many different methods and preferences for developing bots. The SDK allows you to organize your code in whatever way you want. In these labs, we'll organize our conversations into topics, and we'll explore a [MVVM style](https://msdn.microsoft.com/en-us/library/hh848246.aspx) of organizing code around conversations.

This PictureBot will be organized in the following way:
* **Models** - the objects to be modified
* **Topics** - the business logic for editing the models
* **Responses** - classes which define the outputs to the users  

Next, create a folder for each piece in your PictureBot project (create three folders: "Models", "Topics", "Responses").  
#### Topics  

We'll start by defining an interface ITopic which gives it the basic ability to manage topics. We'll include the following pieces:  

* **ITopic.StartTopic()** -Called when a topic is created.
* **ITopic.ContinueTopic()** - Called for every activity as context.State.Conversation.ActivePrompt points to it.
* **ITopic.ResumeTopic()** - Called whenever someone has interrupted your topic so you can resume your topic cleanly. 

The UserStateManagerMiddleware() and ConversationStateManagerMiddleware() will be used to add automatic persistence of the **context.state.ConversationProperties** and **context.state.UserProperties** objects.  

We'll set the **context.state.Conversation.ActiveTopic** to point to an instance of the active ITopic class,
which is automatically serialized on activity. It then uses this property to manage the active topic and switch between topics.  

Create a new class titled "ITopic.cs." Review the code below before adding it to "ITopic.cs"
```csharp
using System.Threading.Tasks;
using Microsoft.Bot.Builder;

namespace PictureBot
{
    public interface ITopic
    {
        /// <summary>
        /// Name of the topic
        /// </summary>
        string Name { get; set; }

        /// <summary>
        /// Called when topic starts
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        Task<bool> StartTopic(ITurnContext context);

        /// <summary>
        /// Called while topic active
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        Task<bool> ContinueTopic(ITurnContext context);

        /// <summary>
        ///  Called when a topic is resumed
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        Task<bool> ResumeTopic(ITurnContext context);
    }
}
```

We'll try to keep the code simple for the purposes of this lab, so we'll only have two topics:

* **RootTopic** - The default topic the bot starts out with. This class will start other topic(s) as the user requests them.
* **SearchTopic** - A topic which manages processing search requests and returning those results to the user.  

Create two classes, called "RootTopic.cs" and "SearchTopic.cs" within the "Topics" folder. Put the following shell in for each (noting you'll have to change "RootTopic" and "Root" to "SearchTopic" and "Search"):

```csharp
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Core.Extensions;
using PictureBot.Models;
using PictureBot.Responses;
using Microsoft.Bot.Schema;
using System.Configuration;
using Microsoft.Azure.Search;
using Microsoft.Azure.Search.Models;
using System;

namespace PictureBot.Topics
{
    public class RootTopic : ITopic
    {
        public string Name { get; set; } = "Root";

        public Task<bool> StartTopic(ITurnContext context)
        {
            throw new NotImplementedException();
        }

        public Task<bool> ContinueTopic(ITurnContext context)
        {
            throw new NotImplementedException();
        }

        public Task<bool> ResumeTopic(ITurnContext context)
        {
            throw new NotImplementedException();
        }

    }
}
```
As the code is now, the two classes are just simple implementations of **ITopic**, which we configured earlier. Review the ITopic class with the new Topic classes you've created to confirm you agree. In the next lab, we'll start adding things to our topics (removing `throw new NotImplementedException();` as we go).

#### Responses
Create two classes, called "RootResponses.cs" and "SearchResponses.cs" within the "Responses" folder. As you may have figured out, the Responses files will simply contain the different outputs we may want to send to users, no logic.  

Within "RootResponses.cs" add the following:
```csharp
using System.Threading.Tasks;
using Microsoft.Bot.Builder;

namespace PictureBot.Responses
{
    public class RootResponses
    {
        public static async Task ReplyWithGreeting(ITurnContext context)
        {
            // Add a greeting
        }
        public static async Task ReplyWithHelp(ITurnContext context)
        {
            await context.SendActivity($"I can search for pictures, share pictures and order prints of pictures.");
        }
        public static async Task ReplyWithResumeTopic(ITurnContext context)
        {
            await context.SendActivity($"What can I do for you?");
        }
        public static async Task ReplyWithConfused(ITurnContext context)
        {
            // Add a response for the user if Regex or LUIS doesn't know
            // What the user is trying to communicate
        }
        public static async Task ReplyWithLuisScore(ITurnContext context, string key, double score)
        {
            await context.SendActivity($"Intent: {key} ({score}).");
        }
        public static async Task ReplyWithShareConfirmation(ITurnContext context)
        {
            await context.SendActivity($"Posting your picture(s) on twitter...");
        }
        public static async Task ReplyWithOrderConfirmation(ITurnContext context)
        {
            await context.SendActivity($"Ordering standard prints of your picture(s)...");
        }
    }
}
```

Note that there are two responses with no values (ReplyWithGreeting and ReplyWithConfused). Fill these in as you see fit.

Within "SearchResponses.cs" add the following:
```csharp
using Microsoft.Bot.Builder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace PictureBot.Responses
{
    public class SearchResponses
    {
        // add a task called "ReplyWithSearchRequest"
        // it should take in the context and ask the
        // user what they want to search for




        public static async Task ReplyWithSearchConfirmation(ITurnContext context, string utterance)
        {
            await context.SendActivity($"Ok, searching for pictures of {utterance}");
        }
        public static async Task ReplyWithNoResults(ITurnContext context, string utterance)
        {
            await context.SendActivity("There were no results found for \"" + utterance + "\".");
        }
    }
}
```

Note here a whole task is missing. Fill in as you see fit, but make sure the new task has the name "ReplyWithSearchRequest", or you may have issues later.  

#### Models 
Due to time limitations, we will not be walking through creating all the models. They are straightforward, and we recommend taking some time to review the code within after you've added them. Right-click on the "Models" folder and select **Add>Existing Item**. Navigate to "challenge2.2-building_bots/building_bots-sdk_v4/resources/code/Models", select all four files, and select "Add."  

At this point, your Solution Explorer should look similar to the following image:
![Solution Folder view for Bot](./resources/assets/solutionExplorer.png) 

Are you missing anything? Now's a good time to check.

The last thing we need to do before we start building out our topics, is to update "PictureBot.cs" to use ITopic to manage the handling conversations. Replace the contents of "PictureBot.cs" with the following:
```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Bot;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Schema;
using PictureBot.Models;
using PictureBot.Topics;
using Microsoft.Bot.Builder.Core.Extensions;

namespace PictureBot
{
    public class PictureBot : IBot
    {
        public async Task OnTurn(ITurnContext context)
        {
            // Get the current ActiveTopic from my persisted conversation state
            var conversation = ConversationState<ConversationData>.Get(context);

            var handled = false;

            // if we don't have an active topic yet
            if (conversation.ActiveTopic == null)
            {
                // use the default topic
                conversation.ActiveTopic = new RootTopic();
                handled = await conversation.ActiveTopic.StartTopic(context);
            }
            else
            {
                // we do have an active topic, so call it 
                handled = await conversation.ActiveTopic.ContinueTopic(context);
            }

            // if activeTopic's result is false and the activeTopic is NOT already the default topic
            if (handled == false && !(conversation.ActiveTopic is RootTopic))
            {
                // Use DefaultTopic as the active topic
                conversation.ActiveTopic = new RootTopic();
                await conversation.ActiveTopic.ResumeTopic(context);
            }
        }
    }
}
```
Take a few minutes to read the comments and be sure you understand what we're doing here.

### Lab 1.4: Regex and Middleware

There are a number of things that we can do to improve our bot.  First of all, we may not want to call LUIS for a simple "hi" greeting, which the bot will get fairly frequently from its users.  A simple regular expression could match this, and save us time (due to network latency) and money (due to cost of calling the LUIS service).  

Also, as the complexity of our bot grows, and we are taking the user's input and using multiple services to interpret it, we need a process to manage that flow.  For example, try regular expressions first, and if that doesn't match, call LUIS, and then perhaps we also drop down to try other services like [QnA Maker](http://qnamaker.ai) and Azure Search. A great way to manage this is through [Middleware](https://github.com/Microsoft/botbuilder-dotnet/wiki/Creating-Middleware), and the SDK does a great job supporting that. We call middleware from `ConfigureServices` under `Startup.cs`, simply by calling additional options add it (check your `Startup.cs` file to see the location). 

Before continuing with the lab, learn more about middleware and the Bot Framework SDK:  
1.  [Overview and Architecture](https://github.com/Microsoft/botbuilder-dotnet/wiki/Overview)
2.  [Creating Middleware](https://github.com/Microsoft/botbuilder-dotnet/wiki/Creating-Middleware)
3.  [In the SDK, under `Microsoft.Bot.Builder.Core.Extensions`](https://github.com/Microsoft/botbuilder-dotnet/tree/master/libraries/Microsoft.Bot.Builder.Core.Extensions), you can look at some of the middleware that's built-in to the SDK.  

Ultimately, we'll use some middleware to try to understand what users are saying with regular expressions (Regex) first, and if we can't, we'll call LUIS. If we still can't, then we'll drop down to a generic "I'm not sure what you mean" response, or whatever you put for "ReplyWithConfused."    

To add the middleware for Regex to your solution, create a new folder called "Middleware," and add the contents of the "Middleware" folder (you can find this under **resources > code**) to your solution.

In "Startup.cs", below the "Add middleware below" comment within `ConfigureServices`, add the following:
```csharp
                var middleware = options.Middleware;

                middleware.Add(new UserState<UserData>(new MemoryStorage()));
                middleware.Add(new ConversationState<ConversationData>(new MemoryStorage()));
                // Add Regex ability below
                middleware.Add(new RegExpRecognizerMiddleware()
                    .AddIntent("search", new Regex("search picture(?:s)*(.*)|search pic(?:s)*(.*)", RegexOptions.IgnoreCase))
                    .AddIntent("share", new Regex("share picture(?:s)*(.*)|share pic(?:s)*(.*)", RegexOptions.IgnoreCase))
                    .AddIntent("order", new Regex("order picture(?:s)*(.*)|order print(?:s)*(.*)|order pic(?:s)*(.*)", RegexOptions.IgnoreCase))
                    .AddIntent("help", new Regex("help(.*)", RegexOptions.IgnoreCase)));
                // Add LUIS ability below
```
You will probably get some errors within this. Fix them.  

**Hint (1):** UserData and ConversationData are the objects we persisted as user and conversation state "State.cs" (in the Models folder).  

**Hint (2):** You're missing a using statement.  

> We're really just skimming the surface of using regular expressions. [Learn more](https://docs.microsoft.com/en-us/dotnet/standard/base-types/regular-expression-language-quick-reference).  

Hopefully, it's fairly easy to see what we're doing here. Because of the order, we'll try Regex then LUIS. Without adding LUIS, our bot is really only going to pick up on a few variations, but it should capture a lot, if the users are using the bot for searching and sharing and ordering pictures. 

> Fun Aside: One might argue that the user shouldn't have to type "help" to get a menu of clear options on what the bot can do; rather, this should be the default experience on first contact with the bot.  **Discoverability** is one of the biggest challenges for bots - letting the users know what the bot is capable of doing.  Good [bot design principles](https://docs.microsoft.com/en-us/bot-framework/bot-design-principles) can help.   

#### RootTopic, Again

Let's get down to business. We need to update RootTopic so that it does a few things, but in a topic-fashion:
1.  StartTopic - Greets the user when they join the conversation, and tells them what the bot can do. Once we've greeted them, continue the conversation.

Make sure you understand the code, then replace the `StartTopic` method in "RootTopic.cs" with the following:
```csharp
        // track in this topic if we have greeted the user already
        public bool Greeted { get; set; } = false;
        public string facet;

        /// <summary>
        /// Called when the default topic is started
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public async Task<bool> StartTopic(ITurnContext context)
        {
            switch (context.Activity.Type)
            {
                case ActivityTypes.ConversationUpdate:
                    {
                        // greet when added to conversation
                        var activity = context.Activity.AsConversationUpdateActivity();
                        if (activity.MembersAdded.Any(m => m.Id == activity.Recipient.Id))
                        {
                            await RootResponses.ReplyWithGreeting(context);
                            await RootResponses.ReplyWithHelp(context);
                            this.Greeted = true;
                        }
                    }
                    break;
                case ActivityTypes.Message:
                    // greet on first message if we haven't already 
                    if (!Greeted)
                    {
                        await RootResponses.ReplyWithGreeting(context);
                        this.Greeted = true;
                    }
                    return await this.ContinueTopic(context);
            }
            return true;
        }
```

2.  ContinueTopic - We need to react to what the user says they want to do.

Based on our results from Regex, we need to direct the conversation in the next direction. Read the code carefully to confirm you understand what it's doing, then paste in the following code to replace ContinueTopic:
```csharp
        /// <summary>
        /// Continue the topic, method which is routed to while this topic is active
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public async Task<bool> ContinueTopic(ITurnContext context)
        {
            var conversation = ConversationState<ConversationData>.Get(context);
            var recognizedIntents = context.Services.Get<IRecognizedIntents>();

            switch (context.Activity.Type)
            {
                case ActivityTypes.Message:
                    switch (recognizedIntents.TopIntent?.Name)
                    {
                        case "search":
                            // switch to search topic
                            conversation.ActiveTopic = new SearchTopic();
                            return await conversation.ActiveTopic.StartTopic(context);
                        case "share":
                            // show that you're sharing
                            await RootResponses.ReplyWithShareConfirmation(context);
                            return true;
                        case "order":
                            // show that you're ordering
                            await RootResponses.ReplyWithOrderConfirmation(context);
                            return true;
                        case "help":
                            // show help
                            await RootResponses.ReplyWithHelp(context);
                            return true;
                        default:
                            // adding app logic when Regex doesn't find an intent 
                            // respond saying we don't know
                            await RootResponses.ReplyWithConfused(context);
                            return true;
                    }
            }
            return true;
        }
```
3.  ResumeTopic - In both Topics we'll create today, this serves as a "catch" if for some reason (maybe the user interrupts the bot) the active topic isn't handled and isn't RootTopic, this will basically start us over.  

Replace ResumeTopic with the following code:
```csharp
        /// <summary>
        /// Resume the topic
        /// </summary>
        /// <param name="context"></param>
        /// <returns></returns>
        public async Task<bool> ResumeTopic(ITurnContext context)
        {
            await RootResponses.ReplyWithResumeTopic(context);
            return true;
        }
```

Hit F5 to run the bot. Test it by sending commands like "help", "share pics", "order pics", and "search pics". If the only thing that failed was "search pics", everything is working how you configured it. But why is "search pics" failing? Have an answer before you move on!

Get stuck? You can find the solution for this lab under [resources/code/FinishedPictureBot-Part1](./resources/code/FinishedPictureBot-Part1).



### Continue to [2_Azure_Search](./2_Azure_Search.md)  
Back to [README](./0_README.md)
