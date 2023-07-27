namespace RockPaperScissorsBoom.Server.Models
{
    public class GameMessage
    {
        public string? TeamName { get; set; }
        public string? GameId { get; set; }
        public string? Winner { get; set; }
        public string? Hostname { get; set; }
    }
}
