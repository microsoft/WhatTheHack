using Microsoft.AspNetCore.SignalR;
using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;
using RockPaperScissorsBoom.Core.SignalRBot;

namespace RockPaperScissorsBoom.ExampleBot.Hubs
{
    public class DecisionHub : Hub<ISignalRBotClient>, ISignalRBotServer
    {
        readonly ILogger<DecisionHub> _logger;
        public DecisionHub(ILogger<DecisionHub> logger)
        {
            _logger = logger;
        }

        //TODO: Implement your bot here
        public async Task RequestMoveAsync(PreviousDecisionResult previousDecisionResult)
        {
            var cleverBot = new CleverBot(new Competitor("ExampleBot", "ExampleBot"), _logger);

            var decision = await cleverBot.GetDecisionAsync(previousDecisionResult);
            _logger.LogInformation("Decision: {decision}", decision);

            await Clients.Caller.MakeDecisionAsync(decision);
        }
    }
}
