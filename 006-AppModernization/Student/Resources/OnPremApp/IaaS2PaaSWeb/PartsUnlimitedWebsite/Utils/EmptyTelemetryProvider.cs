using System;
using System.Collections.Generic;

namespace PartsUnlimited.Utils
{
    public class EmptyTelemetryProvider : ITelemetryProvider
    {
        public void TrackEvent(string message)
        {
        }

        public void TrackEvent(string message, Dictionary<string, string> properties, Dictionary<string, double> measurements)
        {
        }

        public void TrackException(Exception exception)
        {
        }

        public void TrackTrace(string message)
        {
        }
    }
}