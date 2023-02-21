# Challenge 03 - Emulate!

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites

You must have completed **Challenge 02 - Installing the emulator**

## Introduction

Now we have the emulator working, we can exercise it a little to get a feel for the APIs and understand the emulator features.

As well as emulating the marketplace SaaS Fulfillment APIs, the emulator also offers some configuration UI and simple
implementations of a landing page and webhook. We will implement our own landing page and webhook as we work through
later challenges. For now, it will be useful to explore an end-to-end purchase scenario using the built-in emulator features.

When you browse to the emulator, you will be presented with the emulator homepage and a menu showing the pages available:

- "Marketplace Token" (homepage)
  - Here you can configure and generate "synthetic" purchase tokens similar to ones used by the marketplace
  - The format of marketplace tokens is undocumented - we can consider them to be opaque
  - The only thing to keep in mind is that they are not interchangeable between emulator and marketplace
- Subscriptions
  - Displays details of the current subscriptions (purchases) and their status
  - On this page you can also simulate marketplace actions (eg the user may request a plan change via the portal)
- Landing Page
  - This is the default, built-in landing page implementation
  - This page will automatically decode the token from the token query string parameter in the URL
- Config
  - Here, various aspects of the emulator can be configured
  - eg when we have built our own landing page, we could configure the emulator to use it here

## Description

The emulator should be available on `http://localhost:3978`

In this challenge we will configure and generate a purchase token, simulate a "configure my subscription" request from
the marketplace and activate the subscription. Finally we will try to change to a new plan and unsubscribe from the offer.

- Make sure the emulator is running
- Visit the "Marketplace Token" page and set
  - `offerId` to "flat-rate"
  - `planId` to "flat-rate-1"
  - `purchaser emailId` to "bob@constoso.com"
- Select `Copy to clipboard` and decode the token using a suitable utility (the token is base64 encoded)
- Select `Post to landing page` and observe the purchase token details
- Activate the subscription and visit the `Subscriptions` page to check the status
- On your subscription, select "Change Plan" and enter "abc123" as the new plan
- On your subscription, select "Change Plan" and enter "flat-rate-2" as the new plan
  - This simulates a user action via marketplace (eg in the Azure Portal) to request a plan change on the subscription
- Observe the state change (which may take a few seconds)
- On your subscription, select "Unsubscribe"
  - This simulates a user action via marketplace (eg in the Azure Portal) to unsubscribe from an offer
- Observe the state change (which may take a few seconds)

## Success Criteria

To complete this challenge successfully, you should be able to:

- Navigate to each of the four pages of the emulator in turn
- Generate a purchase token and decode it using any Base64 decoder utility
  - Confirming the result matches the original JSON token
- Post the purchase token to the built-in landing page and confirm the displayed details are as follows
  - `Offer ID` = "flat-rate"
  - `Plan ID` = "flat-rate-1"
  - `Purchaser Email` = "bob@constoso.com"
  - `PublisherId` = "FourthCoffee"
- Observe the newly created subscription on the `Subscriptions` page is initially in the `Subscribed` state
- Observe that attempting to change plan that is not defined in the offer results in an HTTP 400 response
- Observe that changing to a valid plan results in an HTTP 202 response
- Observe that the valid plan change gets reflected in the UI after a delay of a few seconds
- Observe that the status of the subscription changes to "Unsubscribed" on clicking "Unsubscribe"

## Learning Resources

[Decode from Base64 with GCHQ's CyberChef](https://gchq.github.io/CyberChef/)
[States of a SaaS subscription](https://learn.microsoft.com/azure/marketplace/partner-center-portal/pc-saas-fulfillment-life-cycle#states-of-a-saas-subscription)
[Implementing a webhook on the SaaS service](https://learn.microsoft.com/azure/marketplace/partner-center-portal/pc-saas-fulfillment-webhook)

## Tips

- Make a note of the `id` on the "Marketplace Token" page before posting to the landing page so you can track the
status on the "Subscriptions" page
- When you click buttons on the "Subscriptions" page, this simulates actions in the marketplace that generate webhook calls.
Some of these calls need to be handled and some are just "FYI".
- We will implement a webhook handler later, for now the emulator's built-in handler is working for us. For more
information see "Implementing a webhook on the SaaS service" in the Learning Resources section
