namespace RockPaperScissor.Core.Model
{
    public class BotRecord : BaseEntity
    {
        public GameRecord GameRecord { get; set; }
        public Competitor Competitor { get; set; }
        public int Wins { get; set; }
        public int Losses { get; set; }
        public int Ties { get; set; }
    }
}