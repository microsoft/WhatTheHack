using System;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Model;

namespace RockPaperScissor.Core.Game.Results
{
    public class RoundResult : BaseEntity
    {
        public MatchResult MatchResult { get; set; }
        public Competitor Winner { get; set; }
        public Competitor Player1 { get; set; }
        public Competitor Player2 { get; set; }
        public Decision Player1Played { get; set; }
        public Decision Player2Played { get; set; }

        public PreviousDecisionResult ToPlayerSpecific(BaseBot bot)
        {
            var result = new PreviousDecisionResult { MatchId = MatchResult.Id };

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