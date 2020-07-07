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
using Microsoft.Bot.Builder.Ai.LUIS;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace PictureBot.Topics
{
    public class RootTopic : ITopic
    {
        public string Name { get; set; } = "Root";

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
                            // adding app logic when Regex doesn't find an intent - consult LUIS
                            var result = context.Services.Get<RecognizerResult>(LuisRecognizerMiddleware.LuisRecognizerResultKey);
                            var topIntent = result?.GetTopScoringIntent();

                            switch ((topIntent != null) ? topIntent.Value.intent : null)
                            {
                                case null:
                                    // Add app logic when there is no result.
                                    await RootResponses.ReplyWithConfused(context);
                                    break;
                                case "None":
                                    await RootResponses.ReplyWithConfused(context);
                                    await RootResponses.ReplyWithLuisScore(context, topIntent.Value.intent, topIntent.Value.score);
                                    break;
                                case "Greeting":
                                    await RootResponses.ReplyWithGreeting(context);
                                    await RootResponses.ReplyWithHelp(context);
                                    await RootResponses.ReplyWithLuisScore(context, topIntent.Value.intent, topIntent.Value.score);
                                    break;
                                case "OrderPic":
                                    await RootResponses.ReplyWithOrderConfirmation(context);
                                    await RootResponses.ReplyWithLuisScore(context, topIntent.Value.intent, topIntent.Value.score);
                                    break;
                                case "SharePic":
                                    await RootResponses.ReplyWithShareConfirmation(context);
                                    await RootResponses.ReplyWithLuisScore(context, topIntent.Value.intent, topIntent.Value.score);
                                    break;
                                case "SearchPics":
                                    // Check if LUIS has identified the search term that we should look for.  
                                    var entity = result?.Entities;
                                    var obj = JObject.Parse(JsonConvert.SerializeObject(entity)).SelectToken("facet");
                                    // if no entities are picked up on by LUIS, go through SearchTopic
                                    if (obj == null)
                                    {
                                        conversation.ActiveTopic = new SearchTopic();
                                        await RootResponses.ReplyWithLuisScore(context, topIntent.Value.intent, topIntent.Value.score);
                                    }
                                    // if entities are picked up by LUIS, skip SearchTopic and process the search
                                    else
                                    {
                                        facet = obj.ToString().Replace("\"", "").Trim(']', '[', ' ');
                                        await ProceedWithSearchAsync(context, facet);
                                        await RootResponses.ReplyWithLuisScore(context, topIntent.Value.intent, topIntent.Value.score);
                                        break;
                                    }
                                    return await conversation.ActiveTopic.StartTopic(context);
                                default:
                                    await RootResponses.ReplyWithConfused(context);
                                    break;
                            }
                            return true;
                    }
            }
            return true;
        }

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

        // below tasks are required to process the search text and return the results     
        public async Task<bool> ProceedWithSearchAsync(ITurnContext context, string facet)
        {
            var userState = context.GetUserState<UserData>();
            await SearchResponses.ReplyWithSearchConfirmation(context, facet);
            await StartAsync(context, facet);
            //end topic
            return true;
        }

        public async Task StartAsync(ITurnContext context, string facet)
        {
            ISearchIndexClient indexClientForQueries = CreateSearchIndexClient();

            // For more examples of calling search with SearchParameters, see
            // https://github.com/Azure-Samples/search-dotnet-getting-started/blob/master/DotNetHowTo/DotNetHowTo/Program.cs.  

            DocumentSearchResult results = await indexClientForQueries.Documents.SearchAsync(facet);
            await SendResultsAsync(context, results);
        }

        public async Task SendResultsAsync(ITurnContext context, DocumentSearchResult results)
        {
            IMessageActivity activity = context.Activity.CreateReply();

            if (results.Results.Count == 0)
            {
                await SearchResponses.ReplyWithNoResults(context, facet);
            }
            else
            {
                SearchHitStyler searchHitStyler = new SearchHitStyler();
                searchHitStyler.Apply(
                    ref activity,
                    "Here are the results that I found:",
                    results.Results.Select(r => ImageMapper.ToSearchHit(r)).ToList().AsReadOnly());
                await context.SendActivity(activity);
            }
        }

        public ISearchIndexClient CreateSearchIndexClient()
        {
            // replace "YourSearchServiceName" and "YourSearchServiceKey" with your search service values
            string searchServiceName = "YourSearchServiceName";
            string queryApiKey = "YourSearchServiceKey";
            string indexName = "images";
            // if you named your index "images" as instructed, you do not need to change this value

            SearchIndexClient indexClient = new SearchIndexClient(searchServiceName, indexName, new SearchCredentials(queryApiKey));
            return indexClient;
        }
    }
}