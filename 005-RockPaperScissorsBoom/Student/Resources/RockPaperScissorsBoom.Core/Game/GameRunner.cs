using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Core.Game
{
    public class GameRunner
    {
        private readonly List<BaseBot> _competitors = new();
        private readonly IMetrics metrics;

        public event EventHandler<GameRoundCompletedEventArgs>? GameRoundCompleted;

        public GameRunner(IMetrics metrics)
        {
            this.metrics = metrics;
        }

        public async Task<GameRunnerResult> StartAllMatches()
        {
            var matchRunner = new MatchRunner(metrics);
            var matchResults = new List<MatchResult>();

            int totalGames = (_competitors.Count * _competitors.Count) - _competitors.Count;
            int gameNumber = 0;

            //for (int i = 0; i < _competitors.Count; i++)
            foreach (var competitor1 in _competitors)
            {
                //  for (int j = i + 1; j < _competitors.Count; j++)
                foreach (var competitor2 in _competitors)
                {
                    if (competitor1.Name == competitor2.Name)
                    {
                        continue;
                    }
                    var matchResult = await matchRunner.RunMatch(competitor1, competitor2);
                    OnGameRoundCompleted(new GameRoundCompletedEventArgs(matchResult, gameNumber, totalGames));
                    matchResults.Add(matchResult);
                    gameNumber++;
                }
            }

            var gameRunnerResult = GetBotRankingsFromMatchResults(matchResults);
            return gameRunnerResult;
        }

        public GameRunnerResult GetBotRankingsFromMatchResults(List<MatchResult> matchResults)
        {
            var gameRecord = new GameRecord();

            foreach (BaseBot bot in _competitors)
            {
                int wins = matchResults.Count(x => x.WasWonBy(bot.Id));
                int losses = matchResults.Count(x => x.WasLostBy(bot.Id));
                int ties = matchResults.Count(x => (x.Player1.Id == bot.Id || x.Player2.Id == bot.Id) && x.WinningPlayer == MatchOutcome.Tie);

                gameRecord.BotRecords.Add(new BotRecord(
                    gameRecord,
                    bot.Competitor,
                    wins,
                    losses,
                    ties
                ));
            }

            List<FullResults> allMatchResults = GetFullResultsByPlayer(matchResults);
            return new GameRunnerResult(gameRecord, allMatchResults);
        }

        private static List<FullResults> GetFullResultsByPlayer(List<MatchResult> matchResults)
        {
            var player1s = matchResults.Select(x => x.Player1).Distinct();
            var player2s = matchResults.Select(x => x.Player2).Distinct();

            var competitors = player1s.Union(player2s).ToList();

            List<FullResults> allMatchResults = new();
            foreach (Competitor? competitor in competitors)
            {
                var collection = matchResults.Where(x => x.Player1 == competitor || x.Player2 == competitor).ToList();
                allMatchResults.Add(new FullResults(competitor, collection));
            }

            return allMatchResults;
        }

        public void AddBot(BaseBot bot)
        {
            _competitors.Add(bot);
        }

        protected virtual void OnGameRoundCompleted(GameRoundCompletedEventArgs e)
        {
            GameRoundCompleted?.Invoke(this, e);
        }
    }

    public class GameRoundCompletedEventArgs : EventArgs
    {
        public MatchResult MatchResult { get; }

        public int GameNumber { get; }
        public int TotalGames { get; }

        public GameRoundCompletedEventArgs(MatchResult matchResult, int gameNumber, int totalGames)
        {
            MatchResult = matchResult;
            GameNumber = gameNumber;
            TotalGames = totalGames;
        }
    }
}