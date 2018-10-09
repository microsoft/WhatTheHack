using System;
using System.Collections.Generic;
using RockPaperScissor.Core.Game.Results;

namespace RockPaperScissor.Core.Game.Bots
{
    public class SmartBot : BaseBot
    {
        private readonly Dictionary<Guid,int> _usedDynamite = new Dictionary<Guid, int>();

        public override Decision GetDecision(PreviousDecisionResult previousResult)
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
                return 100 - usedDynanite <= 0;
            }

            return false;
        }

        public Decision GetDecisionThatBeats(Decision decisionToBeat)
        {
            switch (decisionToBeat)
            {
                case Decision.Rock:
                    return GetRandomFromSet(new[] { Decision.Paper , Decision.Paper , Decision.Paper , Decision.Dynamite});
                case Decision.Paper:
                    return GetRandomFromSet(new[] { Decision.Scissors, Decision.Scissors, Decision.Scissors, Decision.Scissors });
                case Decision.Scissors:
                    return GetRandomFromSet(new[] { Decision.Rock, Decision.Rock, Decision.Rock, Decision.Dynamite });
                case Decision.WaterBalloon:
                    return GetRandomFromSet(AllBasics);
                case Decision.Dynamite:
                    return Decision.WaterBalloon;
            }

            return GetRandomFromSet(AllBasics);
        }
    }
}