using RockPaperScissorsBoom.Core.Game.Results;

namespace RockPaperScissorsBoom.Core.SignalRBot
{
    public interface ISignalRBotServer
    {
        public Task RequestMoveAsync(PreviousDecisionResult previousDecisionResult);
    }
}
