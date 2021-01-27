// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Bot.Builder.Azure;

namespace Microsoft.BotFramework.Composer.Core.Settings
{
    public class BotSettings
    {
        public BotFeatureSettings Feature { get; set; }

        public BlobStorageConfiguration BlobStorage { get; set; }

        public string MicrosoftAppId { get; set; }

        public string MicrosoftAppPassword { get; set; }

        public CosmosDbPartitionedStorageOptions CosmosDb { get; set; }

        public TelemetryConfiguration ApplicationInsights { get; set; }

        public AdditionalTelemetryConfiguration Telemetry { get; set; }

        public string Bot { get; set; }

        public BotSkillConfiguration SkillConfiguration { get; set; }

        public class BlobStorageConfiguration
        {
            public string ConnectionString { get; set; }

            public string Container { get; set; }
        }

        public class AdditionalTelemetryConfiguration
        {
            public bool LogPersonalInformation { get; set; }

            public bool LogActivities { get; set; }
        }
    }
}
