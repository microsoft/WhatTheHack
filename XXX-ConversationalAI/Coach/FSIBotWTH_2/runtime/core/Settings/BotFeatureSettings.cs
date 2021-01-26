// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Microsoft.BotFramework.Composer.Core.Settings
{
    public class BotFeatureSettings
    {
        // Use ShowTypingMiddleware
        public bool UseShowTypingMiddleware { get; set; }

        // Use InspectionMiddleware
        public bool UseInspectionMiddleware { get; set; }

        // Use RemoveRecipientMention Activity Extensions
        public bool RemoveRecipientMention { get; set; }
    }
}
