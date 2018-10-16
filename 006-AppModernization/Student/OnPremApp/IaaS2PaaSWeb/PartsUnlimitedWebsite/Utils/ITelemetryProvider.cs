using System;
using System.Collections.Generic;

namespace PartsUnlimited.Utils
{
    public interface ITelemetryProvider
    {
        void TrackTrace(string message);
        void TrackEvent(string message);
        void TrackEvent(string message, Dictionary<string, string> properties, Dictionary<string, double> measurements);
        void TrackException(Exception exception);
    }
}