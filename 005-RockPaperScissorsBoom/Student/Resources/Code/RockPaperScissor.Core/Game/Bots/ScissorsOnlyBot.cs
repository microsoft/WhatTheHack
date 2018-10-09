using RockPaperScissor.Core.Game.Results;

namespace RockPaperScissor.Core.Game.Bots
{
    public class ScissorsOnlyBot : BaseBot
    {
        public override Decision GetDecision(PreviousDecisionResult previousResult) => Decision.Scissors;
    }
}