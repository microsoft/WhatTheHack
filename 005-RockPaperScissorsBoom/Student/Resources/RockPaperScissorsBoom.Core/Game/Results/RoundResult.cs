using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Core.Game.Results
{
    public class RoundResult : BaseEntity
    {
        public MatchResult MatchResult { get; set; }
        public Competitor? Winner { get; set; }
        public Competitor? Player1 { get; set; }
        public Competitor? Player2 { get; set; }
        public Decision? Player1Played { get; set; }
        public Decision? Player2Played { get; set; }

        public RoundResult(MatchResult matchResult)
        {
            MatchResult = matchResult;
        }

        public RoundResult(MatchResult matchResult, Competitor? winner, Competitor player1, Competitor player2, Decision player1Played,
                       Decision player2Played)
        {
            MatchResult = matchResult;
            Winner = winner;
            Player1 = player1;
            Player2 = player2;
            Player1Played = player1Played;
            Player2Played = player2Played;
        }

        public PreviousDecisionResult ToPlayerSpecific(BaseBot bot)
        {
            var result = new PreviousDecisionResult(MatchResult.Id);

            if (Winner == null)
            {
                result.Outcome = RoundOutcome.Tie;
            }
            else if (Equals(bot.Competitor, Winner))
            {
                result.Outcome = RoundOutcome.Win;
            }
            else
            {
                result.Outcome = RoundOutcome.Loss;
            }

            if (Equals(bot.Competitor, Player1))
            {
                result.YourPrevious = Player1Played;
                result.OpponentPrevious = Player2Played;
            }
            else
            {
                result.YourPrevious = Player2Played;
                result.OpponentPrevious = Player1Played;
            }

            return result;
        }
    }
}