using Moq;
using NUnit.Framework;
using BuildYourOwnCopilot.Common.Interfaces;
using BuildYourOwnCopilot.Common.Models.Chat;

namespace BuildYourOwnCopilot.Infrastructure.Tests
{
    [TestFixture]
    public class CosmosDbServiceTests
    {
        private Mock<ICosmosDBService> _cosmosDbServiceMock;

        [SetUp]
        public void Setup()
        {
            _cosmosDbServiceMock = new Mock<ICosmosDBService>();
        }

        [Test]
        public async Task GetSessionsAsync_ShouldReturnListOfSessions()
        {
            // Arrange
            var expectedSessions = new List<Session> {
                new Session
                {
                    Id = "93c578d9-d039-4b31-96b5-8992cb40e96d",
                    SessionId = "93c578d9-d039-4b31-96b5-8992cb40e96d",
                    Type = "Session",
                    TokensUsed = 5000,
                    Name = "Socks available"
                },
                new Session
                {
                    Id = "ef7c2ee9-6679-4c5f-9007-814c82a8b615",
                    SessionId = "ef7c2ee9-6679-4c5f-9007-814c82a8b615",
                    Type = "Session",
                    TokensUsed = 1500,
                    Name = "Bike inventory"
                }
            };
            _cosmosDbServiceMock.Setup(s => s.GetSessionsAsync())
                .ReturnsAsync(expectedSessions);

            // Act
            var service = _cosmosDbServiceMock.Object;
            var sessions = await service.GetSessionsAsync();

            // Assert
            Assert.AreEqual(expectedSessions.Count, sessions.Count);
            CollectionAssert.AreEqual(expectedSessions, sessions);
        }

        [Test]
        public async Task GetSessionMessagesAsync_ShouldReturnListOfMessagesForSession()
        {
            // Arrange
            const string sessionId = "93c578d9-d039-4b31-96b5-8992cb40e96d";
            var expectedMessages = new List<Message>
            {
                new Message(sessionId, "User", 1536, 1536, 1536, "What kind of socks do you have available?", null, null),
                new Message(sessionId, "Assistant", 26, 26, 26, "We have two types of socks available: Racing Socks and Mountain Bike Socks. Both are available in sizes L and M.", null, null),
            };
            _cosmosDbServiceMock.Setup(s => s.GetSessionMessagesAsync(sessionId))
                .ReturnsAsync(expectedMessages);

            // Act
            var service = _cosmosDbServiceMock.Object;
            var messages = await service.GetSessionMessagesAsync(sessionId);

            // Assert
            Assert.AreEqual(expectedMessages.Count, messages.Count);
            CollectionAssert.AreEqual(expectedMessages, messages);
        }
        
    }
}
