# Challenge 08 - Leverage the Azure CDN

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-09.md)

## Introduction

In this simple challenge you will leverage the Azure CDN for serving static content.

A content delivery network (CDN) is a distributed network of servers that can efficiently deliver web content to users. CDNs store cached content on edge servers in point-of-presence (POP) locations that are close to end users, to minimize latency. [Read more](https://docs.microsoft.com/en-us/azure/cdn/cdn-overview).

## Description

- Add an Azure Front Door
- Configure the Front Door route for non-cached traffic to your App Service
- Configure it to cache static content (CSS and JS files) rather than serving them from the App Service
  > Note: You shouldn't cache all requests coming in through Front Door (such as API calls, etc.). You should only cache static content.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify that the Rock/Paper/Scissors and Boom images on the home page of the app are served from the CDN.
- Verify that your cached static content is not downloaded more than once during the cache duration. You can verify this by inspecting the request with Developer Tools in most modern browsers.

## Learning Resources

- [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/create-front-door-cli)

## Tips

- Use Azure Front Door to serve static content from the CDN via caching on a route.
- Make sure you are only caching static content and not all requests.
