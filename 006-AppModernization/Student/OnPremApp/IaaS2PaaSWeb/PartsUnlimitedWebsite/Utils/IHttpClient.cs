using System.Threading.Tasks;

namespace PartsUnlimited.Utils
{
    public interface IHttpClient
    {
        Task<string> GetStringAsync(string uri);
    }
}