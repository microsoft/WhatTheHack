using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Mvc;
using PartsUnlimited.Models;
using PartsUnlimited.Utils;
using PartsUnlimited.ViewModels;

namespace PartsUnlimited.Controllers
{
    public class ShoppingCartController : Controller
    {
        private readonly IPartsUnlimitedContext db;
        private readonly ITelemetryProvider telemetry;
        private readonly IShippingTaxCalculator shippingTaxCalculator;

		public ShoppingCartController(IPartsUnlimitedContext context, ITelemetryProvider telemetryProvider, 
			IShippingTaxCalculator shippingTaxCalc)
        {
            db = context;
            telemetry = telemetryProvider;
			shippingTaxCalculator = shippingTaxCalc;
        }

        //
        // GET: /ShoppingCart/

        public ActionResult Index()
        {
            var cart = ShoppingCart.GetCart(db, HttpContext);
            var items = cart.GetCartItems();
			var itemsCount = items.Sum(x => x.Count);
			//var subTotal = items.Sum(x => x.Count * x.Product.Price);
			//var shipping = itemsCount * (decimal)5.00;
			//var tax = (subTotal + shipping) * (decimal)0.05;
			//var total = subTotal + shipping + tax;

			//var costSummary = new OrderCostSummary
			//{
			//    CartSubTotal = subTotal.ToString("C"),
			//    CartShipping = shipping.ToString("C"),
			//    CartTax = tax.ToString("C"),
			//    CartTotal = total.ToString("C")
			//};
			var costSummary = shippingTaxCalculator.CalculateCost(items, null);

            // Set up our ViewModel
            var viewModel = new ShoppingCartViewModel
            {
                CartItems = items,
                CartCount = itemsCount,
                OrderCostSummary = costSummary
            };


            // Track cart review event with measurements
            telemetry.TrackTrace("Cart/Server/Index");

            // Return the view
            return View(viewModel);
        }

        //
        // GET: /ShoppingCart/AddToCart/5

        public async Task<ActionResult> AddToCart(int id)
        {
            // Retrieve the product from the database
            var addedProduct = db.Products
                .Single(product => product.ProductId == id);

            // Start timer for save process telemetry
            var startTime = DateTime.Now;

            // Add it to the shopping cart
            var cart = ShoppingCart.GetCart(db, HttpContext);

            cart.AddToCart(addedProduct);

            await db.SaveChangesAsync(CancellationToken.None);

            // Trace add process
            var measurements = new Dictionary<string, double>()
            {
                {"ElapsedMilliseconds", DateTime.Now.Subtract(startTime).TotalMilliseconds }
            };
            telemetry.TrackEvent("Cart/Server/Add", null, measurements);

            // Go back to the main store page for more shopping
            return RedirectToAction("Index");
        }

        //
        // AJAX: /ShoppingCart/RemoveFromCart/5
        [System.Web.Mvc.HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> RemoveFromCart([FromUri] int id)
        {

            // Start timer for save process telemetry
            var startTime = DateTime.Now;

            // Retrieve the current user's shopping cart
            var cart = ShoppingCart.GetCart(db, HttpContext);

            // Get the name of the product to display confirmation
            var cartItem = db.CartItems.Include("Product").Single(item => item.CartItemId == id);
            string productName = cartItem.Product.Title;

            // Remove from cart
            int itemCount = cart.RemoveFromCart(id);

            await db.SaveChangesAsync(CancellationToken.None);

            string removed = (itemCount > 0) ? " 1 copy of " : string.Empty;

            // Trace remove process
            var measurements = new Dictionary<string, double>()
            {
                {"ElapsedMilliseconds", DateTime.Now.Subtract(startTime).TotalMilliseconds }
            };
            telemetry.TrackEvent("Cart/Server/Remove", null, measurements);

            // Display the confirmation message
            var items = cart.GetCartItems();
            var itemsCount = items.Sum(x => x.Count);
            var subTotal = items.Sum(x => x.Count * x.Product.Price);
            var shipping = itemsCount * (decimal)5.00;
            var tax = (subTotal + shipping) * (decimal)0.05;
            var total = subTotal + shipping + tax;

            var results = new ShoppingCartRemoveViewModel
            {
                Message = removed + productName +
                    " has been removed from your shopping cart.",
                CartSubTotal = subTotal.ToString("C"),
                CartShipping = shipping.ToString("C"),
                CartTax = tax.ToString("C"),
                CartTotal = total.ToString("C"),
                CartCount = itemsCount,
                ItemCount = itemCount,
                DeleteId = id
            };

            return Json(results);
        }
    }
}
