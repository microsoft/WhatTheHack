namespace RockPaperScissorsBoom.Core.Game.Results
{
    public class PreviousDecisionResult
    {
        public Guid MatchId { get; set; }
        public RoundOutcome? Outcome { get; set; }
        public Decision? YourPrevious { get; set; }
        public Decision? OpponentPrevious { get; set; }

        public PreviousDecisionResult(Guid matchId)
        {
            MatchId = matchId;
        }
    }
}