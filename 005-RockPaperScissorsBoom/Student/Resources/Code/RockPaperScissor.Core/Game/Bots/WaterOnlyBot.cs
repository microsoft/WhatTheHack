using RockPaperScissor.Core.Game.Results;

namespace RockPaperScissor.Core.Game.Bots
{
    public class WaterOnlyBot : BaseBot
    {
        public override Decision GetDecision(PreviousDecisionResult previousResult) => Decision.WaterBalloon;
    }
}