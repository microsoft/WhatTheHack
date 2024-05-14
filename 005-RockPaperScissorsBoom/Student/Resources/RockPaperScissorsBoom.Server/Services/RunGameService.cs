using Microsoft.EntityFrameworkCore;
using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Model;
using RockPaperScissorsBoom.Server.Bot;
using RockPaperScissorsBoom.Server.Data;
using RockPaperScissorsBoom.Server.Helpers;
using RockPaperScissorsBoom.Server.Models;
using RockPaperScissorsBoom.Server.Pages;

namespace RockPaperScissorsBoom.Server.Services
{
    public class RunGameService : IRunGameService
    {
        private readonly ApplicationDbContext _db;
        private readonly IMetrics _metrics;
        private readonly IConfiguration _configuration;
        private readonly IMessagingHelper _messageHelper;
        private readonly ILogger<RunGameService> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public event EventHandler<GameRoundCompletedEventArgs>? GameRoundCompleted;

        public RunGameService(ApplicationDbContext db, 
            IMetrics metrics,
            IConfiguration configuration,
            IMessagingHelper messagingHelper,
            ILogger<RunGameService> logger,
            IHttpContextAccessor httpContextAccessor)
        {
            _db = db;
            _metrics = metrics;
            _configuration = configuration;
            _messageHelper = messagingHelper;
            _logger = logger;
            _httpContextAccessor = httpContextAccessor;
        }

        public List<GameRecord> GetGameRecords()
        {
            return _db.GameRecords
                .OrderByDescending(g => g.GameDate).Take(10)
                .Include(g => g.BotRecords)
                .ThenInclude(b => b.Competitor)
                .ToList();
        }

        public async Task<GameResults> RunGameAsync()
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

            List<BotRecord> botRankings = gameRunnerResult.GameRecord.BotRecords.OrderByDescending(x => x.Wins).ToList();

            var returnValue = new GameResults(botRankings: botRankings, 
                allFullResults: gameRunnerResult.AllMatchResults.OrderBy(x => x.Competitor.Name).ToList(), 
                gameRecords: GetGameRecords());
           
            if (bool.Parse(_configuration["EventGridOn"] ?? "false"))
            {
                await PublishMessage(botRankings.First().GameRecord?.Id.ToString() ?? "", botRankings.First().Competitor?.Name ?? "");
            }

            return returnValue;
        }

        private void GameRunner_GameRoundCompleted(object? sender, GameRoundCompletedEventArgs e)
        {
            GameRoundCompleted?.Invoke(sender, e);
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

        private async Task PublishMessage(string GameId, string Winner)
        {
            var msg = new GameMessage
            {
                GameId = GameId,
                Winner = Winner,
                Hostname = _httpContextAccessor.HttpContext?.Request.Host.Host,
                TeamName = _configuration["HackTeamName"]
            };
            await _messageHelper.PublishMessageAsync("RockPaperScissors.GameWinner.RunTheGamePage", "Note", DateTime.UtcNow, msg);
        }
    }
}
