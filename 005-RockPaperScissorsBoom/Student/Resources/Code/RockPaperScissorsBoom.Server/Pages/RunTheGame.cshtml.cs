using Microsoft.AspNetCore.Mvc.RazorPages;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Model;
using RockPaperScissorsBoom.Server.Bot;
using RockPaperScissorsBoom.Server.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using RockPaperScissorsBoom.Server.Helpers;
using RockPaperScissorsBoom.Server.Models;

namespace RockPaperScissorsBoom.Server.Pages
{
    public class RunTheGameModel : PageModel
    {
        private readonly ApplicationDbContext db;
        private readonly IMetrics metrics;
        private readonly IConfiguration configuration;
        private readonly IMessagingHelper messageHelper;

        public List<BotRecord> BotRankings { get; set; }
        public List<FullResults> AllFullResults { get; set; }

        public List<GameRecord> GamesForTable { get; set; }

        public RunTheGameModel(ApplicationDbContext db, IMetrics metrics, IConfiguration configuration, IMessagingHelper messageHelper)
        {
            this.db = db;
            this.metrics = metrics;
            this.configuration = configuration;
            this.messageHelper = messageHelper;
        }

        public void OnGet()
        {
            GameRecord gameRecord = db.GameRecords
                .Include(x => x.BotRecords)
                .ThenInclude(x => x.Competitor)
                .OrderByDescending(x => x.GameDate)
                .FirstOrDefault();
            BotRankings = gameRecord?.BotRecords ?? new List<BotRecord>();
            AllFullResults = new List<FullResults>();

            GamesForTable = db.GameRecords.OrderByDescending(g => g.GameDate).Take(20).Include(g => g.BotRecords).ToList();
        }

        public async Task OnPostAsync()
        {
            List<Competitor> competitors = db.Competitors.ToList();
            if (!competitors.Any())
            {
                competitors = GetDefaultCompetitors();
                db.Competitors.AddRange(competitors);
                db.SaveChanges();
            }

            var gameRunner = new GameRunner(metrics);
            foreach (var competitor in competitors)
            {
                BaseBot bot = CreateBotFromCompetitor(competitor);
                gameRunner.AddBot(bot);
            }

            var stopwatch = System.Diagnostics.Stopwatch.StartNew();

            GameRunnerResult gameRunnerResult = gameRunner.StartAllMatches();

            stopwatch.Stop();

            var metric = new Dictionary<string, double> { { "GameLength", stopwatch.Elapsed.TotalMilliseconds } };

            // Set up some properties:
            var properties = new Dictionary<string, string> { { "Source", configuration["P20HackFestTeamName"] } };

            // Send the event:
            metrics.TrackEventDuration("GameRun", properties, metric);

            SaveResults(gameRunnerResult);
            BotRankings = gameRunnerResult.GameRecord.BotRecords.OrderByDescending(x => x.Wins).ToList();
            AllFullResults = gameRunnerResult.AllMatchResults.OrderBy(x => x.Competitor.Name).ToList();

            //Get 20 Last 
            GamesForTable = db.GameRecords.OrderByDescending(g => g.GameDate).Take(20).Include(g => g.BotRecords).ToList();

            if (bool.Parse(configuration["EventGridOn"]))
            {
                await PublishMessage(BotRankings.First().GameRecord.Id.ToString(), BotRankings.First().Competitor.Name);
            }
        }

        internal async Task PublishMessage(string GameId, string Winner)
        {
            var msg = new GameMessage
            {
                GameId = GameId,
                Winner = Winner,
                Hostname = this.HttpContext.Request.Host.Host,
                TeamName = this.configuration["P20HackFestTeamName"]
            };
            await messageHelper.PublishMessageAsync("RockPaperScissors.GameWinner.RunTheGamePage", "Note", DateTime.UtcNow, msg);
        }

        private void SaveResults(GameRunnerResult gameRunnerResult)
        {
            if (gameRunnerResult.GameRecord.BotRecords.Any())
            {
                db.GameRecords.Add(gameRunnerResult.GameRecord);
                db.SaveChanges();
            }
        }

        private static BaseBot CreateBotFromCompetitor(Competitor competitor)
        {
            Type type = Type.GetType(competitor.BotType);
            var bot = (BaseBot)Activator.CreateInstance(type);
            if (bot is SignalRBot signalRBot)
            {
                signalRBot.ApiRootUrl = competitor.Url;
            }

            bot.Competitor = competitor;
            return bot;
        }

        private static List<Competitor> GetDefaultCompetitors()
        {
            var competitors = new List<Competitor>
            {
                new Competitor {Name = "Rocky", BotType = typeof(RockOnlyBot).AssemblyQualifiedName},
                new Competitor {Name = "Treebeard", BotType = typeof(PaperOnlyBot).AssemblyQualifiedName},
                new Competitor {Name = "Sharpy", BotType = typeof(ScissorsOnlyBot).AssemblyQualifiedName},
                new Competitor {Name = "All Washed Up", BotType = typeof(WaterOnlyBot).AssemblyQualifiedName},
                new Competitor {Name = "Clever Bot", BotType = typeof(CleverBot).AssemblyQualifiedName},
                new Competitor {Name = "Smart Bot", BotType = typeof(SmartBot).AssemblyQualifiedName},
                //new Competitor
                //{
                //    Name = "Signals",
                //    BotType = typeof(SignalRBot).AssemblyQualifiedName,
                //    Url = "https://localhost:44347/decision"
                //},
                new Competitor {Name = "Rando Carrisian", BotType = typeof(RandomBot).AssemblyQualifiedName}
            };
            return competitors;
        }

    }
}