using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.Models.ConfigurationOptions
{
    public record BlobStorageSettings
    {
        public required string BlobStorageContainer { get; set; }
        public required string BlobStorageConnection { get; set; }
    }
}
