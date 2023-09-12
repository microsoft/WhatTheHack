using Microsoft.AspNetCore.SignalR;

namespace RockPaperScissorsBoom.Server.Hubs
{
    public class ProgressBarHub : Hub
    {
        public async Task UpdateProgress(int progress, int total)
        {
            await Clients.Caller.SendAsync("UpdateProgressBar", progress, total);
        }
    }
}
