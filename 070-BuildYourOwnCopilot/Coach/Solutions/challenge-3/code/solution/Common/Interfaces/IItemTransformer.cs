using Newtonsoft.Json.Linq;

namespace BuildYourOwnCopilot.Common.Interfaces
{
    public interface IItemTransformer
    {
        object TypedValue { get; }

        string EmbeddingId { get; }

        string EmbeddingPartitionKey { get; }

        string Name { get; }

        JObject ObjectToEmbed { get; }

        string TextToEmbed { get; }

        string? VectorIndexName { get; }
    }
}
