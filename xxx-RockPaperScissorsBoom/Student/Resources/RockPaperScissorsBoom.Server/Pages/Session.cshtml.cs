using Microsoft.AspNetCore.Mvc.RazorPages;
using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using Microsoft.Extensions.Options;
using Microsoft.AspNetCore.Http.Features.Authentication;
using Microsoft.AspNetCore.Authentication;

namespace RockPaperScissorsBoom.Server.Pages
{
    public class Session : PageModel
    {
        public Session(IOptions<AzureAdB2COptions> b2cOptions)
        {
            AzureAdB2COptions = b2cOptions.Value;
        }

        public AzureAdB2COptions AzureAdB2COptions { get; set; }

        public IActionResult OnGet()
        {
            var redirectUrl = "/"; //Url.Action(nameof(IndexModel), "Home");
            return Challenge(
                new AuthenticationProperties { RedirectUri = redirectUrl },
                OpenIdConnectDefaults.AuthenticationScheme);
        }
    }
}