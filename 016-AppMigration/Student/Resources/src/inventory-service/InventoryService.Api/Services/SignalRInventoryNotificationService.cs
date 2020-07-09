using System.Threading.Tasks;
using InventoryService.Api.Hubs;
using InventoryService.Api.Models;
using Microsoft.AspNetCore.SignalR;

namespace InventoryService.Api.Services
{
    public class SignalRInventoryNotificationService : IInventoryNotificationService
    {
        private readonly IHubContext<InventoryHub> hub;

        public SignalRInventoryNotificationService(IHubContext<InventoryHub> hub)
        {
            this.hub = hub;
        }

        public Task NotifyInventoryChanged(InventoryItem item)
        {
            return hub.Clients.All.SendAsync("inventoryUpdated", item);
        }
    }
}