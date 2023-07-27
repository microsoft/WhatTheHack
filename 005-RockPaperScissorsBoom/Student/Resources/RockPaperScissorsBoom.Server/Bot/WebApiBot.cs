using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;
using System.Text.Json;

namespace RockPaperScissorsBoom.Server.Bot
{
    public class WebApiBot : BaseBot
    {
        private readonly string _apiRootUrl;

        private readonly IHttpClientFactory _httpClientFactory;

        public WebApiBot(string apiRootUrl, IHttpClientFactory httpClientFactory, Competitor competitor, ILogger logger) : base(competitor, logger)
        {
            _apiRootUrl = apiRootUrl;
            _httpClientFactory = httpClientFactory;
        }

        public async override Task<Decision> GetDecisionAsync(PreviousDecisionResult previousResult)
        {
            using HttpClient client = _httpClientFactory.CreateClient();

            HttpResponseMessage result = await client.PostAsJsonAsync(_apiRootUrl, previousResult);
            string rawBotChoice = await result.Content.ReadAsStringAsync();
            BotChoice? botChoice = JsonSerializer.Deserialize<BotChoice>(rawBotChoice);
            return botChoice?.Decision ?? throw new Exception("Didn't get BotChoice back from web api call.");
        }
    }
}