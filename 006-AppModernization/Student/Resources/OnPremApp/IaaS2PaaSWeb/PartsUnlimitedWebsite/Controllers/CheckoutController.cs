using System;
using System.Data.Entity;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using PartsUnlimited.Models;

namespace PartsUnlimited.Controllers
{
    [Authorize]
    public class CheckoutController : Controller
    {
        private readonly IPartsUnlimitedContext db;

        public CheckoutController(IPartsUnlimitedContext context)
        {
            db = context;
        }

        const string PromoCode = "FREE";

        //
        // GET: /Checkout/

        public async Task<ActionResult> AddressAndPayment()
        {
            var id = User.Identity.GetUserId();
            var user = await db.Users.FirstOrDefaultAsync(o => o.Id == id);

            var order = new Order
            {
                Name = user.Name,
                Email = user.Email,
                Username = user.UserName
            };

            return View(order);
        }

        //
        // POST: /Checkout/AddressAndPayment

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> AddressAndPayment(Order order)
        {
            var formCollection = Request.Form;

            try
            {
                if (string.Equals(formCollection.GetValues("PromoCode").FirstOrDefault(), PromoCode,
                    StringComparison.OrdinalIgnoreCase) == false)
                {
                    return View(order);
                }
                else
                {
                    order.Username = User.Identity.GetUserName();
                    order.OrderDate = DateTime.Now;

                    //Add the Order
                    db.Orders.Add(order);

                    //Process the order
                    var cart = ShoppingCart.GetCart(db, HttpContext);
                    cart.CreateOrder(order);

                    // Save all changes
                    await db.SaveChangesAsync(CancellationToken.None);

                    return RedirectToAction("Complete", new { id = order.OrderId });
                }
            }
            catch
            {
                //Invalid - redisplay with errors
                return View(order);
            }
        }

        //
        // GET: /Checkout/Complete

        public ActionResult Complete(int id)
        {
            // Validate customer owns this order
            var username = User.Identity.GetUserName();

            Order order = db.Orders.First(
                o => o.OrderId == id &&
                o.Username == username);

            if (order != null)
            {
                return View(order);
            }
            else
            {
                return View("Error");
            }
        }
    }
}
