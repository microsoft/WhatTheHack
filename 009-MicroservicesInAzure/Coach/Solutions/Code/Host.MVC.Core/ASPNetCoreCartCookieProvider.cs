using ContosoTravel.Web.Application.Interfaces;
using ContosoTravel.Web.Application.Models;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ContosoTravel.Web.Host.MVC.Core
{
    public class ASPNetCoreCartCookieProvider : ICartCookieProvider
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        public ASPNetCoreCartCookieProvider(IHttpContextAccessor httpContextAccessor)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        public string GetCartCookie()
        {
            string cartId = string.Empty;
            var currentContext = _httpContextAccessor.HttpContext;
            if (!currentContext.Request.Cookies.TryGetValue("CartId", out cartId))
            {
                CartModel currentCart = new CartModel();
                cartId = currentCart.Id.ToString("n");
                currentContext.Response.Cookies.Append("CartId", cartId);
            }
            return cartId;
        }

        public void SetCartCookie(string cookieId)
        {
            _httpContextAccessor.HttpContext.Response.Cookies.Append("CartId", cookieId);
        }
    }
}
