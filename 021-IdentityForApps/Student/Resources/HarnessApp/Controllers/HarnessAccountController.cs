
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Microsoft.Identity.Web;
using Microsoft.Identity.Web.UI.Areas.MicrosoftIdentity.Controllers;

namespace WebApp_OpenIDConnect_DotNet.Controllers
{
    /// <summary>
    /// Controller used in web apps to manage accounts.
    /// </summary>
    [AllowAnonymous]
    [Route("[controller]/[action]")]
    public class HarnessAccountController : Controller
    {
        private AccountController _accountController;
        private readonly IOptions<MicrosoftIdentityOptions> _options;
        private readonly string _deleteAccountPolicyId;
        public HarnessAccountController(IConfiguration configuration, IOptions<MicrosoftIdentityOptions> microsoftIdentityOptions)
        {
            _accountController = new AccountController(microsoftIdentityOptions);
            _options = microsoftIdentityOptions;
            // Get the "Delete My Account" custom policy ID from configuration, or use the default value when missing.
            _deleteAccountPolicyId = configuration.GetValue<string>("AzureAdB2C:DeleteAccountPolicyId") ?? "B2C_1A_delete_my_account";
        }


        /// <summary>
        /// In B2C applications handles the Delete My Account policy.
        /// </summary>
        /// <param name="scheme">Authentication scheme.</param>
        /// <returns>Challenge generating a redirect to Azure AD B2C.</returns>
        [HttpGet("{scheme?}")]
        public IActionResult DeleteMyAccount([FromRoute] string scheme)
        {
            scheme ??= OpenIdConnectDefaults.AuthenticationScheme;

            var redirectUrl = Url.Content("~/");
            var properties = new AuthenticationProperties { RedirectUri = redirectUrl };
            properties.Items[Constants.Policy] = _deleteAccountPolicyId;
            return _accountController.Challenge(properties, scheme);
        }
    }
}