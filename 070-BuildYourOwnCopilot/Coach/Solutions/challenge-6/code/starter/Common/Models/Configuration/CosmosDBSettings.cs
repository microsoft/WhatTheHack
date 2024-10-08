namespace BuildYourOwnCopilot.Common.Models.Configuration
{
    public record CosmosDBSettings
    {
        public required string Endpoint { get; init; }

        public required string Key { get; init; }

        public required string Database { get; init; }

        public bool EnableTracing { get; init; }

        public required string Containers { get; init; }

        public required string MonitoredContainers { get; init; }

        public required string ChangeFeedLeaseContainer { get; init; }

        public required string ChangeFeedSourceContainer { get; init; }
    }
}
