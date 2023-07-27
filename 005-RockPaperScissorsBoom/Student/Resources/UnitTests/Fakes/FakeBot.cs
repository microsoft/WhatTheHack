using Microsoft.Extensions.Logging;
using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace UnitTests.Fakes
{
    public class FakeBot : BaseBot
    {
        private readonly Decision _decision;

        public FakeBot(Decision decision, ILogger logger, int dynamiteUsed = 0) : base(new Competitor("", ""), logger)
        {
            _decision = decision;
            DynamiteUsed = dynamiteUsed;
        }

        public async override Task<Decision> GetDecisionAsync(PreviousDecisionResult previousResult)
        {
            return await Task.Run(() => _decision);
        }
    }
}