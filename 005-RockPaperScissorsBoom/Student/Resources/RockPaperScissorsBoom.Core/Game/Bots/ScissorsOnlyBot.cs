using Microsoft.Extensions.Logging;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Core.Game.Bots
{
    public class ScissorsOnlyBot : BaseBot
    {
        public ScissorsOnlyBot(Competitor competitor, ILogger logger) : base(competitor, logger)
        {
        }
        public async override Task<Decision> GetDecisionAsync(PreviousDecisionResult? previousResult)
        {
            return await Task.Run(() => Decision.Scissors);
        }
    }
}