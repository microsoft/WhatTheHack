using RockPaperScissorsBoom.Core.Model;

namespace UnitTests.Fakes
{
    public class FakeMetrics : IMetrics
    {
        public void TrackEventDuration(string eventName, Dictionary<string, string?> properties, Dictionary<string, double> metrics)
        {
            return;
        }
    }
}