using System;
using System.Collections.Generic;
using System.Text;

namespace System
{
    public static class SystemExtensions
    {
        public static int ToEpoch(this DateTimeOffset date)
        {
            if (date == null) return int.MinValue;
            DateTimeOffset epoch = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            TimeSpan epochTimeSpan = date.UtcDateTime - epoch;
            return (int)epochTimeSpan.TotalSeconds;
        }
    }
}
