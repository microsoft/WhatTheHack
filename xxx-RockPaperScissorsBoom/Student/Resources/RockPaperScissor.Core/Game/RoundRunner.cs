using System.Collections.Generic;
using RockPaperScissor.Core.Extensions;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Game.Results;
using RockPaperScissor.Core.Model;

namespace RockPaperScissor.Core.Game
{
    public class RoundRunner
    {
        internal Decision GetDecision(BaseBot player, RoundResult previousResult, IMetrics metrics)
        {
            var stopwatch = System.Diagnostics.Stopwatch.StartNew();
            var d = player.GetDecision(previousResult.ToPlayerSpecific(player));
            stopwatch.Stop();
            var metric = new Dictionary<string, double> { { "DecisionTime", stopwatch.Elapsed.TotalMilliseconds } };
            var properties = new Dictionary<string, string> { { "Bot", player.Name } };
            metrics.TrackEventDuration("BotDesicionTime", properties, metric);
            return d;
        }

        public RoundResult RunRound(BaseBot player1, BaseBot player2, RoundResult previousResult, IMetrics metrics)
        {

            var p1Decision = GetDecision(player1, previousResult, metrics);

            var p2Decision = GetDecision(player2, previousResult, metrics);

            BaseBot winner = null;
            // confirm each has a valid choice
            bool player1Invalid = IsInvalidDecision(p1Decision, player1);
            bool player2Invalid = IsInvalidDecision(p2Decision, player2);

            if (player1Invalid || player2Invalid)
            {
                if (player1Invalid && player2Invalid)
                {
                    // tie - also, what did you do?!?!
                }
                else if (player1Invalid)
                {
                    winner = player2;
                }
                else
                {
                    winner = player1;
                }
            }
            else
            {
                if (p1Decision == p2Decision)
                {
                    // tie
                }
                else if (p1Decision.IsWinnerAgainst(ref p2Decision))
                {
                    winner = player1;
                }
                else
                {
                    winner = player2;
                }
            }

            var roundResult = new RoundResult
            {
                MatchResult = previousResult.MatchResult,
                Winner = winner?.Competitor,
                Player1 = player1.Competitor,
                Player2 = player2.Competitor,
                Player1Played = p1Decision,
                Player2Played = p2Decision,
            };

            ApplyDynamiteUsageToBots(player1, p1Decision, player2, p2Decision);

            return roundResult;
        }

        private void ApplyDynamiteUsageToBots(BaseBot player1, Decision p1Decision,
            BaseBot player2, Decision p2Decision)
        {
            if (p1Decision == Decision.Dynamite)
            {
                player1.UseDynamite();
            }
            if (p2Decision == Decision.Dynamite)
            {
                player2.UseDynamite();
            }
        }

        private bool IsInvalidDecision(Decision decision, BaseBot bot)
        {
            if (decision == Decision.Dynamite)
            {
                bool outOfDynamite = (10 - bot.DynamiteUsed) <= 0;
                return outOfDynamite;
            }

            return false;
        }
    }
}