using System;
using System.Collections.Generic;
using RockPaperScissor.Core.Model;

namespace RockPaperScissor.Core.Game.Results
{
    public class MatchResult : BaseEntity
    {
        public Competitor Player1 { get; set; }
        public Competitor Player2 { get; set; }
        public MatchOutcome WinningPlayer { get; set; }
        public List<RoundResult> RoundResults { get; set; }

        public bool WasWonBy(Guid competitorId)
        {
            return (Player1.Id == competitorId && WinningPlayer == MatchOutcome.Player1)
                   || (Player2.Id == competitorId && WinningPlayer == MatchOutcome.Player2);
        }

        public bool WasLostBy(Guid competitorId)
        {
            return (Player1.Id == competitorId && WinningPlayer == MatchOutcome.Player2)
                   || (Player2.Id == competitorId && WinningPlayer == MatchOutcome.Player1);
        }
    }
}