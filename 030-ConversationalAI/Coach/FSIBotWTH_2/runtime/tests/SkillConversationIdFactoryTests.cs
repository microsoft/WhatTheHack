// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Adapters;
using Microsoft.Bot.Builder.Dialogs;
using Microsoft.Bot.Builder.Dialogs.Adaptive;
using Microsoft.Bot.Builder.Dialogs.Declarative;
using Microsoft.Bot.Builder.Dialogs.Declarative.Resources;
using Microsoft.Bot.Builder.Skills;
using Microsoft.Bot.Connector.Authentication;
using Microsoft.Bot.Schema;
using Microsoft.BotFramework.Composer.Core;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Claims;
using System.Threading;
using System.Threading.Tasks;

namespace Tests
{
    [TestClass]
    public class SkillConversationIdFactoryTests
    {
        private readonly SkillConversationIdFactory _idFactory = new SkillConversationIdFactory(new MemoryStorage());
        private string _botId = Guid.NewGuid().ToString("N");
        private string _skillId = Guid.NewGuid().ToString("N");

        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
        }

        [TestMethod]
        public async Task ShouldCreateCorrectConversationId()
        {
            var claimsIdentity = new ClaimsIdentity();
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.AudienceClaim, _botId));
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.AppIdClaim, _skillId));
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.ServiceUrlClaim, "http://testbot.com/api/messages"));
            var conversationReference = new ConversationReference
            {
                Conversation = new ConversationAccount(id: Guid.NewGuid().ToString("N")),
                ServiceUrl = "http://testbot.com/api/messages"
            };

            var activity = (Activity)Activity.CreateMessageActivity();
            activity.ApplyConversationReference(conversationReference);
            var skill = new BotFrameworkSkill()
            {
                AppId = _skillId,
                Id = "skill",
                SkillEndpoint = new Uri("http://testbot.com/api/messages")
            };

            var options = new SkillConversationIdFactoryOptions
            {
                FromBotOAuthScope = _botId,
                FromBotId = _botId,
                Activity = activity,
                BotFrameworkSkill = skill
            };

            var conversationId = await _idFactory.CreateSkillConversationIdAsync(options, CancellationToken.None);
            Assert.IsNotNull(conversationId);
        }

        [TestMethod]
        public async Task ShouldGetConversationReferenceFromConversationId()
        {
            var claimsIdentity = new ClaimsIdentity();
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.AudienceClaim, _botId));
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.AppIdClaim, _skillId));
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.ServiceUrlClaim, "http://testbot.com/api/messages"));
            var conversationReference = new ConversationReference
            {
                Conversation = new ConversationAccount(id: Guid.NewGuid().ToString("N")),
                ServiceUrl = "http://testbot.com/api/messages"
            };

            var activity = (Activity)Activity.CreateMessageActivity();
            activity.ApplyConversationReference(conversationReference);
            var skill = new BotFrameworkSkill()
            {
                AppId = _skillId,
                Id = "skill",
                SkillEndpoint = new Uri("http://testbot.com/api/messages")
            };

            var options = new SkillConversationIdFactoryOptions
            {
                FromBotOAuthScope = _botId,
                FromBotId = _botId,
                Activity = activity,
                BotFrameworkSkill = skill
            };

            var conversationId = await _idFactory.CreateSkillConversationIdAsync(options, CancellationToken.None);
            Assert.IsNotNull(conversationId);

            var skillConversationRef = await _idFactory.GetSkillConversationReferenceAsync(conversationId, CancellationToken.None);
            Assert.IsTrue(RefEquals(skillConversationRef.ConversationReference, conversationReference));
        }

        [TestMethod]
        public async Task ShouldNotGetReferenceAfterDeleted()
        {
            var claimsIdentity = new ClaimsIdentity();
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.AudienceClaim, _botId));
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.AppIdClaim, _skillId));
            claimsIdentity.AddClaim(new Claim(AuthenticationConstants.ServiceUrlClaim, "http://testbot.com/api/messages"));
            var conversationReference = new ConversationReference
            {
                Conversation = new ConversationAccount(id: Guid.NewGuid().ToString("N")),
                ServiceUrl = "http://testbot.com/api/messages"
            };

            var activity = (Activity)Activity.CreateMessageActivity();
            activity.ApplyConversationReference(conversationReference);
            var skill = new BotFrameworkSkill()
            {
                AppId = _skillId,
                Id = "skill",
                SkillEndpoint = new Uri("http://testbot.com/api/messages")
            };

            var options = new SkillConversationIdFactoryOptions
            {
                FromBotOAuthScope = _botId,
                FromBotId = _botId,
                Activity = activity,
                BotFrameworkSkill = skill
            };

            var conversationId = await _idFactory.CreateSkillConversationIdAsync(options, CancellationToken.None);
            Assert.IsNotNull(conversationId);

            var skillConversationRef = await _idFactory.GetSkillConversationReferenceAsync(conversationId, CancellationToken.None);
            Assert.IsTrue(RefEquals(skillConversationRef.ConversationReference, conversationReference));

            await _idFactory.DeleteConversationReferenceAsync(conversationId, CancellationToken.None);

            var skillConversationRefAfterDeleted = await _idFactory.GetSkillConversationReferenceAsync(conversationId, CancellationToken.None);
            Assert.IsNull(skillConversationRefAfterDeleted);
        }

        private bool RefEquals(ConversationReference ref1, ConversationReference ref2)
        {
            return ref1.Conversation.Id == ref2.Conversation.Id && ref1.ServiceUrl == ref2.ServiceUrl;
        }
    }
}

