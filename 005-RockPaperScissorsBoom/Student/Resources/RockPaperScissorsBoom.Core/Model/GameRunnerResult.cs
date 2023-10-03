namespace RockPaperScissorsBoom.Core.Model
{
    public class GameRunnerResult
    {
        public GameRecord GameRecord { get; set; }
        public List<FullResults> AllMatchResults { get; set; }

        public GameRunnerResult(GameRecord gameRecord, List<FullResults> allMatchResults)
        {
            GameRecord = gameRecord;
            AllMatchResults = allMatchResults;
        }
    }
}