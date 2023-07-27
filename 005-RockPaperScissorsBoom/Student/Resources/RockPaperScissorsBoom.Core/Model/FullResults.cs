using RockPaperScissorsBoom.Core.Game.Results;

namespace RockPaperScissorsBoom.Core.Model
{
    public class FullResults
    {
        public Competitor Competitor { get; set; }
        public List<MatchResult> MatchResults { get; set; }

        public FullResults(Competitor competitor, List<MatchResult> matchResults)
        {
            Competitor = competitor;
            MatchResults = matchResults;
        }
    }
}