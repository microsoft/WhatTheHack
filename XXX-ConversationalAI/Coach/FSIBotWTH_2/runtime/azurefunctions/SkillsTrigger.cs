// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Bot.Builder.Integration.AspNet.Core;
using Microsoft.Bot.Builder;
using System.Web.Http;
using Microsoft.Bot.Builder.Skills;
using Microsoft.Bot.Schema;
using Microsoft.BotFramework.Composer.Functions.Settings;

namespace Microsoft.BotFramework.Composer.Functions
{
    public class SkillsTrigger
    {
        private readonly SkillHandler _skillHandler;

        public SkillsTrigger(SkillHandler skillHandler)
        {
            this._skillHandler = skillHandler ?? throw new ArgumentNullException(nameof(skillHandler));
        }

        [FunctionName("skills")]
        public async Task<IActionResult> ReplyToActivityAsync(
            [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "v3/conversations/{conversationId}/activities/{activityId}")] HttpRequest req,
            string conversationId, string activityId, ILogger log)
        {
            log.LogInformation($"Skill ReplyToActivityAsync endpoint triggered.");

            var body = await req.ReadAsStringAsync();
            var activity = JsonConvert.DeserializeObject<Activity>(body, ActivitySerializationSettings.Default);
            var result = await _skillHandler.HandleReplyToActivityAsync(req.Headers["Authorization"], conversationId, activityId, activity);

            return new JsonResult(result, ActivitySerializationSettings.Default);
        }


        //[FunctionName("skills")]
        //public async Task<IActionResult> SendToConversationAsync(
        //    [HttpTrigger(AuthorizationLevel.Anonymous, "post", Route = "v3/conversations/{conversationId}/activities")] HttpRequest req,
        //    string conversationId, string activityId, ILogger log)
        //{
        //    log.LogInformation($"Skill ReplyToActivityAsync endpoint triggered.");

        //    var body = await req.ReadAsStringAsync();
        //    var activity = JsonConvert.DeserializeObject<Activity>(body, ActivitySerializationSettings.Default);
        //    var result = await _skillHandler.HandleSendToConversationAsync(req.Headers["Authorization"], conversationId, activity);

        //    return new JsonResult(result, ActivitySerializationSettings.Default);
        //}
    }
}
