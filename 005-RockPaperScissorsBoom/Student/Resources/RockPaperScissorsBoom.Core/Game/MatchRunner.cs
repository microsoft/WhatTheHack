using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Core.Game
{
    public class MatchRunner
    {
        private readonly IMetrics metrics;
        public int NumberOfRounds { get; } = 100;

        public MatchRunner(IMetrics metrics)
        {
            this.metrics = metrics;
        }
        public async Task<MatchResult> RunMatch(BaseBot player1, BaseBot player2)
        {
            var roundResults = new List<RoundResult>(NumberOfRounds);
            var matchResult = new MatchResult(player1.Competitor, player2.Competitor);

            RoundResult previousResult = new(matchResult);

            for (int roundNumber = 0; roundNumber < NumberOfRounds; roundNumber++)
            {
                previousResult = await RoundRunner.RunRound(player1, player2, previousResult, metrics);
                roundResults.Add(previousResult);
            }

            matchResult = GetMatchResultFromRoundResults(matchResult, player1, roundResults);

            return matchResult;
        }

        private static MatchResult GetMatchResultFromRoundResults(MatchResult matchResult,
            BaseBot player1, List<RoundResult> roundResults)
        {
            var winner = roundResults.GroupBy(x => x.Winner).OrderByDescending(x => x.Count()).Select(x => x.Key).First();
            if (winner == null)
            {
                matchResult.WinningPlayer = MatchOutcome.Tie;
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