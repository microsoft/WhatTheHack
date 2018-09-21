## 2_Azure_Search:
Estimated Time: 10-15 minutes

We now have a bot that can communicate with us if we use very specific words. The next thing we need to do is set up a connection to the Azure Search index we created in "challenge2.1-azure_search." 

### Lab 2.1: Update the bot to use Azure Search

First, we need to update "SearchTopic.cs" so to request a search and process the response. We'll have to call Azure Search here, so make sure you've added the NuGet package (you should have done this in an earlier lab, but here's a friendly reminder).

![Azure Search NuGet](./resources/assets/AzureSearchNuGet.jpg) 

Open "SearchTopic.cs" and replace the contents of the class with the following code:
```csharp
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
    

    }
```
When we start the search topic, the first thing we need to do is ask the user, if we haven't already, what they want to search for. If we've already asked them, we want to wait for their response and continue the topic. The logic is very similar to greeting the user if they haven't been greeted yet. Review the code for `StartTopic` and confirm you understand.  

You may have noticed that `ITopic` and `ContinueTopic` are throwing errors. Just as when we initially created SearchTopic, we have to have StartTopic, ContinueTopic, and ResumeTopic, because that's how we configured ITopic. So the errors are due to the fact that we haven't added ContinueTopic or ResumeTopic back yet.  

Let's add them now:

```csharp
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


```

In ContinueTopic, you can see that we're gathering the context of the conversation, waiting for the results of the ProcessSearchAsync method, and finally starting a new root topic.

In order to process the search, there are several tasks we need to accomplish:
1.  Establish a connection to the search service
2.  Store the search request and tell the user what we're searching for
3.  Call the search service and store the results
4.  Put the results in a message and respond to the user

Discuss with a neighbor which methods below accomplish which tasks above, and how:
```csharp
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
```

Now that you understand which piece does what and why, add the code below the comment "Add ProcessSearchAsync below" within SearchTopic.cs.  

Set the value for the "YourSearchServiceName" to be the name of the Azure Search Service that you created earlier.  If needed, go back and look this up in the [Azure portal](https://portal.azure.com).  

Set the value for the "YourSearchServiceKey" to be the key for this service.  This can be found in the [Azure portal](https://portal.azure.com) under the Keys section for your Azure Search.  In the below screenshot, the SearchDialogsServiceName would be "aiimmersionsearch" and the SearchDialogsServiceKey would be "375...".  

![Azure Search Settings](./resources/assets/AzureSearchSettings.jpg) 

Finally, the SearchIndexName should be "images," but you may want to confirm that this is what you named your index.  




Press F5 to run your bot again.  In the Bot Emulator, try searching for something like "dogs" or "water".  Ensure that you are seeing results when tags from your pictures are requested.  

Get stuck? You can find the solution for this lab under [resources/code/FinishedPictureBot-Part2](./resources/code/FinishedPictureBot-Part2).  

### Continue to [3_LUIS](./3_LUIS.md)  
Back to [README](./0_README.md)
