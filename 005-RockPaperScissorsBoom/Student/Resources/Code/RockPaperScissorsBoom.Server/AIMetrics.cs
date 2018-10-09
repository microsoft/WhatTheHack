using System.Collections.Generic;
using Microsoft.ApplicationInsights;
using RockPaperScissor.Core.Model;

namespace RockPaperScissorsBoom.Server
{
    public class AIMetrics : IMetrics
    {
        private readonly TelemetryClient telemetry;
        private readonly string ignoreList;

        public AIMetrics(TelemetryClient telemetry, string ignoreList)
        {
            this.telemetry = telemetry;
            this.ignoreList = ignoreList;
        }

        public void TrackEventDuration(string eventName, Dictionary<string, string> properties, Dictionary<string, double> metrics)
        {
            if (!ignoreList.Contains(eventName))
            {
                telemetry.TrackEvent(eventName, properties, metrics);
            }
        }
    }
}