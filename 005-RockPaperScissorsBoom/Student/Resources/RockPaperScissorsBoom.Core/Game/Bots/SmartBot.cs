using Microsoft.Extensions.Logging;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Core.Game.Bots
{
    public class SmartBot : BaseBot
    {
        public SmartBot(Competitor competitor, ILogger logger) : base(competitor, logger)
        {
        }

        private readonly Dictionary<Guid, int> _usedDynamite = new();

        public async override Task<Decision> GetDecisionAsync(PreviousDecisionResult previousResult)
        {
            return await Task.Run(() =>
            {
                Decision decision = GetDecisionThatBeats(previousResult.OpponentPrevious);

                if (decision == Decision.Dynamite && WeAreOutOfDynamite(previousResult.MatchId))
                {
                    decision = GetRandomFromSet(AllBasics);
                }

                if (decision == Decision.Dynamite)
                {
                    LogDynamiteUsage(previousResult.MatchId);
                }
                return decision;
            });
        }

        private void LogDynamiteUsage(Guid matchId)
        {
            if (_usedDynamite.TryGetValue(matchId, out int usedDynanite))
            {
                _usedDynamite[matchId] = usedDynanite + 1;
            }
            else
            {
                _usedDynamite[matchId] = 1;
            }
        }

        private bool WeAreOutOfDynamite(Guid matchId)
        {
            if (_usedDynamite.TryGetValue(matchId, out int usedDynanite))
            {
                return 10 - usedDynanite <= 0;
            }

            return false;
        }

        public Decision GetDecisionThatBeats(Decision? decisionToBeat)
        {
            return decisionToBeat switch
            {
                Decision.Rock => GetRandomFromSet(new[] { Decision.Paper, Decision.Paper, Decision.Paper, Decision.Dynamite }),
                Decision.Paper => GetRandomFromSet(new[] { Decision.Scissors, Decision.Scissors, Decision.Scissors, Decision.Scissors }),
                Decision.Scissors => GetRandomFromSet(new[] { Decision.Rock, Decision.Rock, Decision.Rock, Decision.Dynamite }),
                Decision.WaterBalloon => GetRandomFromSet(AllBasics),
                Decision.Dynamite => Decision.WaterBalloon,
                _ => GetRandomFromSet(AllBasics),
            };
        }
    }
}