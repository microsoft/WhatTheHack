using Microsoft.Extensions.Logging;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Core.Game.Bots
{
    public abstract class BaseBot
    {
        public Competitor Competitor { get; set; }
        public Guid Id => Competitor.Id;

        public string Name => Competitor.Name;
        public int DynamiteUsed { get; protected set; }
        public void UseDynamite() => DynamiteUsed++;
        public abstract Task<Decision> GetDecisionAsync(PreviousDecisionResult previousResult);
        protected readonly ILogger _logger;

        public BaseBot(Competitor competitor, ILogger logger)
        {
            Competitor = competitor;
            _logger = logger;
        }

        protected List<Decision> AllBasics = new()
        {
            Decision.Paper,
            Decision.Rock,
            Decision.Scissors,
        };

        protected List<Decision> All = new()
        {
            Decision.Dynamite,
            Decision.WaterBalloon,
            Decision.Paper,
            Decision.Rock,
            Decision.Scissors,
        };

        public static Decision GetRandomFromSet(IList<Decision> decisions)
        {
            var r = new Random(); // TODO: handle this random and the seeding better
            var nextChoice = r.Next(0, decisions.Count);
            return decisions[nextChoice];
        }
    }
}