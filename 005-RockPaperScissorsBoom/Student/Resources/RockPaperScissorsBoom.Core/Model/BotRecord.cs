namespace RockPaperScissorsBoom.Core.Model
{
    public class BotRecord : BaseEntity
    {
        public GameRecord GameRecord { get; set; } = null!;
        public Competitor Competitor { get; set; } = null!;
        public int Wins { get; set; }
        public int Losses { get; set; }
        public int Ties { get; set; }

        // EF Core requires a parameterless constructor
        private BotRecord() { }

        public BotRecord(GameRecord gameRecord, Competitor competitor, int wins, int losses, int ties)
        {
            GameRecord = gameRecord;
            Competitor = competitor;
            Wins = wins;
            Losses = losses;
            Ties = ties;
        }
    }
}