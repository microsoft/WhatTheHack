using System;
using System.Collections.Generic;
using RockPaperScissor.Core.Game.Results;
using RockPaperScissor.Core.Model;

namespace RockPaperScissor.Core.Game.Bots
{
    public abstract class BaseBot
    {
        public Competitor Competitor { get; set; }
        public Guid Id => Competitor.Id;

        public string Name => Competitor.Name;
        public int DynamiteUsed { get; protected set; }
        public void UseDynamite() => DynamiteUsed++;
        public abstract Decision GetDecision(PreviousDecisionResult previousResult);

        protected List<Decision> AllBasics = new List<Decision> {
            Decision.Paper,
            Decision.Rock,
            Decision.Scissors,
        };

        protected List<Decision> All = new List<Decision> {
            Decision.Dynamite,
            Decision.WaterBalloon,
            Decision.Paper,
            Decision.Rock,
            Decision.Scissors,
        };

        public Decision GetRandomFromSet(IList<Decision> decisions)
        {
            var r = new Random(); // TODO: handle this random and the seeding better
            var nextChoice = r.Next(0, decisions.Count);
            return decisions[nextChoice];

        }
    }
}