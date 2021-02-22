
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
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
        public HarnessAccountController(IOptions<MicrosoftIdentityOptions> microsoftIdentityOptions)
        {
            _accountController = new AccountController(microsoftIdentityOptions);
            _options = microsoftIdentityOptions;
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
            properties.Items[Constants.Policy] = "B2C_1A_delete_my_account";
            return _accountController.Challenge(properties, scheme);
        }
    }
}