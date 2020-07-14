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