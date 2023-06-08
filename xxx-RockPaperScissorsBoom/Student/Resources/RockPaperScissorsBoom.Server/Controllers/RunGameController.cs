using System;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using RockPaperScissorsBoom.Server.Data;
using RockPaperScissorsBoom.Server.Pages;
using RockPaperScissor.Core.Model;
using RockPaperScissor.Core.Game.Results;
using System.Collections.Generic;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissorsBoom.Server.Bot;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using RockPaperScissorsBoom.Server.Helpers;
using RockPaperScissorsBoom.Server.Models;

namespace RockPaperScissorsBoom.Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RunGameController : ControllerBase
    {
        private readonly ApplicationDbContext db;
        private readonly IMetrics metrics;
        private readonly IConfiguration configuration;
        private readonly IMessagingHelper messageHelper;

        public RunGameController(ApplicationDbContext db, IMetrics metrics, IConfiguration configuration, IMessagingHelper messageHelper)
        {
            this.db = db;
            this.metrics = metrics;
            this.configuration = configuration;
            this.messageHelper = messageHelper;
        }

        [HttpPost]
        public async Task<string> PostAsync()
        {
            List<Competitor> competitors = db.Competitors.ToList();

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
            var winner = gameRunnerResult.AllMatchResults.Select(x => x.MatchResults).First().First().Player1.Name;

            if (bool.Parse(configuration["EventGridOn"]))
            {
                await PublishMessage(gameRunnerResult.GameRecord.Id.ToString(), winner);
            }
            return gameRunnerResult.AllMatchResults.Select(x => x.MatchResults).First().First().Player1.Name;
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
            await messageHelper.PublishMessageAsync("RockPaperScissors.GameWinner.RunGameController", "Note", DateTime.UtcNow, msg);
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
    }
}