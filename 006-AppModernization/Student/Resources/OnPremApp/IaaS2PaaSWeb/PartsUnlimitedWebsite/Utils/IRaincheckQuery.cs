using System.Collections.Generic;
using System.Threading.Tasks;
using PartsUnlimited.Models;

namespace PartsUnlimited.Utils
{
    public interface IRaincheckQuery
    {
        Task<int> AddAsync(Raincheck raincheck);
        Task<Raincheck> FindAsync(int id);
        Task<IEnumerable<Raincheck>> GetAllAsync();
    }
}
