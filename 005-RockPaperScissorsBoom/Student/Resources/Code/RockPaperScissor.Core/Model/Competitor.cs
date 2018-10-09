using System;

namespace RockPaperScissor.Core.Model
{
    public class Competitor : BaseEntity
    {
        public string Name { get; set; }
        public string BotType { get; set; }
        public string Url { get; set; }
    }
}