using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Graph;
using Microsoft.Graph.Auth;
using Microsoft.Identity.Client;

namespace Verify_inator.Services
{
    public class B2cGraphService
    {
        private readonly string b2cExtensionPrefix;

        public B2cGraphService(string b2cExtensionsAppClientId)
        {
            this.b2cExtensionPrefix = b2cExtensionsAppClientId.Replace("-", "");
        }

        public string GetUserAttributeClaimName(string userAttributeName)
        {
            return $"extension_{userAttributeName}";
        }

        public string GetUserAttributeExtensionName(string userAttributeName)
        {
            return $"extension_{this.b2cExtensionPrefix}_{userAttributeName}";
        }

        private string GetUserAttribute(Microsoft.Graph.User user, string extensionName)
        {
            if (user.AdditionalData == null || !user.AdditionalData.ContainsKey(extensionName))
            {
                return null;
            }
            return (string)user.AdditionalData[extensionName];
        }
    }
}