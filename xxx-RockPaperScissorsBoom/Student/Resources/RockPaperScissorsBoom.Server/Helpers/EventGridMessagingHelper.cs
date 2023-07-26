using Azure.Messaging.EventGrid;

namespace RockPaperScissorsBoom.Server.Helpers
{
    public class EventGridMessagingHelper : IMessagingHelper
    {
        private readonly EventGridConfiguration config;
        public EventGridMessagingHelper(IConfiguration configuration)
        {
            config = new EventGridConfiguration();
            configuration.Bind("EventGrid", config);
        }
        public async Task PublishMessageAsync(string messageType, string subject, DateTime dateTime, object data)
        {
            EventGridPublisherClient client = new(new Uri(config.TopicEndPoint), new Azure.AzureKeyCredential(config.TopicKey));
            await client.SendEventsAsync(GetEventsList(messageType, subject, dateTime, data));
        }

        internal IList<EventGridEvent> GetEventsList(string messageType, string subject, DateTime dateTime, object data)
        {
            List<EventGridEvent> eventsList = new();
            for (int i = 0; i < 1; i++)
            {
                eventsList.Add(new EventGridEvent(subject, messageType, config.DataVersion, data)
                {
                    Id = Guid.NewGuid().ToString(),
                    EventTime = dateTime,
                    Topic = config.TopicHostName
                });
            }
            return eventsList;
        }

        public class EventGridConfiguration
        {
            public string TopicEndPoint { get; set; } = "";
            public string TopicKey { get; set; } = "";
            public string TopicHostName { get; set; } = "";
            public string DataVersion { get; set; } = "";
        }
    }
}