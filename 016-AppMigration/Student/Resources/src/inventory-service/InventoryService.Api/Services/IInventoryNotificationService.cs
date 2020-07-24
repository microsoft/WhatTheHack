using System.Threading.Tasks;
using InventoryService.Api.Models;

namespace InventoryService.Api.Services
{
    public interface IInventoryNotificationService
    {
        Task NotifyInventoryChanged(InventoryItem item);
    }
}