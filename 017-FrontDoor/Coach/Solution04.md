### Notes for Challenge 4 - Cache Static Assets

 [< Previous Challenge [3]](./Solution03.md) - **[Home](./README.md)**


This article [https://docs.microsoft.com/en-us/azure/frontdoor/front-door-tutorial-rules-engine](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-tutorial-rules-engine)

We are going to create a single rule that redirects anything that comes in via HTTP to HTTPs.  This is where we look at the "Request Protocol" of HTTP.

![](./RuleExample.png)

After the Rules engine is created it needs to be applied to each Backend.