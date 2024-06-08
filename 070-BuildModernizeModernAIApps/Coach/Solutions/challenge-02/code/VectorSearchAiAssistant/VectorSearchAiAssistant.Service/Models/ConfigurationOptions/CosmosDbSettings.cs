using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace VectorSearchAiAssistant.Service.Models.ConfigurationOptions
{
    public record CosmosDbSettings
    {
        public required string Endpoint { get; init; }

        public required string Key { get; init; }

        public required string Database { get; init; }

        public required string Containers { get; init; }

        public required string MonitoredContainers { get; init; }

        public required string ChangeFeedLeaseContainer { get; init; }

        public required string ChangeFeedSourceContainer { get; init; }

        public bool EnableTracing { get; init; }
    }
}
