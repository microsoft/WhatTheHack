using FluentAssertions;
using Microsoft.Extensions.Logging.Abstractions;
using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Game.Results;
using RockPaperScissorsBoom.Core.Model;
using UnitTests.Fakes;

namespace UnitTests.Core.Game.MatchRunnerTests
{
    public class RunMatchShould
    {
        private readonly MatchRunner _matchRunner = new(new FakeMetrics());
        private readonly BaseBot _rockOnly = new RockOnlyBot(new Competitor("", ""), new NullLogger<RunMatchShould>());
        private readonly BaseBot _scissorsOnly = new ScissorsOnlyBot(new Competitor("", ""), new NullLogger<RunMatchShould>());

        [Fact]
        public async void ReturnSimpleMatchResult_GivenStaticBots()
        {
            MatchResult matchResult = await _matchRunner.RunMatch(_rockOnly, _scissorsOnly);

            matchResult.Player1.Should().Be(_rockOnly.Competitor);
            matchResult.Player2.Should().Be(_scissorsOnly.Competitor);
            matchResult.WinningPlayer.Should().Be(MatchOutcome.Player1);
            matchResult.RoundResults?.Count.Should().Be(100);
        }

        [Fact]
        public async void HandlePlayer2Winning()
        {
            MatchResult matchResult = await _matchRunner.RunMatch(_scissorsOnly, _rockOnly);

            matchResult.Player2.Should().Be(_rockOnly.Competitor);
            matchResult.Player1.Should().Be(_scissorsOnly.Competitor);
            matchResult.WinningPlayer.Should().Be(MatchOutcome.Player2);
            matchResult.RoundResults?.Count.Should().Be(100);
        }

        [Fact]
        public async void NotSetWinnerAndLoser_GivenTie()
        {
            MatchResult matchResult = await _matchRunner.RunMatch(_rockOnly, _rockOnly);

            matchResult.Player1.Should().Be(_rockOnly.Competitor);
            matchResult.Player2.Should().Be(_rockOnly.Competitor);
            matchResult.WinningPlayer.Should().Be(MatchOutcome.Tie);
            matchResult.RoundResults?.Count.Should().Be(100);
        }
    }
}