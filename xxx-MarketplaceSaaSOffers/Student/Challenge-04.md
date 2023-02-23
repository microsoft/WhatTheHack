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

The emulator should be available on `http://localhost:3978`

In this challenge we will extend our landing page by calling the marketplace `resolve` API to decode a purchase token
and display some details from the decoded token in the landing page UI.

In this challenge we will only be concerned with the function `decodeButtonClick()` in `landing.html`.

Your task is to update the function `decodeButtonClick()` in `landing.html` to:

- Call the `resolve` API, passing the purchase token in the payload
- On failure, display a message to the user and stop processing 
- On success, extract the result and display it in the element with id `decoded-token` 
- Assign the subscription id in the result to the variable `subscription` (already declared at block scope)
- Assign the plan id in the result to the variable `plan` (already declared at block scope)
- Note, jQuery is already referenced on the page for you to use if you would like

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

- [Decode from Base64 with GCHQ's CyberChef](https://gchq.github.io/CyberChef/)
- [States of a SaaS subscription](https://learn.microsoft.com/azure/marketplace/partner-center-portal/pc-saas-fulfillment-life-cycle#states-of-a-saas-subscription)
- [Implementing a webhook on the SaaS service](https://learn.microsoft.com/azure/marketplace/partner-center-portal/pc-saas-fulfillment-webhook)

## Tips

- Make a note of the `id` on the "Marketplace Token" page before posting to the landing page so you can track the
status on the "Subscriptions" page
- When you click buttons on the "Subscriptions" page, this simulates actions in the marketplace that generate webhook calls.
Some of these calls need to be handled and some are just "FYI".
- We will implement a webhook handler later, for now the emulator's built-in handler is working for us. For more
information see "Implementing a webhook on the SaaS service" in the Learning Resources section
