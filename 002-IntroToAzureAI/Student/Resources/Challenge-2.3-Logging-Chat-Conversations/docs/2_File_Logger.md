# File Logger

## 1.	Objectives

The aim of this lab is to log chat conversations to a file using middleware. Excessive Input/Output (I/O) operations can result in slow responses from the bot. In this lab, the global events are leveraged to perform efficient logging of chat conversations to a file. This activity is an extension of the previous lab's concepts.

Import the project from code\file-core-Middleware in Visual Studio.

## 2. An inefficient way of logging

A very simple way of logging chat conversations to a file is to use File.AppendAllLines as shown below in the code snippet. File.AppendAllLines opens a file, appends the specified string to the file, and then closes the file. However, this can be very inefficient way of logging as we will be opening and closing the file for every message from the user/bot.
tu
````C#
public class DebugActivityLogger : IActivityLogger
{
    public async Task LogAsync(IActivity activity)
    {
        File.AppendAllLines("C:\\Users\\username\\log.txt", new[] { $"From:{activity.From.Id} - To:{activity.Recipient.Id} - Message:{activity.AsMessageActivity().Text}" });
    }
}
````

## 3.	An efficient way of logging

A more efficient way of logging to a file is to use the Global.asax file and use the events related to the lifecycle of the bot. Extend the global.asax as shown in the code snippet below. Change the below line to a path that exists in your environment.

````C# 
tw = new StreamWriter("C:\\Users\\username\\log.txt", true);
````

Application_Start opens a StreamWriter that implements a Stream wrapper that writes characters to a stream in a particular encoding. This lasts for the life of the bot and we can now just write to it as opposed to opening and closing the file for each message. It is also worth noting that the StreamWriter is now sent as a parameter to DebugActivityLogger. The log file can be closed in Application_End which is called once per lifetime of the application before the application is unloaded.

````C#
using System.Web.Http;
using Autofac;
using Microsoft.Bot.Builder.Dialogs;
using System.IO;
using System.Diagnostics;
using System;


namespace MiddlewareBot
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        static TextWriter tw = null;
        protected void Application_Start()
        {
            tw = new StreamWriter("C:\\Users\\username\\log.txt", true);
            Conversation.UpdateContainer(builder =>
            {
                builder.RegisterType<DebugActivityLogger>().AsImplementedInterfaces().InstancePerDependency().WithParameter("inputFile", tw);
            });

            GlobalConfiguration.Configure(WebApiConfig.Register);
        }

        protected void Application_End()
        {
            tw.Close();
        }
    }
}
````

Recieve the file parameter in DebugActivityLogger constructor and update LogAsync to write to the log file now by adding the below lines.

````C#
tw.WriteLine($"From:{activity.From.Id} - To:{activity.Recipient.Id} - Message:{activity.AsMessageActivity().Text}", true);
tw.Flush();
````

The entire DebugActivityLogger code looks as follows:

````C#
using System.Diagnostics;
using System.Threading.Tasks;
using Microsoft.Bot.Builder.History;
using Microsoft.Bot.Connector;
using System.IO;

namespace MiddlewareBot
{    
    public class DebugActivityLogger : IActivityLogger
    {
        TextWriter tw;
        public DebugActivityLogger(TextWriter inputFile)
        {
            this.tw = inputFile;
        }


        public async Task LogAsync(IActivity activity)
        {
            tw.WriteLine($"From:{activity.From.Id} - To:{activity.Recipient.Id} - Message:{activity.AsMessageActivity().Text}", true);
            tw.Flush();
        }
    }

}
````

## 4. Log file

Run the bot application in the emulator and test with messages. Investigate the log file specified in the line

````C# 
tw = new StreamWriter("C:\\Users\\username\\log.txt", true);
````

To view the log messages from the user and the bot, the messages should appear as follows in the log file now:

````From:2c1c7fa3 - To:56800324 - Message:a log message````

````From:56800324 - To:2c1c7fa3 - Message:You sent a log message which was 13 characters````

## 5. Selective Logging

In certain scenarios, it would be desirable to perform modeling on selective messages or selectively log. There are many such examples: a) A very active community bot can potentially capture a tsunami of chat messages very quickly and a lot of the chat messages may not be very useful. b) There may also be a need to selectively log to focus on certain users/bot or messages related to a particular trending product category/topic.

One can always capture all the chat messages and perform filtering to mine selective messages. However, having the flexibility to selectively log can be useful and the Microsoft Bot Framework allows this. To selectively log messages from the users, you can investigate the activity json and filter on "name". For example, in the json below, the message was sent by "Bot1".

```json
{
  "type": "message",
  "timestamp": "2017-10-27T11:19:15.2025869Z",
  "localTimestamp": "2017-10-27T07:19:15.2140891-04:00",
  "serviceUrl": "http://localhost:9000/",
  "channelId": "emulator",
  "from": {
    "id": "56800324",
    "name": "Bot1"
  },
  "conversation": {
    "isGroup": false,
    "id": "8a684db8",
    "name": "Conv1"
  },
  "recipient": {
    "id": "2c1c7fa3",
    "name": "User1"
  },
  "membersAdded": [],
  "membersRemoved": [],
  "text": "You sent hi which was 2 characters",
  "attachments": [],
  "entities": [],
  "replyToId": "09df56eecd28457b87bba3e67f173b84"
}
```
After investigating the json, the LogAsync method in DebugActivityLogger can be modified to filter on user messages by introducing a simple condition to check ````activity.From.Name```` property:

````C#
public class DebugActivityLogger : IActivityLogger
{
        public async Task LogAsync(IActivity activity)
        {
           if (!activity.From.Name.Contains("Bot"))
            {
               Debug.WriteLine($"From:{activity.From.Id} - To:{activity.Recipient.Id} - Message:{activity.AsMessageActivity()?.Text}");
            }
        }
}
````


### Continue to [3_SQL_Logger](3_SQL_Logger.md)

Back to [0_README](../0_README.md)