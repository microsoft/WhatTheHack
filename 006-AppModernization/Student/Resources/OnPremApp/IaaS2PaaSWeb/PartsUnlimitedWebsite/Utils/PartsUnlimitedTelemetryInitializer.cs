//TODO Application Insights - Uncomment
//using Microsoft.ApplicationInsights.Channel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PartsUnlimited.Utils
{
    public class PartsUnlimitedTelemetryInitializer
    {
        string appVersion = GetApplicationVersion();

        private static string GetApplicationVersion()
        {
            return typeof(PartsUnlimitedTelemetryInitializer).Assembly.GetName().Version.ToString();
        }
        //TODO Application Insights - Uncomment
        //public void Initialize(ITelemetry telemetry)
        //{
        //    telemetry.Context.Component.Version = appVersion;
        //}
    }
}