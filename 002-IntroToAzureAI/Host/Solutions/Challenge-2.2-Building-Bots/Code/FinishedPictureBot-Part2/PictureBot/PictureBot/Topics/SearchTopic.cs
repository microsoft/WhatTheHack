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
    public class SearchTopic : ITopic
    {
        public string Name { get; set; } = "Search";
        // Search object representing the information being gathered by the conversation before it is submitted to search
        public string searchText;
        // Track in this topic if we have asked the user what they want to search for
        public bool RequestedForSearch { get; set; } = false;

        public async Task<bool> StartTopic(ITurnContext context)
        {
            switch (context.Activity.Type)
            {
                case ActivityTypes.Message:
                    {
                        // Ask them what they want to search for if we haven't already
                        if (!RequestedForSearch)
                        {
                            await SearchResponses.ReplyWithSearchRequest(context);
                            // Now that we've asked, set to true, so we don't ask again 
                            this.RequestedForSearch = true;
                            return true;
                        }
                        return true;
                    }
                default:
                    break;
            }
            return await this.ContinueTopic(context);
        }

        // Add ContinueTopic and ReviewTopic below
        public async Task<bool> ContinueTopic(ITurnContext context)
        {
            var conversation = ConversationState<ConversationData>.Get(context);

            // Process the search request and send the results to the user
            await ProcessSearchAsync(context);
            // Then go back to the root topic
            conversation.ActiveTopic = new RootTopic();
            return false;
        }


        public async Task<bool> ResumeTopic(ITurnContext context)
        {
            await RootResponses.ReplyWithResumeTopic(context);
            return true;
        }

        // Add ProcessSearchAsync below
        // below tasks are required to process the search text and return the results
        public async Task<bool> ProcessSearchAsync(ITurnContext context)
        {
            // store the users response
            searchText = (context.Activity.Text ?? "").Trim();
            var userState = context.GetUserState<UserData>();
            await SearchResponses.ReplyWithSearchConfirmation(context, searchText);
            await StartAsync(context);
            return true;
        }

        public async Task StartAsync(ITurnContext context)
        {
            ISearchIndexClient indexClientForQueries = CreateSearchIndexClient();
            // For more examples of calling search with SearchParameters, see
            // https://github.com/Azure-Samples/search-dotnet-getting-started/blob/master/DotNetHowTo/DotNetHowTo/Program.cs.  
            // Call the search service and store the results
            DocumentSearchResult results = await indexClientForQueries.Documents.SearchAsync(searchText);
            await SendResultsAsync(context, results);
        }

        public async Task SendResultsAsync(ITurnContext context, DocumentSearchResult results)
        {
            IMessageActivity activity = context.Activity.CreateReply();
            // if the search returns no results
            if (results.Results.Count == 0)
            {
                await SearchResponses.ReplyWithNoResults(context, searchText);
            }
            else // this means there was at least one hit for the search
            {
                // create the response with the result(s) and send to the user
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
            // Configure the search service and establish a connection, call it in StartAsync()
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