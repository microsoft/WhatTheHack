using System.Linq;
using FluentAssertions;
using RockPaperScissor.Core.Game;
using RockPaperScissor.Core.Game.Bots;
using UnitTests.Fakes;
using Xunit;

namespace UnitTests.Core.Game.GameRunnerTests
{
    public class StartAllMatchesShould
    {
        [Fact]
        public void ReturnEmpty_GivenNoBots()
        {
            var gameRunner = new GameRunner(new FakeMetrics());

            var result = gameRunner.StartAllMatches();

            result.GameRecord.BotRecords.Should().BeEmpty();
        }

        [Fact]
        public void ReturnOneBot_GivenOneBotCompeting()
        {
            var gameRunner = new GameRunner(new FakeMetrics());
            gameRunner.AddBot(new RockOnlyBot());

            var result = gameRunner.StartAllMatches();

            result.GameRecord.BotRecords.Should().ContainSingle();
        }
    }
}