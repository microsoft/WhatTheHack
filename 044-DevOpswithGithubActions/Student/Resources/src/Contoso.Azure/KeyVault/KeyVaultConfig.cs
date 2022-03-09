namespace Contoso.Azure.KeyVault
{
    public static class KeyVaultConfig
    {
        public static string GetKeyVaultEndpoint(string vaultName) => $"https://{vaultName.Trim().ToLower()}.vault.azure.net/";
    }
}