using System.ComponentModel.DataAnnotations;

namespace RockPaperScissorsBoom.Core.Model
{
    public class Competitor : BaseEntity
    {
        public string Name { get; set; } = "";
        public string BotType { get; set; } = "";
        [RegularExpression("^https?:\\/\\/(?:www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b(?:[-a-zA-Z0-9()@:%_\\+.~#?&\\/=]*)/decision$")]
        public string? Url { get; set; } = "";

        public Competitor()
        {
        }

        public Competitor(string name, string botType)
        {
            Name = name;
            BotType = botType;
        }
    }
}