using System;
using Microsoft.Extensions.Configuration;
using Microsoft.Azure.EventGrid;
using Microsoft.Azure.EventGrid.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace RockPaperScissorsBoom.Server.Helpers
{
    public class EventGridMessagingHelper : IMessagingHelper
    {
        private EventGridConfiguration config;
        public EventGridMessagingHelper(IConfiguration configuration)
        {
            config = new EventGridConfiguration();
            configuration.Bind("EventGrid", this.config);
        }
        public async Task PublishMessageAsync(string messageType, string subject, DateTime dateTime, object data)
        {
            TopicCredentials topicCredentials = new TopicCredentials(config.TopicKey);
            EventGridClient client = new EventGridClient(topicCredentials);

            await client.PublishEventsAsync(config.TopicHostName, GetEventsList(messageType, subject, dateTime, data));
        }

        internal IList<EventGridEvent> GetEventsList(string messageType, string subject, DateTime dateTime, object data)
            {
                List<EventGridEvent> eventsList = new List<EventGridEvent>();
                for (int i = 0; i < 1; i++)
                {
                    eventsList.Add(new EventGridEvent()
                    {
                        Id = Guid.NewGuid().ToString(),
                        EventType = messageType,
                        Data = data,
                        EventTime = dateTime,
                        Subject = subject,
                        DataVersion = config.DataVersion
                    });
                }
                return eventsList;
            }

        public class EventGridConfiguration
        {
            public string TopicEndPoint { get; set; }
            public string TopicKey { get; set; }
            public string TopicHostName { get; set; }
            public string DataVersion { get; set; }

        }
    }
}