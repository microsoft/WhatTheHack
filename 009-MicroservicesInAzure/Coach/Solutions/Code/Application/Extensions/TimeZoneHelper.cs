using System;
using System.Collections.Generic;
using System.Text;

namespace ContosoTravel.Web.Application.Extensions
{
    public static class TimeZoneHelper
    {
        public static TimeZoneInfo FindSystemTimeZoneById(string timeZoneId)
        {
            if ( System.Runtime.InteropServices.RuntimeInformation.IsOSPlatform(System.Runtime.InteropServices.OSPlatform.Linux) )
            {
                timeZoneId = TimeZoneConverter.TZConvert.WindowsToIana(timeZoneId);
            }

            return TimeZoneInfo.FindSystemTimeZoneById(timeZoneId);
        }
    }
}
