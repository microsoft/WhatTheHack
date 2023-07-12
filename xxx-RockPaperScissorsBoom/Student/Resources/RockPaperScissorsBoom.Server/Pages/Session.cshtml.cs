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
        public IActionResult OnGet()
        {
            var redirectUrl = "/"; //Url.Action(nameof(IndexModel), "Home");
            return Challenge(
                new AuthenticationProperties { RedirectUri = redirectUrl },
                OpenIdConnectDefaults.AuthenticationScheme);
        }
    }
}