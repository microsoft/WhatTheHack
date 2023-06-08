using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Game.Results;
using RockPaperScissor.Core.Model;
using System.Collections.Generic;
using System.Linq;

namespace RockPaperScissor.Core.Game
{
    public class GameRunner
    {
        public GameRunner(IMetrics metrics)
        {
            this.metrics = metrics;
        }
        private readonly List<BaseBot> _competitors = new List<BaseBot>();
        private readonly IMetrics metrics;

        public GameRunnerResult StartAllMatches()
        {
            var matchRunner = new MatchRunner(metrics);

            var matchResults = new List<MatchResult>();

            for (int i = 0; i < _competitors.Count; i++)
            {
                for (int j = i + 1; j < _competitors.Count; j++)
                {
                    matchResults.Add(matchRunner.RunMatch(_competitors[i], _competitors[j]));
                }
            }

            return GetBotRankingsFromMatchResults(matchResults);
        }

        public GameRunnerResult GetBotRankingsFromMatchResults(List<MatchResult> matchResults)
        {
            var gameRecord = new GameRecord();

            foreach (BaseBot bot in _competitors)
            {
                int wins = matchResults.Count(x => x.WasWonBy(bot.Id));
                int losses = matchResults.Count(x => x.WasLostBy(bot.Id));
                int ties = matchResults.Count(x => x.WinningPlayer == MatchOutcome.Neither);

                gameRecord.BotRecords.Add(new BotRecord
                {
                    GameRecord = gameRecord,
                    Competitor = bot.Competitor,
                    Wins = wins,
                    Losses = losses,
                    Ties = ties
                });
            }

            List<FullResults> allMatchResults = GetFullResultsByPlayer(matchResults);
            return new GameRunnerResult { GameRecord = gameRecord, AllMatchResults = allMatchResults };
        }

        private static List<FullResults> GetFullResultsByPlayer(List<MatchResult> matchResults)
        {
            var player1s = matchResults.Select(x => x.Player1).Distinct();
            var player2s = matchResults.Select(x => x.Player2).Distinct();

            var competitors = player1s.Union(player2s).ToList();

            List<FullResults> allMatchResults = new List<FullResults>();
            foreach (Competitor competitor in competitors)
            {
                var collection = matchResults.Where(x => x.Player1 == competitor || x.Player2 == competitor).ToList();
                allMatchResults.Add(new FullResults { Competitor = competitor, MatchResults = collection });
            }

            return allMatchResults;
        }

        public void AddBot(BaseBot bot)
        {
            _competitors.Add(bot);
        }
    }
}