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