using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Model;

namespace RockPaperScissorsBoom.Server.Services
{
    public interface IRunGameService
    {
        public List<GameRecord> GetGameRecords();
        public Task<GameResults> RunGameAsync();
        event EventHandler<GameRoundCompletedEventArgs>? GameRoundCompleted;
    }

    public struct GameResults
    {
        public List<BotRecord> BotRankings { get; set; }
        public List<FullResults> AllFullResults { get; set; }
        public List<GameRecord> GameRecords { get; set; }

        public GameResults(List<BotRecord> botRankings, List<FullResults> allFullResults, List<GameRecord> gameRecords)
        {
            BotRankings = botRankings;
            AllFullResults = allFullResults;
            GameRecords = gameRecords;
        }
    }
}
