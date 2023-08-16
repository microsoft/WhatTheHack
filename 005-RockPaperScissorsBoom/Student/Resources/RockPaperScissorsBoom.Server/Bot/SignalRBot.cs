using Microsoft.AspNetCore.SignalR.Client;
using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;
using RockPaperScissorsBoom.Core.SignalRBot;

namespace RockPaperScissorsBoom.Server.Bot
{
    public class SignalRBot : BaseBot
    {
        private HubConnection? _connection;
        private TaskCompletionSource<Decision>? _response;

        public string ApiRootUrl { get; set; }

        public SignalRBot(Competitor competitor, ILogger logger) : base(competitor, logger)
        {
            ApiRootUrl = competitor.Url ?? "";
        }

        private async Task InitializeConnection()
        {
            if (_connection != null)
                return;

            _connection = new HubConnectionBuilder()
                .WithUrl(ApiRootUrl)
                .Build();

            _logger.LogInformation("Connecting to SignalRBot at {ApiRootUrl}...", ApiRootUrl);

            try
            {
                await _connection.StartAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Unable to connect to SignalRBot at {ApiRootUrl}.", ApiRootUrl);
                _connection = null;
                throw;
            }

            _connection.On<Decision>(nameof(ISignalRBotClient.MakeDecisionAsync), (decision) =>
            {
                _response?.SetResult(decision);
            });
        }

        public override async Task<Decision> GetDecisionAsync(PreviousDecisionResult previousResult)
        {
            if (_connection == null || _connection.State != HubConnectionState.Connected)
            {
                await InitializeConnection();
            }

            if (_connection != null && _connection.State == HubConnectionState.Connected)
            {
                _response = new TaskCompletionSource<Decision>(TaskCreationOptions.RunContinuationsAsynchronously);

                try
                {
                    await _connection.InvokeAsync(nameof(ISignalRBotServer.RequestMoveAsync), previousResult);
                }
                catch (Exception ex)
                {
                    throw new Exception($"Unable to get a decision from SignalRBot at {ApiRootUrl}.", ex);
                }

                return await _response.Task;
            }

            throw new Exception($"Unable to connect to SignalRBot at {ApiRootUrl}.");
        }
    }
}