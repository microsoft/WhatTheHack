using FluentAssertions;
using Microsoft.Extensions.Logging.Abstractions;
using RockPaperScissorsBoom.Core.Game;
using RockPaperScissorsBoom.Core.Game.Bots;
using RockPaperScissorsBoom.Core.Model;
using UnitTests.Fakes;

namespace UnitTests.Core.Game.GameRunnerTests
{
    public class StartAllMatchesShould
    {
        [Fact]
        public async void ReturnEmpty_GivenNoBots()
        {
            var gameRunner = new GameRunner(new FakeMetrics());

            var result = await gameRunner.StartAllMatches();

            result.GameRecord.BotRecords.Should().BeEmpty();
        }

        [Fact]
        public async void ReturnOneBot_GivenOneBotCompeting()
        {
            var gameRunner = new GameRunner(new FakeMetrics());
            gameRunner.AddBot(new RockOnlyBot(new Competitor("", ""), new NullLogger<StartAllMatchesShould>()));

            var result = await gameRunner.StartAllMatches();

            result.GameRecord.BotRecords.Should().ContainSingle();
        }
    }
}