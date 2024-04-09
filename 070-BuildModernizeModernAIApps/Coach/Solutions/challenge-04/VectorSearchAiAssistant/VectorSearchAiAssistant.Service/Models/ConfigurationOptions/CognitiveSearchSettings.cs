using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.Models.ConfigurationOptions
{
    public record CognitiveSearchSettings
    {
        public required string IndexName { get; init; }
        public required int MaxVectorSearchResults { get; init; }
        public required string Endpoint { get; init; }
        public required string Key { get; init; }
    }
}
