namespace BuildYourOwnCopilot.Common.Models.ConfigurationOptions
{
    public record VectorStoreSettings
    {
        public required string Description { get; set; }

        public required string IndexName { get; init; }

        public ulong Dimensions { get; init; }

        public required int MaxVectorSearchResults { get; init; }

        public required double MinRelevance { get; init; }
    }
}
