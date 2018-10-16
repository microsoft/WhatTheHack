//TODO Application Insights - Uncomment
//using Microsoft.ApplicationInsights;
using System;
using System.Collections.Generic;

namespace PartsUnlimited.Utils
{
    public class TelemetryProvider : ITelemetryProvider
    {
        //TODO Application Insights - Uncomment
        //public TelemetryClient AppInsights { get; set; }

        public TelemetryProvider()
        {
            //TODO Application Insights - Uncomment
            //AppInsights = new TelemetryClient();
        }

        public void TrackEvent(string message)
        {
            //TODO Application Insights - Uncomment
            //AppInsights.TrackEvent(message);
        }

        public void TrackEvent(string message, Dictionary<string, string> properties, Dictionary<string, double> measurements)
        {
            //TODO Application Insights - Uncomment
            //AppInsights.TrackEvent(message, properties, measurements);
        }

        public void TrackTrace(string message)
        {
            //TODO Application Insights - Uncomment
            //AppInsights.TrackTrace(message);
        }

        public void TrackException(Exception exception)
        {
            //TODO Application Insights - Uncomment
            //AppInsights.TrackException(exception);
        }
    }
}