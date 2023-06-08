using System.Collections.Generic;

namespace RockPaperScissor.Core.Model
{
    public class GameRunnerResult
    {
        public GameRecord GameRecord { get; set; }
        public List<FullResults> AllMatchResults { get; set; }
    }
}