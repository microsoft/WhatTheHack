// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Microsoft.Extensions.Configuration;
using System.Collections.Generic;

namespace Microsoft.BotFramework.Composer.Core
{
    /// <summary>
    /// Bot path adapter, for development environment, use '../../' as the bot path, for deployment and production environment, use 'ComposerDialogs' as bot path
    /// </summary>
    public static class ComposerBotPathExtensions
    {
        public static IConfigurationBuilder UseBotPathConverter(this IConfigurationBuilder builder, bool isDevelopment = true)
        {
            var settings = new Dictionary<string, string>();
            if (isDevelopment)
            {
                settings["bot"] = "../../";
            }
            else
            {
                settings["bot"] = "ComposerDialogs";
            }
            builder.AddInMemoryCollection(settings);
            return builder;
        }
    }
}
