using System;
using System.Collections.Generic;

namespace RockPaperScissor.Core.Model
{
    public class GameRecord : BaseEntity
    {
        public DateTime GameDate { get; set; } = DateTime.UtcNow;
        public List<BotRecord> BotRecords { get; set; } = new List<BotRecord>();
    }
}