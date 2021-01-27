// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Dialogs.Declarative.Resources;
using Microsoft.Bot.Builder.Integration.AspNet.Core;
using Microsoft.Extensions.Logging;
using System;
using System.Net;
using System.Threading.Tasks;

namespace Microsoft.BotFramework.Composer.Functions
{
    public class MessagesTrigger
    {
        private readonly IBotFrameworkHttpAdapter _adapter;
        private readonly IBot _bot;

        public MessagesTrigger(IBotFrameworkHttpAdapter adapter, IBot bot)
        {
            this._adapter = adapter ?? throw new ArgumentNullException(nameof(adapter));
            this._bot = bot ?? throw new ArgumentNullException(nameof(bot));
        }

        [FunctionName("messages")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            ILogger log)
        {
            log.LogInformation($"Messages endpoint triggered.");

            // Delegate the processing of the HTTP POST to the adapter.
            // The adapter will invoke the bot.
            await _adapter.ProcessAsync(req, req.HttpContext.Response, _bot);

            if (req.HttpContext.Response.StatusCode == (int) HttpStatusCode.OK || req.HttpContext.Response.StatusCode == (int)HttpStatusCode.Accepted)
            {
                return new OkResult();
            }
            else
            {
                return new ContentResult()
                {
                    StatusCode = req.HttpContext.Response.StatusCode,
                    Content = $"Bot execution failed with status code: {req.HttpContext.Response.StatusCode}"
                };
            }    
        }
    }
}
