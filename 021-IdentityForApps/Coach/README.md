# Identity for Developers

## Introduction

Welcome to the coach's guide for the Identity for Developers Hack. Here you will find links to specific guidance for coaches for each of the challenges.

## Challenges

Challenge 0: **[Prepare Your Environment for B2C](./00-pre-reqs.md)**

- Get yourself ready to develop Identity solutions

Challenge 1: **[Getting Started with B2C](./01-provision-b2c.md)**

- Provision a B2C Tenant

Challenge 2: **[Sign Me Up! Sign Me In!](./02-susi.md)**

- Create a simple Sign Up and Sign In user flow and test it in the Azure AD B2C portal

Challenge 3: **[External Identity Providers](./03-external-idp.md)**

- Set up the ability for your users to log in to your app with a GitHub, Facebook, or Gmail identity

Challenge 4: **[Logos, Colors, and Custom Text](./04-l14n.md)**

- Add a bit of flare to your sign up and sign in pages by adding a custom template and colors, wiring up your User Flows to an ASPNETCORE MVC app, and use language customization to modify string values displayed to the user

Challenge 5: **[Claims Enrichment - The ID Verify-inator!!](./05-claims-enrichment.md)**

- Enrich the claims that you collect about a user during the sign up process by calling out to a custom REST API

Challenge 6: **[Conditional Access - Are You Who You Say You Are?](./06-conditional-access.md)**

- Create and enforce Conditional Access policies in your tenant such as enforcing MFA (including Microsoft Authenticator) and detecting Risky Login Behavior

Challenge 7: **[Admin the B2C Tenant with MS Graph](./07-admin-graph.md)**

- Use the MS Graph API to query your B2C tenant. Also use the Graph API to update various objects in your B2C tenant, such as policies, keys, and identity providers.

Challenge 8: **[Preparation for Identity Experience Framework](./08-prepare-ief.md)**

- We'll need custom policies, so let's get things ready. Apply the Trust Framework and also create an OIDC IdP for your external IdP

Challenge 9: **[Creating Custom Policies](./09-custom-policy.md)**

- Implement a custom policy for Sign In that will call to your custom REST API to perform claims enrichment for users that signed up prior to Challenge 5. Also, we'll break the Sign Up and Sign In policy to be just a Sign Up policy.

Challenge 10: **[Getting Insights Into B2C](./10-appinsights.md)**

- Enable App Insights in your custom policy so you can track a user through the various steps in the Orchestration. Add custom events to your Orchestration and track them in App Insights.

Challenge 11: **[Parameterize Your Policies](./11-parameterize.md)**

- Take your custom policies and parameterize the values that could change from environment to environment, and use the B2C extension to VS Code to generate environment-specific policy files.

Challenge 12: **[Hey, What's Going On In My B2C Tenant??](./12-monitor.md)**

- Monitor your B2C tenant by combining logs and app insights logs