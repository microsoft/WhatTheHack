using PartsUnlimited.Utils;

namespace PartsUnlimited.Security
{
    public class ConfigurationLoginProviderCredentials : ILoginProviderCredentials
    {
        public ConfigurationLoginProviderCredentials(string providerName)
        {
            Key = ConfigurationHelpers.GetString(string.Format("Authentication.{0}.Key", providerName));
            Secret = ConfigurationHelpers.GetString(string.Format("Authentication.{0}.Secret", providerName));

            Use = !string.IsNullOrWhiteSpace(Key) && !string.IsNullOrWhiteSpace(Secret);
        }

        public string Key { get; set; }
        public string Secret { get; set; }
        public bool Use { get; protected set; }
    }
}