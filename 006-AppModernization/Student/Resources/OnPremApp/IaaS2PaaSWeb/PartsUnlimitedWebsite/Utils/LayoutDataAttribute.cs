using System;
using System.Linq;
using System.Runtime.Caching;
using System.Web.Mvc;
using PartsUnlimited.Models;

namespace PartsUnlimited.Utils
{
    public class LayoutDataAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuted(ActionExecutedContext filterContext)
        {
            var dataContext = DependencyResolver.Current.GetService<IPartsUnlimitedContext>();

            var cart = ShoppingCart.GetCart(dataContext, filterContext.HttpContext);
            var summary = cart.GetCartItems()
                .Select(a => a.Product.Title)
                .OrderBy(x => x)
                .ToList();

            var latestProduct = MemoryCache.Default["latestProduct"] as Product;
            if (latestProduct == null)
            {
                latestProduct = dataContext.Products.OrderByDescending(a => a.Created).FirstOrDefault();
                if (latestProduct != null)
                {
                    MemoryCache.Default.Add("latestProduct", latestProduct, DateTimeOffset.Now.AddMinutes(10));
                }
            }

            filterContext.Controller.ViewBag.Categories = dataContext.Categories.ToList();
            filterContext.Controller.ViewBag.CartSummary = summary;
            filterContext.Controller.ViewBag.Product = latestProduct;
        }
    }
}