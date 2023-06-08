using System;
using System.Collections.Generic;
using RockPaperScissor.Core.Game.Results;

namespace RockPaperScissor.Core.Model
{
    public class FullResults
    {
        public Competitor Competitor { get; set; }
        public List<MatchResult> MatchResults { get; set; }
    }
}