using System;
using System.Threading.Tasks;
using PartsUnlimited.Models;
using PartsUnlimited.ViewModels;

namespace PartsUnlimited.Utils
{
    public interface IOrdersQuery
    {
        Task<Order> FindOrderAsync(int id);
        Task<OrdersModel> IndexHelperAsync(string username, DateTime? start, DateTime? end, string invalidOrderSearch, bool isAdminSearch);
    }
}
