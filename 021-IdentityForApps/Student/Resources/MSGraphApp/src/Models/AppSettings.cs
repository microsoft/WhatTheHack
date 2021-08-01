// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System.IO;

namespace b2c_ms_graph
{
    public class AppSettingsFile
    {
        public AppSettings AppSettings { get; set; }

        public static AppSettings ReadFromJsonFile()
        {
            IConfigurationRoot Configuration;

            var builder = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json");

            Configuration = builder.Build();
            return Configuration.Get<AppSettingsFile>().AppSettings;
        }
    }

    public class AppSettings
    {
        [JsonProperty(PropertyName = "TenantId")]
        public string TenantId { get; set; }

        [JsonProperty(PropertyName = "AppId")]
        public string AppId { get; set; }

        [JsonProperty(PropertyName = "ClientSecret")]
        public string ClientSecret { get; set; }

        [JsonProperty(PropertyName = "B2cExtensionAppClientId")]
        public string B2cExtensionAppClientId { get; set; }

        [JsonProperty(PropertyName = "UsersFileName")]
        public string UsersFileName { get; set; }

        [JsonProperty(PropertyName = "ConsultantIdCustomAttributeName")]
        public string ConsultantIdCustomAttributeName { get; set; }

        [JsonProperty(PropertyName = "TerritoryNameCustomAttributeName")]
        public string TerritoryNameCustomAttributeName { get; set; }

    }
}
