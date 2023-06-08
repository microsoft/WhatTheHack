using RockPaperScissor.Core.Game.Results;

namespace RockPaperScissor.Core.Game.Bots
{
    public class RockOnlyBot : BaseBot
    { 
        public override Decision GetDecision(PreviousDecisionResult previousResult) => Decision.Rock;
    }
}