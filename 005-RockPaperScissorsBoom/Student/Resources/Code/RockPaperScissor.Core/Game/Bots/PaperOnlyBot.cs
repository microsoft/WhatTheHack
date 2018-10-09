using RockPaperScissor.Core.Game.Results;

namespace RockPaperScissor.Core.Game.Bots
{
    public class PaperOnlyBot : BaseBot
    {
        public override Decision GetDecision(PreviousDecisionResult previousResult) => Decision.Paper;
    }
}