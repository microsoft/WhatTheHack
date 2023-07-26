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

namespace RockPaperScissorsBoom.Server.Pages
{
    public class RunTheGameModel : PageModel
    {
        private readonly ApplicationDbContext _db;
        private readonly IMetrics _metrics;
        private readonly IConfiguration _configuration;
        private readonly IMessagingHelper _messageHelper;
        private readonly ILogger<RunTheGameModel> _logger;
        private readonly IHubContext<ProgressBarHub> _hubContext;

        public List<BotRecord> BotRankings { get; set; } = new List<BotRecord>();
        public List<FullResults> AllFullResults { get; set; } = new List<FullResults>();

        public List<GameRecord> GamesForTable { get; set; } = new List<GameRecord>();

        public RunTheGameModel(ApplicationDbContext db,
            IMetrics metrics,
            IConfiguration configuration,
            IMessagingHelper messageHelper,
            ILogger<RunTheGameModel> logger,
            IHubContext<ProgressBarHub> hubContext)
        {
            _db = db;
            _metrics = metrics;
            _configuration = configuration;
            _messageHelper = messageHelper;
            _logger = logger;
            _hubContext = hubContext;
        }

        public void OnGet()
        {
            AllFullResults = new List<FullResults>();
            GetGamesForTableData();
        }

        private void GetGamesForTableData()
        {
            GamesForTable = _db.GameRecords
                            .OrderByDescending(g => g.GameDate).Take(10)
                            .Include(g => g.BotRecords)
                            .ThenInclude(b => b.Competitor)
                            .ToList();
        }

        public async Task OnPostAsync()
        {
            List<Competitor> competitors = _db.Competitors.ToList();
            if (!competitors.Any())
            {
                competitors = GetDefaultCompetitors();
                _db.Competitors.AddRange(competitors);
                await _db.SaveChangesAsync();
            }

            var gameRunner = new GameRunner(_metrics);
            gameRunner.GameRoundCompleted += GameRunner_GameRoundCompleted;

            foreach (var competitor in competitors)
            {
                BaseBot bot = CreateBotFromCompetitor(competitor);
                gameRunner.AddBot(bot);
            }

            var stopwatch = System.Diagnostics.Stopwatch.StartNew();

            GameRunnerResult gameRunnerResult = await gameRunner.StartAllMatches();

            stopwatch.Stop();

            var metric = new Dictionary<string, double> { { "GameLength", stopwatch.Elapsed.TotalMilliseconds } };

            // Set up some properties:
            var properties = new Dictionary<string, string?> { { "Source", _configuration["HackTeamName"] } };

            // Send the event:
            _metrics.TrackEventDuration("GameRun", properties, metric);

            await SaveResults(gameRunnerResult);
            BotRankings = gameRunnerResult.GameRecord.BotRecords.OrderByDescending(x => x.Wins).ToList();
            AllFullResults = gameRunnerResult.AllMatchResults.OrderBy(x => x.Competitor.Name).ToList();

            GetGamesForTableData();

            if (bool.Parse(_configuration["EventGridOn"] ?? "false"))
            {
                await PublishMessage(BotRankings.First().GameRecord?.Id.ToString() ?? "", BotRankings.First().Competitor?.Name ?? "");
            }
        }

        private void GameRunner_GameRoundCompleted(object? sender, GameRoundCompletedEventArgs e)
        {
            _hubContext.Clients.All.SendAsync("UpdateProgressBar", e.GameNumber, e.TotalGames);
        }

        internal async Task PublishMessage(string GameId, string Winner)
        {
            var msg = new GameMessage
            {
                GameId = GameId,
                Winner = Winner,
                Hostname = HttpContext.Request.Host.Host,
                TeamName = _configuration["HackTeamName"]
            };
            await _messageHelper.PublishMessageAsync("RockPaperScissors.GameWinner.RunTheGamePage", "Note", DateTime.UtcNow, msg);
        }

        private async Task SaveResults(GameRunnerResult gameRunnerResult)
        {
            if (gameRunnerResult.GameRecord.BotRecords.Any())
            {
                _db.GameRecords.Add(gameRunnerResult.GameRecord);
                await _db.SaveChangesAsync();
            }
        }

        private BaseBot CreateBotFromCompetitor(Competitor competitor)
        {
            Type type = Type.GetType(competitor.BotType) ?? throw new Exception($"Could not find type {competitor.BotType}");
            var bot = Activator.CreateInstance(type, competitor, _logger) as BaseBot ?? throw new Exception($"Could not create instance of type {competitor.BotType}");

            if (bot is SignalRBot signalRBot)
            {
                signalRBot.ApiRootUrl = competitor.Url ?? "";
            }

            return bot;
        }

        private static List<Competitor> GetDefaultCompetitors()
        {
            var competitors = new List<Competitor>
            {
                new Competitor("Rocky", typeof(RockOnlyBot).AssemblyQualifiedName ?? ""),
                new Competitor("Treebeard", typeof(PaperOnlyBot).AssemblyQualifiedName ?? ""),
                new Competitor("Sharpy", typeof(ScissorsOnlyBot).AssemblyQualifiedName ?? ""),
                new Competitor("All Washed Up", typeof(WaterOnlyBot).AssemblyQualifiedName ?? ""),
                new Competitor("Clever Bot", typeof(CleverBot).AssemblyQualifiedName ?? ""),
                new Competitor("Smart Bot", typeof(SmartBot).AssemblyQualifiedName ?? ""),
                //new Competitor
                //{
                //    Name = "Signals",
                //    BotType = typeof(SignalRBot).AssemblyQualifiedName,
                //    Url = "https://localhost:44347/decision"
                //},
                new Competitor("Rando Carrisian", typeof(RandomBot).AssemblyQualifiedName ?? "")
            };
            return competitors;
        }
    }
}
