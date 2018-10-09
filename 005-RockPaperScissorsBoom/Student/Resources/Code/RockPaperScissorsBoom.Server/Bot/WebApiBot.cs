using System;
using System.Net.Http;
using Newtonsoft.Json;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Game.Results;
using RockPaperScissor.Core.Model;

namespace RockPaperScissorsBoom.Server.Bot
{
    public class WebApiBot : BaseBot
    {
        private readonly string _apiRootUrl;

        private readonly IHttpClientFactory _httpClientFactory;

        public WebApiBot(string apiRootUrl, IHttpClientFactory httpClientFactory)
        {
            _apiRootUrl = apiRootUrl;
            _httpClientFactory = httpClientFactory;
        }

        public override Decision GetDecision(PreviousDecisionResult previousResult)
        {
            using (HttpClient client = _httpClientFactory.CreateClient())
            {
                var result = client.PostAsJsonAsync(_apiRootUrl, previousResult).Result;
                //string rawBotChoice = client.GetStringAsync(_apiRootUrl).Result;
                string rawBotChoice = result.Content.ReadAsStringAsync().Result;
                BotChoice botChoice = JsonConvert.DeserializeObject<BotChoice>(rawBotChoice);
                return botChoice?.Decision ?? throw new Exception("Didn't get BotChoice back from web api call.");
            }
        }
    }
}