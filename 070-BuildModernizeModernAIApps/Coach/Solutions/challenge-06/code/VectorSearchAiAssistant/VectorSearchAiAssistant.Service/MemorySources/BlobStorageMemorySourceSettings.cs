using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.MemorySource
{
    public record BlobStorageMemorySourceSettings
    {
        public required string ConfigBlobStorageContainer { get; init; }
        public required string ConfigBlobStorageConnection { get; init; }
        public required string ConfigFilePath { get; init; }
    }
}
