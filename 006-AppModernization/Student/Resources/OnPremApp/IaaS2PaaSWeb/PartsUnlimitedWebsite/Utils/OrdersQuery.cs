using PartsUnlimited.ViewModels;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using PartsUnlimited.Models;

namespace PartsUnlimited.Utils
{
    public class OrdersQuery : IOrdersQuery
    {
        private readonly IPartsUnlimitedContext db;

        public OrdersQuery(IPartsUnlimitedContext context)
        {
            db = context;
        }

        public async Task<OrdersModel> IndexHelperAsync(string username, DateTime? start, DateTime? end, string invalidOrderSearch, bool isAdminSearch)
        {
            // The datetime submitted is only expected to have a resolution of a day, so we remove
            // the time of day from start and end.  We add a day for queryEnd to ensure the date
            // includes the whole day requested
            var queryStart = (start ?? DateTime.Now).Date;
            var queryEnd = (end ?? DateTime.Now).Date.AddDays(1).AddSeconds(-1);

            var results = await GetOrderQuery(username, queryStart, queryEnd).ToListAsync();

            await FillOrderDetails(results);

            return new OrdersModel(results, username, queryStart, queryEnd, invalidOrderSearch, isAdminSearch);
        }

        private IQueryable<Order> GetOrderQuery(string username, DateTime start, DateTime end)
        {
            if (String.IsNullOrEmpty(username))
            {
                return db
                    .Orders
                    .Where(o => o.OrderDate < end && o.OrderDate >= start)
                    .OrderBy(o => o.OrderDate);
            }
            else
            {
                return db
                    .Orders
                    .Where(o => o.OrderDate < end && o.OrderDate >= start && o.Username == username)
                    .OrderBy(o => o.OrderDate);
            }
        }

        public async Task<Order> FindOrderAsync(int id)
        {
            var orders = await db.Orders.FirstOrDefaultAsync(o => o.OrderId == id);

            await FillOrderDetails(new[] { orders });

            return orders;
        }

        private async Task FillOrderDetails(IEnumerable<Order> orders)
        {
            foreach (var order in orders)
            {
                order.OrderDetails = await db.OrderDetails.Where(o => o.OrderId == order.OrderId).ToListAsync();

                foreach (var details in order.OrderDetails)
                {
                    details.Product = await db.Products.FirstOrDefaultAsync(o => o.ProductId == details.ProductId);
                }
            }

        }
    }
}
