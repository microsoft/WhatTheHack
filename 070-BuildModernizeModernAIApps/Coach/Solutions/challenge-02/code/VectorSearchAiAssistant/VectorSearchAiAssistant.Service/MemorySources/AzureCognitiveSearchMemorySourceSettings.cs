using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.MemorySource
{
    public record AzureCognitiveSearchMemorySourceSettings
    {
        public required string IndexName { get; init; }
        public required string Endpoint { get; init; }
        public required string Key { get; init; }
        public required string ConfigBlobStorageContainer { get; init; }
        public required string ConfigBlobStorageConnection { get; init; }
        public required string ConfigFilePath { get; init; }
    }
}
