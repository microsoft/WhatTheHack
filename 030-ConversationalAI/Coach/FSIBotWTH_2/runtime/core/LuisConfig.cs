// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System.Collections.Generic;

namespace Microsoft.BotFramework.Composer.Core
{
    public class LuisConfig
    {
        public string Name { get; set; }

        public string DefaultLanguage { get; set; }

        public List<string> Models { get; set; }

        public string AuthoringKey { get; set; }

        public bool Dialogs { get; set; }

        public string Environment { get; set; }

        public bool Autodelete { get; set; }

        public string AuthoringRegion { get; set; }

        public string Folder { get; set; }

        public bool Help { get; set; }

        public bool Force { get; set; }

        public string Config { get; set; }

        public string EndpointKeys { get; set; }
    }
}
