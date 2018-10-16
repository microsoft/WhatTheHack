using System.Collections.Generic;
using System.Threading.Tasks;
using PartsUnlimited.Models;

namespace PartsUnlimited.ProductSearch
{
    public interface IProductSearch
    {
        Task<IEnumerable<Product>> Search(string query);
    }
}
