# Challenge 04 - Datadog for Applications

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

To ensure performance requirements are met for eShopOnWeb, you will need to detect performance anomalies, diagnose issues, and understand what users are actually doing on the website. You will deploy configure Datadog Dotnet APM to allow for continuous performance and usability monitoring. 

## Description

- Create a Browser, ICMP and API test for your eShopWeb webpage using Datadog Synthetics. What are the differences? Which type of test will tell you what? 
- Enable server-side telemetry in the eShoOnWeb Web project 
    - For Datadog agent configuration: 
        - Add the environment variables to your host VM 
        - Configure the Datadog agent, ensuring APM is enabled 
        - Enable logging 
- Enable RUM (Real User Monitoring) for your eShoponWeb application. 
    - Inject RUM snippet into your code 
- Create a Monitor to get triggered when execption happen. 
    - Run the eShopOnWeb Web project locally and check out the Synthetics and RUM results in Datadog 
    - To create a Monitor, try changing the user login password on the eShoponWeb web page 
    - Find the exception in Datadog APM 
    - Create Monitors based on URL availability and errors 

## Success Criteria

To complete this challenge successfully, you should be able to:
- Show the errors in Datadog and the Alert fired 
- Show that the client browser data is showing up in RUM 

## Learning Resources

_List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge._

*Think of this list as giving the students a head start on some easy Internet searches. However, try not to include documentation links that are the literal step-by-step answer of the challenge's scenario.*

***Note:** Use descriptive text for each link instead of just URLs.*

*Sample IoT resource links:*

- [What is a Thingamajig?](https://www.bing.com/search?q=what+is+a+thingamajig)
- [10 Tips for Never Forgetting Your Thingamajic](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
- [IoT & Thingamajigs: Together Forever](https://www.youtube.com/watch?v=yPYZpwSpKmA)