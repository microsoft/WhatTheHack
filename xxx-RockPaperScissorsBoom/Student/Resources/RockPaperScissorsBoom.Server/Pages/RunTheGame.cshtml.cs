using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Model;
using RockPaperScissorsBoom.Server.Bot;
using RockPaperScissorsBoom.Server.Data;
using RockPaperScissorsBoom.Server.Helpers;
using RockPaperScissorsBoom.Server.Hubs;
using RockPaperScissorsBoom.Server.Models;
using RockPaperScissorsBoom.Server.Services;

namespace RockPaperScissorsBoom.Server.Pages
{
    public class RunTheGameModel : PageModel
    {
        private readonly IHubContext<ProgressBarHub> _hubContext;
        private readonly IRunGameService _runGameService;

        public List<BotRecord> BotRankings { get; set; } = new List<BotRecord>();
        public List<FullResults> AllFullResults { get; set; } = new List<FullResults>();
        public List<GameRecord> GamesForTable { get; set; } = new List<GameRecord>();

        public RunTheGameModel(
            IHubContext<ProgressBarHub> hubContext,
            IRunGameService runGameService)
        {
            _hubContext = hubContext;
            _runGameService = runGameService;
            _runGameService.GameRoundCompleted += GameRunner_GameRoundCompleted;
        }

        public void OnGet()
        {
            AllFullResults = new List<FullResults>();
            GamesForTable = _runGameService.GetGameRecords();
        }

        public async Task OnPostAsync()
        {
            var gameResults = await _runGameService.RunGameAsync();

            BotRankings = gameResults.BotRankings;
            AllFullResults = gameResults.AllFullResults;
            GamesForTable = gameResults.GameRecords;
        }

        private void GameRunner_GameRoundCompleted(object? sender, GameRoundCompletedEventArgs e)
        {
            _hubContext.Clients.All.SendAsync("UpdateProgressBar", e.GameNumber, e.TotalGames);
        }              
    }
}
