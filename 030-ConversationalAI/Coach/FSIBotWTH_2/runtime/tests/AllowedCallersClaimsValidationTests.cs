// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

using System;
using System.Collections.Generic;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.Bot.Connector.Authentication;
using Microsoft.BotFramework.Composer.Core.Settings;
using Microsoft.BotFramework.Composer.WebAppTemplates.Authorization;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Tests
{
    [TestClass]
    public class AllowedCallersClaimsValidationTests
    {
        [TestMethod]
        public void AcceptNullAllowedCallersArray()
        {
            var validator = new AllowedCallersClaimsValidator(new BotSkillConfiguration());
        }

        [TestMethod]
        public void AcceptEmptyAllowedCallersArray()
        {
            var validator = new AllowedCallersClaimsValidator(new BotSkillConfiguration()
            {
                AllowedCallers = new string[0]
            });
        }

        [TestMethod]
        public async Task AllowAnyCaller()
        {
            var validator = new AllowedCallersClaimsValidator(new BotSkillConfiguration()
            {
                AllowedCallers = new string[] { "*" }
            });
            var callerAppId = "BE3F9920-D42D-4D3A-9BDF-DBA62DAE3A00";
            var claims = CreateCallerClaims(callerAppId);

            await validator.ValidateClaimsAsync(claims);
        }

        [TestMethod]
        public async Task AllowedCaller()
        {
            const string callerAppId = "BE3F9920-D42D-4D3A-9BDF-DBA62DAE3A00";
            var validator = new AllowedCallersClaimsValidator(new BotSkillConfiguration()
            {
                AllowedCallers = new string[] { callerAppId }
            });

            var claims = CreateCallerClaims(callerAppId);

            await validator.ValidateClaimsAsync(claims);
        }

        [TestMethod]
        public async Task AllowedCallers()
        {
            const string callerAppId = "BE3F9920-D42D-4D3A-9BDF-DBA62DAE3A00";
            var validator = new AllowedCallersClaimsValidator(new BotSkillConfiguration()
            {
                AllowedCallers = new string[] { "anotherId", callerAppId }
            });

            var claims = CreateCallerClaims(callerAppId);

            await validator.ValidateClaimsAsync(claims);
        }

        [TestMethod]
        [ExpectedException(typeof(UnauthorizedAccessException))]
        public async Task NonAllowedCallerShouldThrowException()
        {
            var callerAppId = "BE3F9920-D42D-4D3A-9BDF-DBA62DAE3A00";
            var validator = new AllowedCallersClaimsValidator(new BotSkillConfiguration()
            {
                AllowedCallers = new string[] { callerAppId }
            });

            var claims = CreateCallerClaims("I'm not allowed");

            await validator.ValidateClaimsAsync(claims);
        }

        private List<Claim> CreateCallerClaims(string appId)
        {
            return new List<Claim>()
            {
                new Claim(AuthenticationConstants.AppIdClaim, appId),
                new Claim(AuthenticationConstants.VersionClaim, "1.0"),
                new Claim(AuthenticationConstants.AudienceClaim, "5BA599BD-F9E9-48D3-B98D-377BB2A0EAE9"),
            };
        }
    }
}
