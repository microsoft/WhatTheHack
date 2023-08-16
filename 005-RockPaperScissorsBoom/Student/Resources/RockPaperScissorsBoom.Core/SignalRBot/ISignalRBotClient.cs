using RockPaperScissorsBoom.Core.Game;

namespace RockPaperScissorsBoom.Core.SignalRBot
{
    public interface ISignalRBotClient
    {
        Task MakeDecisionAsync(Decision decision);
    }
}
