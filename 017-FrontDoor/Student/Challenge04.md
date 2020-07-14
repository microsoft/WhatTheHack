# Challenge 4 - Cache Static Assets

[< Previous Challenge [3]](./Challenge03.md)&nbsp;&nbsp;-&nbsp;&nbsp;**[Home](../README.md)**

## Pre-requisites

- Complete [Challenge 3](./Challenge03.md)

## Introduction

We now have a globally scaled website, protected by WAF, and routing traffic for a specific address that uses a different backend to relieve pressure on our current website.  Now it's the time for us to perform our last optimization, caching.  We have analyzed the website, and found the following URLs are static:
- Everything starting with **/css**
- Everything starting with **/images**
- Everything starting with **/js**
- Everything starting with **/lib**
- Special Message Page: **/Message**

We can use the new [Rules Engine in Front Door](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-rules-engine) to specifies rules to cache the various resources.

## Description

For this challenge we are going to:
1. Create a Rules Engine for Front Door and associate to all Routing rules
2. Create individual rules to override the Routing to cache every unique url for a duration of 10 minutes at a time.

## Success Criteria

- Demonstrate the website still works thru Front Door via https://frontdoor.***SITENAME***.contosomasks.com
  - Notice in the Dev Tools on successive requests (without clearing cache), all requests for the listed resources are showing either:
    -  Status 200 with the Size being (disk cache) or (memory cache) - This means it cached on the client
    -  Status of 304 (unchanged) - This means the client cache isn't different than the server version
  
## Learning Resources

- [Azure Front Door Rules Engine Matching Criteria](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-rules-engine-match-conditions)
- [Azure Front Door Rules Engine Actions](https://docs.microsoft.com/en-us/azure/frontdoor/front-door-rules-engine-actions)

