using Microsoft.Extensions.Logging;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Core.Game.Bots
{
    public class CleverBot : BaseBot
    {
        public CleverBot(Competitor competitor, ILogger logger) : base(competitor, logger)
        {
        }

        public async override Task<Decision> GetDecisionAsync(PreviousDecisionResult? previousResult)
        {
            return await Task.Run(() => GetDecisionThatBeats(previousResult?.OpponentPrevious));
        }

        public static Decision GetDecisionThatBeats(Decision? decisionToBeat)
        {
            return decisionToBeat switch
            {
                Decision.Rock => Decision.Paper,
                Decision.Paper => Decision.Scissors,
                Decision.Scissors => Decision.Rock,
                Decision.WaterBalloon => Decision.Rock,
                Decision.Dynamite => Decision.WaterBalloon,
                _ => Decision.Rock,
            };
        }
    }
}