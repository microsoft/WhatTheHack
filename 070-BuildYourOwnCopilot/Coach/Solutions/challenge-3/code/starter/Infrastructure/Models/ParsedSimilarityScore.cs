using System.Text.Json.Serialization;

namespace BuildYourOwnCopilot.Infrastructure.Models
{
    public class ParsedSimilarityScore
    {
        [JsonPropertyName("similarity_score")]
        public double SimilarityScore { get; set; }
    }
}
