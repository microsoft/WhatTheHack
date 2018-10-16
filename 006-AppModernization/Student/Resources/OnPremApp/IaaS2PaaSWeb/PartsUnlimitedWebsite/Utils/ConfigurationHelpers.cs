using System;
using System.Configuration;

namespace PartsUnlimited.Utils
{
    public static class ConfigurationHelpers
    {
        public static Uri GetUri(string name)
        {
            string setting = GetSetting(name);

            try
            {
                return new Uri(setting);
            }
            catch (Exception ex)
            {
                throw new ConfigurationErrorsException(
                    string.Format("{1}: Unable to parse '{0}' as a Uri", setting, name), ex);
            }
        }

        public static int GetInt32(string name)
        {
            string setting = GetSetting(name);

            int result;
            if (Int32.TryParse(setting, out result))
                return result;

            throw new ConfigurationErrorsException(string.Format("{1}: Unable to parse '{0}' as an integer", setting,name));
        }

        public static string GetString(string name)
        {
            return GetSetting(name);
        }

        public static bool GetBool(string name)
        {
            string setting = GetSetting(name);

            bool result;
            if (Boolean.TryParse(setting, out result))
                return result;

            throw new ConfigurationErrorsException(string.Format("{1}: Unable to parse '{0}' as a boolean", setting,
                name));
        }

        public static TimeSpan GetTimeSpan(string name)
        {
            string setting = GetSetting(name);

            TimeSpan result;
            if (TimeSpan.TryParse(setting, out result))
                return result;

            throw new ConfigurationErrorsException(string.Format("{1}: Unable to parse '{0}' as a Timespan", setting,
                name));
        }

        public static TimeSpan GetTimeSpanMinutes(string name)
        {
            int minutes = GetInt32(name);

            if (minutes <= 0)
            {
                throw new ConfigurationErrorsException("Unable to configure timespan with value less than 1.");
            }

            return TimeSpan.FromMinutes(minutes);
        }

        public static TimeSpan GetTimeSpanSeconds(string name)
        {
            int seconds = GetInt32(name);

            if (seconds <= 0)
            {
                throw new ConfigurationErrorsException("Unable to configure timespan with value less than 1.");
            }

            return TimeSpan.FromSeconds(seconds);
        }

        public static Type GetType(string name)
        {
            string stringType = GetString(name);

            return Type.GetType(stringType, true, true);
        }

        private static string GetSetting(string name)
        {
            try
            {
                return ConfigurationManager.AppSettings[name];
            }
            catch (Exception ex)
            {
                throw new ConfigurationErrorsException(string.Format("{0}: Unable to retrieve setting from configuration", name), ex);
            }
        }
    }
}