// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Adapters;
using Microsoft.Bot.Builder.Dialogs;
using Microsoft.Bot.Builder.Dialogs.Adaptive;
using Microsoft.Bot.Builder.Dialogs.Declarative;
using Microsoft.Bot.Builder.Dialogs.Declarative.Resources;
using Microsoft.Bot.Schema;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;

namespace Tests
{
    [TestClass]
    public class InputsTests
    {
        private static string getOsPath(string path) => Path.Combine(path.TrimEnd('\\').Split('\\'));

        private static readonly string samplesDirectory = getOsPath(@"..\..\..\..\..\..\extensions\samples\assets\projects");

        private static ResourceExplorer resourceExplorer = new ResourceExplorer();


        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
            string path = Path.GetFullPath(Path.Combine(Environment.CurrentDirectory, samplesDirectory, "AskingQuestionsSample"));
            resourceExplorer.AddFolder(path);

            // register components.
            ComponentRegistration.Add(new DialogsComponentRegistration());
            ComponentRegistration.Add(new DeclarativeComponentRegistration());
            ComponentRegistration.Add(new AdaptiveComponentRegistration());
            ComponentRegistration.Add(new LanguageGenerationComponentRegistration());
        }

        [ClassCleanup]
        public static void ClassCleanup()
        {
            resourceExplorer.Dispose();
        }

        public TestContext TestContext { get; set; }

        // Override for locale test
        public static IActivity CreateConversationUpdateActivity()
        {
            return new Activity(ActivityTypes.ConversationUpdate)
            {
                MembersAdded = new List<ChannelAccount>() { new ChannelAccount(id: "test") },
                MembersRemoved = new List<ChannelAccount>(),
                Locale = "en-us"
            };
        }

        [TestMethod]
        public async Task Inputs_01TextInput()
        {
            await BuildTestFlow()
            .Send(CreateConversationUpdateActivity())
                .AssertReply(String.Format("Welcome to Input Sample Bot.{0}I can show you examples on how to use actions, You can enter number 01-07{0}01 - TextInput{0}02 - NumberInput{0}03 - ConfirmInput{0}04 - ChoiceInput{0}05 - AttachmentInput{0}06 - DateTimeInput{0}07 - OAuthInput{0}", Environment.NewLine))
            .Send("01")
                .AssertReply("Hello, I'm Zoidberg. What is your name? (This can't be interrupted)")
            .Send("02")
                .AssertReply("Hello 02, nice to talk to you!")
            .Send("02")
                .AssertReply("What is your age?")
            .StartTestAsync();
        }

        [TestMethod]
        public async Task Inputs_02NumberInput()
        {
            await BuildTestFlow()
            .Send(CreateConversationUpdateActivity())
                .AssertReply(String.Format("Welcome to Input Sample Bot.{0}I can show you examples on how to use actions, You can enter number 01-07{0}01 - TextInput{0}02 - NumberInput{0}03 - ConfirmInput{0}04 - ChoiceInput{0}05 - AttachmentInput{0}06 - DateTimeInput{0}07 - OAuthInput{0}", Environment.NewLine))
            .Send("02")
                .AssertReply("What is your age?")
            .Send("18")
                .AssertReply("Hello, your age is 18!")
                .AssertReply("2 * 2.2 equals?")
            .Send("4.4")
                .AssertReply("2 * 2.2 equals 4.4, that's right!")
            .StartTestAsync();
        }

        [TestMethod]
        public async Task Inputs_03ConfirmInput()
        {
            await BuildTestFlow()
            .Send(CreateConversationUpdateActivity())
                .AssertReply(String.Format("Welcome to Input Sample Bot.{0}I can show you examples on how to use actions, You can enter number 01-07{0}01 - TextInput{0}02 - NumberInput{0}03 - ConfirmInput{0}04 - ChoiceInput{0}05 - AttachmentInput{0}06 - DateTimeInput{0}07 - OAuthInput{0}", Environment.NewLine))
            .Send("03")
                .AssertReply("yes or no (1) Yes or (2) No")
            .Send("asdasd")
                .AssertReply("I need a yes or no. (1) Yes or (2) No")
            .Send("yes")
                .AssertReply("confirmation: True")
            .StartTestAsync();
        }

        [TestMethod]
        public async Task Inputs_04ChoiceInput()
        {
            await BuildTestFlow()
            .Send(CreateConversationUpdateActivity())
                .AssertReply(String.Format("Welcome to Input Sample Bot.{0}I can show you examples on how to use actions, You can enter number 01-07{0}01 - TextInput{0}02 - NumberInput{0}03 - ConfirmInput{0}04 - ChoiceInput{0}05 - AttachmentInput{0}06 - DateTimeInput{0}07 - OAuthInput{0}", Environment.NewLine)).Send("04")
                .AssertReply("Please select a value from below:\n\n   1. Test1\n   2. Test2\n   3. Test3")
            .Send("Test1")
                .AssertReply("You select: Test1")
            .StartTestAsync();
        }

        [TestMethod]
        public async Task Inputs_06DateTimeInput()
        {
            await BuildTestFlow()
            .Send(CreateConversationUpdateActivity())
               .AssertReply(String.Format("Welcome to Input Sample Bot.{0}I can show you examples on how to use actions, You can enter number 01-07{0}01 - TextInput{0}02 - NumberInput{0}03 - ConfirmInput{0}04 - ChoiceInput{0}05 - AttachmentInput{0}06 - DateTimeInput{0}07 - OAuthInput{0}", Environment.NewLine)).Send("06")
                .AssertReply("Please enter a date.")
            .Send("June 1st 2019")
                .AssertReply("You entered: 2019-06-01")
            .StartTestAsync();
        }

        private TestFlow BuildTestFlow(bool sendTrace = false)
        {
            var storage = new MemoryStorage();
            var convoState = new ConversationState(storage);
            var userState = new UserState(storage);
            var adapter = new TestAdapter(TestAdapter.CreateConversation(TestContext.TestName), sendTrace);
            adapter
                .UseStorage(storage)
                .UseBotState(userState, convoState)
                .Use(new TranscriptLoggerMiddleware(new FileTranscriptLogger()));

            var resource = resourceExplorer.GetResource("askingquestionssample.dialog");
            var dialog = resourceExplorer.LoadType<Dialog>(resource);
            DialogManager dm = new DialogManager(dialog)
                                .UseResourceExplorer(resourceExplorer)
                                .UseLanguageGeneration();

            return new TestFlow(adapter, async (turnContext, cancellationToken) =>
            {
                if (dialog is AdaptiveDialog planningDialog)
                {
                    await dm.OnTurnAsync(turnContext, cancellationToken).ConfigureAwait(false);
                }
            });
        }
    }
}
