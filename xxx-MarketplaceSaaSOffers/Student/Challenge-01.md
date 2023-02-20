# Challenge 01 - Creating a landing page

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

There are 4 principle actors in the process that manages the lifecycle of transactable SaaS offers in the marketplace:

- The marketplace itself (and the storefront the user interacts with eg the Azure portal, AppSource)
- A landing page for your solution for new customer onboarding
- A webhook for your solution to listen for messages from the marketplace
- An "integrations services" component that can call marketplace APIs on behalf of your appplication

![marketplace actors](Images/Challenge1.png)

We will cover all these areas in this *What The Hack*. In this challenge we will start with the landing page which
is critical to the new customer onboarding experience.


When a customer indicates their intention to purchase your solution in the marketplace, they are directed to your
landing page. The query string contains a token that is used to understand some basic details about the customer and
their desired purchase. The landing page is also your opportunity to capture any additional information as part of the
onboarding journey and confirm the customer's purchase.

## Description

In this challenge you will configure an initial landing page for your solution. A skeleton application that will be
used throghout the hack can be found in the /Challenge01 folder of the Resources.zip file provided by your coach.

In this challege you will be working on the `landing.html` file which can be found in the `src/client` folder.
There are a number of Javascript stub methods in landing.html. In this challenge we will only be concerned
with the function `queryButtonClick`.

Please update `queryButtonClick` in `landing.html` to:

- Extract the query parameters from the URL
- Extract the value of the `token` query string paramater
- Assign it to the `token` variable at the module scope

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that your landing page displays when you hit F5 / Run + Debug
- Verify that the token from the query string is display when a user clicks the button

## Learning Resources

- [Build the landing page for your transactable SaaS offer in the commercial marketplace](https://learn.microsoft.com/azure/marketplace/azure-ad-transactable-saas-landing-page)
- [Managing the SaaS subscription life cycle](https://learn.microsoft.com/azure/marketplace/partner-center-portal/pc-saas-fulfillment-life-cycle)
