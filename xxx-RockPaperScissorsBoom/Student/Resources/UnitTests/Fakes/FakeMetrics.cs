using System.Collections.Generic;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Bots;
using RockPaperScissor.Core.Game.Results;
using RockPaperScissor.Core.Model;

namespace UnitTests.Fakes
{
    public class FakeMetrics : IMetrics
    {
        public void TrackEventDuration(string eventName, Dictionary<string, string> properties, Dictionary<string, double> metrics)
        {
            return;
        }
    }
}