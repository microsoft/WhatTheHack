using FluentAssertions;
using RockPaperScissorsBoom.Core.Extensions;
using RockPaperScissorsBoom.Core.Game;

namespace UnitTests.Core.Extensions.DecisionExtensionsTests
{
    public class IsWinnerAgainstShould
    {
        [Theory]
        [InlineData(Decision.Rock, Decision.Scissors)]
        [InlineData(Decision.Scissors, Decision.Paper)]
        [InlineData(Decision.Paper, Decision.Rock)]
        [InlineData(Decision.WaterBalloon, Decision.Dynamite)]
        public void ReturnTrue_GivenWinningCases(Decision d1, Decision d2)
        {
            bool result = d1.IsWinnerAgainst(ref d2);

            result.Should().BeTrue();
        }

        [Theory]
        [InlineData(Decision.Rock, Decision.WaterBalloon)]
        [InlineData(Decision.Scissors, Decision.WaterBalloon)]
        [InlineData(Decision.Paper, Decision.WaterBalloon)]
        public void ReturnTrue_GivenClassicAgainstWater(Decision d1, Decision d2)
        {
            bool result = d1.IsWinnerAgainst(ref d2);

            result.Should().BeTrue();
        }

        [Theory]
        [InlineData(Decision.Dynamite, Decision.Rock)]
        [InlineData(Decision.Dynamite, Decision.Paper)]
        [InlineData(Decision.Dynamite, Decision.Scissors)]
        public void ReturnTrue_GivenDynamiteAgainstClassic(Decision d1, Decision d2)
        {
            bool result = d1.IsWinnerAgainst(ref d2);

            result.Should().BeTrue();
        }

        [Theory]
        [InlineData(Decision.Scissors, Decision.Rock)]
        [InlineData(Decision.Rock, Decision.Paper)]
        [InlineData(Decision.Paper, Decision.Scissors)]
        [InlineData(Decision.Dynamite, Decision.WaterBalloon)]
        public void ReturnFalse_GivenLosingCases(Decision d1, Decision d2)
        {
            bool result = d1.IsWinnerAgainst(ref d2);

            result.Should().BeFalse();
        }

        [Theory]
        [InlineData(Decision.WaterBalloon, Decision.Rock)]
        [InlineData(Decision.WaterBalloon, Decision.Paper)]
        [InlineData(Decision.WaterBalloon, Decision.Scissors)]
        public void ReturnFalse_GivenWaterAgainstClassic(Decision d1, Decision d2)
        {
            bool result = d1.IsWinnerAgainst(ref d2);

            result.Should().BeFalse();
        }

        [Theory]
        [InlineData(Decision.Rock, Decision.Dynamite)]
        [InlineData(Decision.Paper, Decision.Dynamite)]
        [InlineData(Decision.Scissors, Decision.Dynamite)]
        public void ReturnFalse_GivenClassicAgainstDynamite(Decision d1, Decision d2)
        {
            bool result = d1.IsWinnerAgainst(ref d2);

            result.Should().BeFalse();
        }
    }
}