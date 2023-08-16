using Microsoft.Extensions.Logging;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Core.Game.Bots
{
    public class RandomBot : BaseBot
    {
        public RandomBot(Competitor competitor, ILogger logger) : base(competitor, logger)
        {
        }
        public async override Task<Decision> GetDecisionAsync(PreviousDecisionResult previousResult)
        {
            return await Task.Run(() =>
            {
                var decisions = new List<Decision> {
                    Decision.Dynamite,
                    Decision.Paper,
                    Decision.Rock,
                    Decision.Scissors,
                    Decision.WaterBalloon

                };
                var r = new Random();
                var nextChoice = r.Next(0, 5);
                return decisions[nextChoice];
            });
        }
    }
}