using BuildYourOwnCopilot.Common.Models.ConfigurationOptions;
using Microsoft.Azure.Cosmos;
using System.Collections.ObjectModel;

namespace BuildYourOwnCopilot.Infrastructure.Models.ConfigurationOptions
{
    public record CosmosDBVectorStoreSettings : VectorStoreSettings
    {
        public required VectorDataType VectorDataType { get; init; }
        public required DistanceFunction DistanceFunction { get; init; }
        public required string EmbeddingPath { get; init; }
        public required VectorIndexType VectorIndexType { get; init; }

        public VectorEmbeddingPolicy VectorEmbeddingPolicy =>
            new([
                new Embedding
                {
                    DataType = VectorDataType,
                    Dimensions = Dimensions,
                    DistanceFunction = DistanceFunction,
                    Path = EmbeddingPath
                }
            ]);

        public IndexingPolicy IndexingPolicy =>
            new()
            {
                VectorIndexes = new Collection<VectorIndexPath>
                {
                    new ()
                    {
                        Path = EmbeddingPath,
                        Type = VectorIndexType
                    }
                }
            };
    }
}
