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
                            // adding app logic when Regex doesn't find an intent 
                            // respond saying we don't know
                            await RootResponses.ReplyWithConfused(context);
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

    }
}