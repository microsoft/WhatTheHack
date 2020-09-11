using System;
using System.Collections.Generic;
using System.Text;

namespace ContosoTravel.Web.Application.Interfaces
{
    public interface ICartCookieProvider
    {
        string GetCartCookie();
        void SetCartCookie(string cookieId);
    }
}
