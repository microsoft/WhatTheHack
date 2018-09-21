## 3_LUIS:
Estimated Time: 10-15 minutes

Our bot is now capable of taking in a user's input, calling Azure Search, and returning the results in a carousel of Hero cards. Unfortunately, our bot's communication skills are brittle. One typo, or a rephrasing of words, and the bot will not understand. This can cause frustration for the user. We can greatly increase the bot's conversation abilities by enabling it to understand natural language with the LUIS model we built yesterday in "lab01.5-luis."  

We will have to update our bot in order to use LUIS.  We can do this by modifying "Startup.cs" and "RootTopic.cs."

### Lab 3.1: Adding LUIS to Startup.cs

Open "Startup.cs" and find where you added middleware to use the RegEx recognizer middleware. Since we want to call LUIS **after** we call RegEx, we'll put the LUIS recognizer middleware below. Add the following under the comment "Add LUIS ability below":
```csharp
                middleware.Add(new LuisRecognizerMiddleware(
                    new LuisModel("luisAppId", "subscriptionId", new Uri("luisModelBaseUrl"))));
```
Use the app ID, subscription ID, and base URI for your LUIS model. The base URI will be "https://region.api.cognitive.microsoft.com/luis/v2.0/apps/", where region is the region associated with the key you are using. Some examples of regions are, `westus`, `westcentralus`, `eastus2`, and `southeastasia`.  

You can find your base URL by logging into www.luis.ai, going to the **Publish** tab, and looking at the **Endpoint** column under **Resources and Keys**. The base URL is the portion of the **Endpoint URL** before the subscription ID and other parameters.  

**Hint**: The LUIS App ID will have hyphens in it, and the LUIS key will not.  

You may get some errors for `LuisrecognizerMiddleware`, `LuisModel` and `Uri`. Address them before continuing.

**Hint**: You're missing a `using` statement for the LUIS library and a `using` statement for the System library.

### Lab 3.2: Adding LUIS to RootTopic.cs

Open "RootTopic.cs." There's no need for us to add anything to StartTopic, because regardless of user input, we want to greet the user when the conversation starts.  

In ContinueTopic, we do want to start by trying Regex, so we'll leave most of that. However, if Regex doesn't find an intent, we want the `default` action to be different. That's when we want to call LUIS.  

Replace:
```csharp
                        default:
                            // adding app logic when Regex doesn't find an intent 
                            // respond saying we don't know
                            await RootResponses.ReplyWithConfused(context);
                            return true;
                    }
```
With:
```csharp
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
```
Address the `LuisRecognizerMiddleware`, `JObject`, `JsonConvert`, and `Uri` errors by adding the necessary `using` statements.  

Let's briefly go through what we're doing in the new code additions. First, instead of responding saying we don't understand, we're going to call LUIS. So we call LUIS using the LUIS Recognizer Middleware, and we store the Top Intent in a variable. We then use `switch` to respond in different ways, depending on which intent is picked up. This is almost identical to what we did with Regex.  

> Note: If you named your intents differently in LUIS than instructed in "lab01.5-luis", you need to modify the `case` statements accordingly. 

Another thing to note is that after every response that called LUIS, we're adding the LUIS intent value and score. The reason is just to show you when LUIS is being called as opposed to Regex (you would remove these responses from the final product, but it's a good indicator for us as we test the bot).  

Bring your attention to `case "SearchPics"`. Here, we check if LUIS also returned an entity, specifically the "facet" entity. If LUIS doesn't find the "facet," we take the user through the search topic, so we can determine what they want to search for and give them the results.  

If LUIS does determine a "facet" entity from the utterance, we don't want to take the users through the whole search topic. We want to be efficient so the user has a good experience. So we'll go ahead and process their search request. `ProceedWithSearchAsync` does just that.  

At the bottom of the class, but still within the class, add the following:
```csharp
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
``` 
This code should look very familiar to you. It's quite similar to the `ProcessSearchAsync` method in the search topic. Can you spot the differences and why they are there? Don't forget to add your search service information.  

Hit F5 to run the app. In the Bot Emulator, try sending the bots different ways of searching pictures. What happens when you say "search pics" or "send me pictures of water"? Try some other ways of searching, sharing and ordering pictures.  

If you have extra time, see if there are things LUIS isn't picking up on that you expected it to. Maybe now is a good time to go to luis.ai, [review your endpoint utterances](https://docs.microsoft.com/en-us/azure/cognitive-services/LUIS/label-suggested-utterances), and retrain/republish your model. 


> Fun Aside: Reviewing the endpoint utterances can be extremely powerful.  LUIS makes smart decisions about which utterances to surface.  It chooses the ones that will help it improve the most to have manually labeled by a human-in-the-loop.  For example, if the LUIS model predicted that a given utterance mapped to Intent1 with 47% confidence and predicted that it mapped to Intent2 with 48% confidence, that is a strong candidate to surface to a human to manually map, since the model is very close between two intents.  


**Extra credit (to complete later):** Create and configure a "web.config" file to store your search service information. Next, change the code in RootTopic.cs and SearchTopic.cs to call the settings in web.config, so you don't have to enter them twice.

**Extra credit (to complete later)**: Create a process for ordering prints with the bot using topics, responses, and models.  Your bot will need to collect the following information: Photo size (8x10, 5x7, wallet, etc.), number of prints, glossy or matte finish, user's phone number, and user's email. The bot will then want to send you a confirmation before submitting the request.


Get stuck? You can find the solution for this lab under [resources/code/FinishedPictureBot-Part3](./resources/code/FinishedPictureBot-Part3).


### Continue to [4_Publish_and_Register](./4_Publish_and_Register.md)  
Back to [README](./0_README.md)
