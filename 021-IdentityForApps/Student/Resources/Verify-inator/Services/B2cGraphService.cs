using Microsoft.Graph;

namespace Verify_inator.Services
{
    public class B2cGraphService
    {
        private readonly string b2cExtensionPrefix;
        public string ConsultantIDUserAttribute { get; private set; }
        public string TerritoryNameUserAttribute { get; private set; }

        public B2cGraphService(string b2cExtensionsAppClientId, string consultantIDUserAttribute, string territoryNameUserAttribute)
        {
            this.b2cExtensionPrefix = b2cExtensionsAppClientId.Replace("-", "");
            this.ConsultantIDUserAttribute = consultantIDUserAttribute;
            this.TerritoryNameUserAttribute = territoryNameUserAttribute;
        }

        public string GetUserAttributeClaimName(string userAttributeName)
        {
            return $"extension_{userAttributeName}";
        }

        public string GetUserAttributeExtensionName(string userAttributeName)
        {
            return $"extension_{this.b2cExtensionPrefix}_{userAttributeName}";
        }

        private string GetUserAttribute(User user, string extensionName)
        {
            if (user.AdditionalData == null || !user.AdditionalData.ContainsKey(extensionName))
            {
                return null;
            }
            return (string)user.AdditionalData[extensionName];
        }
    }
}