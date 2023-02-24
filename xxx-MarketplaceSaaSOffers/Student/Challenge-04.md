# Challenge 04 - Decoding purchase tokens

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites

You must have completed **Challenge 03 - Emulate!**

## Introduction

When a customer indicates their intention to purchase your solution in the marketplace, they are directed to your
landing page. The query string contains a token that is used to understand some basic details about the customer and
their desired purchase. The landing page is also your opportunity to capture any additional information as part of the
onboarding journey and confirm the customer's purchase.

In Challenge 01, we started work on our own landing page. We extracted the token from the query string and stored it
in a variable. In this challenge we will extend our landing page by adding functionality to decode purchase tokens.

## Description

In this challenge we will extend our landing page by calling the marketplace `resolve` API to decode a purchase token
and display some details from the decoded token in the landing page UI.

In Challenge-01, you were working in the client-side JavaScript. In practice, most of the work will be done server-side
to avoid cross-domain issues and manage the authentication with the marketplace APIs. In this challenge you will be
implementing an API that will act as a proxy, calling the marketplace `resolve` API on behalf of our client-side JavaScript.

The server component is a Node.js Express application written in TypeScript. You shouldn't have to concern yourself with
the Node / Express aspects (aside from the pre-requisites) but you will be writing some TypeScript.

The client-side function is already implemented for you as `decodeButtonClick()` in `landing.html`. This calls
`api/resolve` which is the API we need to implement. Routing has been configured to route POST requests to `api/resolve`
to the TypeScript function `resolveToken()` defined in `src/service/api.ts`.

In this challenge we will only be concerned with the function `resolveToken()` in `src/service/api.ts`. The function
currently has an empty implementation.

Your task it to update the `resolveToken()` implementation to call the marketplace `resolve` API and return the result
to the caller handling any errors along the way.

The emulator should be available on `http://localhost:3978`

- Validate the request (check there is a token etc)
- Call the marketplace `resolve` API, passing the token in the header
- Check the result and return an appropriate status code
- If the call is successful, return the result as JSON

## Success Criteria

To complete this challenge successfully, you should be able to:

- Make sure the emulator is running & start your application
- Make sure the Landing Page URL is set to point to your application landing page
  - This can be set on the emulator "Config" page or as an environment variable (see Learning resources)
- Navigate to `http://localhost:3000/` and click the "Resolve Token" button
  - Confirm that a suitable http error code is logged to the console and a message displayed in the UI
- Navigate to `http://localhost:3000/?token=` and click the "Resolve Token" button
  - Confirm that a suitable http error code is logged to the console and a message displayed in the UI
- Navigate to `http://localhost:3000/?token=abc` and click the "Resolve Token" button
  - Confirm that a suitable http error code is logged to the console and a message displayed in the UI
- Visit the emulator "Marketplace Token" page and set
  - `offerId` to "flat-rate"
  - `planId` to "flat-rate-1"
- Click "Generate token" and then "Post to landing page"
  - Confirm that your landing page appears
- Click "Get Token from query string" then "Resolve Token"
  - Confirm that the token has been decoded and its properties are displayed in the resolve token section

## Learning Resources

- [Marketplace resolve API](https://learn.microsoft.com/azure/marketplace/partner-center-portal/pc-saas-fulfillment-subscription-api#post-httpsmarketplaceapimicrosoftcomapisaassubscriptionsresolveapi-versionapiversion)
- [README for the marketplace emulator](https://github.com/microsoft/Commercial-Marketplace-SaaS-API-Emulator/blob/main/README.md)
- [Configuring the emulator](https://github.com/microsoft/Commercial-Marketplace-SaaS-API-Emulator/blob/main/docs/config.md)
- [Intro to TypeScript](https://www.typescriptlang.org/docs/)
- [The Express request object](http://expressjs.com/en/4x/api.html#req)

## Tips

- **publisherId** - to call the marketplace APIs, the marketplace needs to know the identity of the caller. Ordinarily
this would be extracted from the AAD bearer token. With the emulator, we don't require AAD so we need some other
way of providing an identity. We do this by adding a query string parameter `publisherId` on the request. For more
details, see the emulator README.
- In the application, a `publisherId` is available on the `Config` type, available at `req.app.locals.config`
- `Config` also contains a `baseUrl` you can use. This is generally set to `http:\\localhost:3978` unless you are using
Dev Containers in VS Code. In this case localhost cannot be used and a shared Docker network is required.
- You can see the routing configuration to map route `api/resolve` to `resolveToken()` in `index.ts` line 34
