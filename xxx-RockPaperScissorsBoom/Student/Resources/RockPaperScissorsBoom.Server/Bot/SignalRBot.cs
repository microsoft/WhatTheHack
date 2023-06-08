using Microsoft.AspNetCore.SignalR.Client;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Game.Results;

namespace RockPaperScissorsBoom.Server.Bot
{
    public class SignalRBot : BaseBot
    {
        private HubConnection _connection;
        private Decision? _decision = null;

        public string ApiRootUrl { get; set; }

        private void InitializeConnection()
        {
            if (_connection != null) return;

            _connection = new HubConnectionBuilder()
                .WithUrl(ApiRootUrl)
                .Build();
            _connection.StartAsync().Wait();

            _connection.On<Decision>("MakeDecision", (decision) =>
            {
                _decision = decision;
            });

        }

        public override Decision GetDecision(PreviousDecisionResult previousResult)
        {
            if (_connection == null) InitializeConnection();

            _connection.InvokeAsync("RequestMove", previousResult);

            while (_decision == null)
            {
            }

            var decisionToReturn = _decision;
            _decision = null;
            return decisionToReturn.Value;
        }
    }
}