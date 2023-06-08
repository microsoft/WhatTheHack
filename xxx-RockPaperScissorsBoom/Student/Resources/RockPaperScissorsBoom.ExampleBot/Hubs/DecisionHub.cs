using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.SignalR;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Game.Results;

namespace RockPaperScissorsBoom.ExampleBot.Hubs
{
    public class DecisionHub : Hub
    {
        public async Task RequestMove(PreviousDecisionResult previousDecision)
        {
            var cleverBot = new CleverBot();
            Decision decision = cleverBot.GetDecision(previousDecision);
            await Clients.All.SendAsync("MakeDecision", decision);
        }
    }
}