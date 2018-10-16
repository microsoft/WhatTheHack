using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace PartsUnlimited.Models
{
    public partial class ShoppingCart
    {
        private readonly IPartsUnlimitedContext _db;
        string ShoppingCartId { get; set; }

        public ShoppingCart(IPartsUnlimitedContext db)
        {
            _db = db;
        }

        public static ShoppingCart GetCart(IPartsUnlimitedContext db, HttpContextBase context)
        {
            var cart = new ShoppingCart(db);
            cart.ShoppingCartId = cart.GetCartId(context);
            return cart;
        }

        public void AddToCart(Product product)
        {
            // Get the matching cart and product instances
            var cartItem = _db.CartItems.SingleOrDefault(
                c => c.CartId == ShoppingCartId
                && c.ProductId == product.ProductId);

            if (cartItem == null)
            {
                // Create a new cart item if no cart item exists
                cartItem = new CartItem
                {
                    ProductId = product.ProductId,
                    CartId = ShoppingCartId,
                    Count = 1,
                    DateCreated = DateTime.Now
                };

                _db.CartItems.Add(cartItem);
            }
            else
            {
                // If the item does exist in the cart, then add one to the count
                cartItem.Count++;
            }
        }

        public int RemoveFromCart(int id)
        {
            // Get the cart
            var cartItem = _db.CartItems.Single(
                cart => cart.CartId == ShoppingCartId
                && cart.CartItemId == id);

            int itemCount = 0;

            if (cartItem != null)
            {
                if (cartItem.Count > 1)
                {
                    cartItem.Count--;
                    itemCount = cartItem.Count;
                }
                else
                {
                    _db.CartItems.Remove(cartItem);
                }
            }

            return itemCount;
        }

        public void EmptyCart()
        {
            var cartItems = _db.CartItems.Where(cart => cart.CartId == ShoppingCartId);
            foreach (var item in cartItems)
                _db.CartItems.Remove(item);
        }

        public List<CartItem> GetCartItems()
        {
            var cartItems = _db.CartItems.Where(cart => cart.CartId == ShoppingCartId).Include("Product").ToList();

            return cartItems;
        }

        public int GetCount()
        {
            int sum = 0;
            //https://github.com/aspnet/EntityFramework/issues/557
            // Get the count of each item in the cart and sum them up
            var cartItemCounts = (from cartItems in _db.CartItems
                                  where cartItems.CartId == ShoppingCartId
                                  select (int?)cartItems.Count);

            cartItemCounts.ForEachAsync(carItemCount =>
            {
                if (carItemCount.HasValue)
                {
                    sum += carItemCount.Value;
                }
            });

            // Return 0 if all entries are null
            return sum;
        }

        public decimal GetTotal()
        {
            // Multiply product price by count of that product to get 
            // the current price for each of those products in the cart
            // sum all product price totals to get the cart total
            decimal total = 0;
            foreach (var item in _db.CartItems.Include("Product").Where(c => c.CartId == ShoppingCartId))
            {
                total += item.Count * item.Product.Price;
            }

            return total;
        }

        public int CreateOrder(Order order)
        {
            decimal orderTotal = 0;

            var cartItems = GetCartItems();

            // Iterate over the items in the cart, adding the order details for each
            foreach (var item in cartItems)
            {
                //var product = _db.Products.Find(item.ProductId);
                var product = _db.Products.Single(a => a.ProductId == item.ProductId);

                var orderDetail = new OrderDetail
                {
                    ProductId = item.ProductId,
                    OrderId = order.OrderId,
                    UnitPrice = product.Price,
                    Count = item.Count,
                };

                // Set the order total of the shopping cart
                orderTotal += (item.Count * product.Price);

                _db.OrderDetails.Add(orderDetail);
            }

            // Set the order's total to the orderTotal count
            order.Total = orderTotal;

            // Empty the shopping cart
            EmptyCart();

            // Return the OrderId as the confirmation number
            return order.OrderId;
        }

        // We're using HttpContextBase to allow access to cookies.
        public string GetCartId(HttpContextBase context)
        {
            string cartId = context.Session["CartID"] as string;

            if (cartId == null)
            {
                //A GUID to hold the cartId. 
                cartId = Guid.NewGuid().ToString();

                // Send cart Id as a cookie to the client.
                context.Session["CartID"] = cartId;
            }

            return cartId;
        }
    }
}
