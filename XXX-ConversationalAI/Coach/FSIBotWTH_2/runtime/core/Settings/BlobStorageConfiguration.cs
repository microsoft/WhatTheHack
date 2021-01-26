// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.BotFramework.Composer.Core.Settings
{
    public class BlobStorageConfiguration
    {
        public string ConnectionString { get; set; }

        public string Container { get; set; }
    }
}
