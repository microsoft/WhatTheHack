using Contoso.Web.Models;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;

namespace Contoso.Web.Controllers
{
    public class AccountController : Controller
    {
        public readonly ILogger _logger;

        public AccountController(ILogger<AccountController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public async Task<IActionResult> Login()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return View(new LoginViewModel());
        }

        [HttpPost]
        public async Task<IActionResult> Login(LoginViewModel viewModel, string returnUrl = "/")
        {
            if(ModelState.IsValid)
            {
                // Hardcoding logins for demo purposes
                if ((viewModel.Username == "demouser" || viewModel.Username == "restrictedUser") && viewModel.Password == "Password.1!!")
                {
                    var role = viewModel.Username == "demouser"
                        ? "admin"
                        : "restricted";

                    var claims = new List<Claim>
                    {
                        new Claim(ClaimTypes.Name, viewModel.Username),
                        new Claim("DisplayName", viewModel.Username),
                        new Claim(ClaimTypes.Role, role)
                    };

                    var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);

                    var authProperties = new AuthenticationProperties
                    {
                        AllowRefresh = true,
                        ExpiresUtc = DateTimeOffset.UtcNow.AddMinutes(60),
                        IsPersistent = viewModel.RememberLogin,
                        IssuedUtc = DateTimeOffset.Now
                    };

                    await HttpContext.SignInAsync(
                        CookieAuthenticationDefaults.AuthenticationScheme,
                        new ClaimsPrincipal(claimsIdentity),
                        authProperties);

                    _logger.LogInformation($"User {viewModel.Username} logged in at {DateTime.UtcNow}.");
                    
                    return Redirect(returnUrl);
                }
                else
                {
                    _logger.LogInformation($"Access denied for user {viewModel.Username} at {DateTime.UtcNow}.");
                    return View("AccessDenied");
                }
            }

            ModelState.AddModelError("", "Login failed.");
            return View("Login");
        }

        [HttpPost]
        public async Task<IActionResult> Logout()
        {
            _logger.LogInformation($"User {User.Identity.Name} logged out at {DateTime.UtcNow}.");

            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);

            return View("SignedOut");
        }
    }
}