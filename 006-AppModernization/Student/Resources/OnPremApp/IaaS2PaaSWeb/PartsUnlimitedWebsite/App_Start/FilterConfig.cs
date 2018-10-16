using System.Web.Mvc;
using PartsUnlimited.Utils;

namespace PartsUnlimited
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
            filters.Add(new LayoutDataAttribute());
        }
    }
}