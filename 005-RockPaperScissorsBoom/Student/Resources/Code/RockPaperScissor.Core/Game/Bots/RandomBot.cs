using RockPaperScissor.Core.Game.Results;
using System;
using System.Collections.Generic;

namespace RockPaperScissor.Core.Game.Bots
{
    public class RandomBot : BaseBot
    {
        public override Decision GetDecision(PreviousDecisionResult previousResult)
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
        }
    }
}