using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;

namespace UnitTests.DataBuilders
{
    public class RoundResultBuilder
    {
        private RoundResult _entity = new(new MatchResult(new Competitor("", ""), new Competitor("", "")));

        public RoundResult Build()
        {
            return _entity;
        }

        public RoundResultBuilder WithDefaults()
        {
            _entity = new RoundResult(new MatchResult(new Competitor("", ""), new Competitor("", "")));
            return this;
        }

        public RoundResultBuilder Winner(Competitor? winner)
        {
            _entity.Winner = winner;
            return this;
        }

        public RoundResultBuilder Player1(Competitor player1)
        {
            _entity.Player1 = player1;
            return this;
        }
        public RoundResultBuilder Player2(Competitor player2)
        {
            _entity.Player2 = player2;
            return this;
        }

        public RoundResultBuilder Player1Played(Decision played)
        {
            _entity.Player1Played = played;
            return this;
        }

        public RoundResultBuilder Player2Played(Decision played)
        {
            _entity.Player2Played = played;
            return this;
        }
    }
}