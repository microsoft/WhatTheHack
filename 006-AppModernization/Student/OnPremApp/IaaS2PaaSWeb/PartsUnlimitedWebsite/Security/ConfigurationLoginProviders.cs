namespace PartsUnlimited.Security
{
    public class ConfigurationLoginProviders : ILoginProviders
    {
        public ConfigurationLoginProviders()
        {
            Facebook = GetProvider("Facebook");
            Google = GetProvider("Google");
            Microsoft = GetProvider("Microsoft");
            Twitter = GetProvider("Twitter");
        }

        private ILoginProviderCredentials GetProvider(string providerName)
        {
            return new ConfigurationLoginProviderCredentials(providerName);
        }

        public ILoginProviderCredentials Facebook { get; private set; }
        public ILoginProviderCredentials Google { get; private set; }
        public ILoginProviderCredentials Microsoft { get; private set; }
        public ILoginProviderCredentials Twitter { get; private set; }
    }
}