using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Game.Results;

namespace UnitTests.Fakes
{
    public class FakeBot : BaseBot
    {
        private readonly Decision _decision;

        public FakeBot(Decision decision, int dynamiteUsed = 0)
        {
            _decision = decision;
            DynamiteUsed = dynamiteUsed;
        }

        public override Decision GetDecision(PreviousDecisionResult previousResult)
        {
            return _decision;
        }
    }
}