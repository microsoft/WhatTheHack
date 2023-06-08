using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Game.Results;
using RockPaperScissor.Core.Model;
using System.Collections.Generic;
using System.Linq;

namespace RockPaperScissor.Core.Game
{
    public class MatchRunner
    {
        private readonly IMetrics metrics;

        public MatchRunner(IMetrics metrics)
        {
            this.metrics = metrics;
        }
        public MatchResult RunMatch(BaseBot player1, BaseBot player2)
        {
            var roundResults = new List<RoundResult>();
            var roundRunner = new RoundRunner();
            var matchResult = new MatchResult
            {
                Player1 = player1.Competitor,
                Player2 = player2.Competitor
            };

            RoundResult previousResult = new RoundResult {MatchResult = matchResult};

            for (int i = 0; i < 100; i++)
            {
                previousResult = roundRunner.RunRound(player1, player2, previousResult, metrics);
                roundResults.Add(previousResult);
            }

            return GetMatchResultFromRoundResults(matchResult, player1, roundResults);
        }

        private MatchResult GetMatchResultFromRoundResults(MatchResult matchResult,
            BaseBot player1, List<RoundResult> roundResults)
        {
            var winner = roundResults.GroupBy(x => x.Winner).OrderByDescending(x => x.Count()).Select(x => x.Key).First();
            if (winner == null)
            {
                matchResult.WinningPlayer = MatchOutcome.Neither;
            }
            else if (Equals(winner, player1.Competitor))
            {
                matchResult.WinningPlayer = MatchOutcome.Player1;
            }
            else
            {
                matchResult.WinningPlayer = MatchOutcome.Player2;
            }

            matchResult.RoundResults = roundResults;

            return matchResult;
        }
    }
}