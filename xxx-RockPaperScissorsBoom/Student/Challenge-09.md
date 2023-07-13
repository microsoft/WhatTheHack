# Challenge 09 - Leverage Azure CDN

[< Previous Challenge](./Challenge-08.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-10.md)

## Introduction

In this simple challenge you will leverage Azure CDN for serving static content.

A content delivery network (CDN) is a distributed network of servers that can efficiently deliver web content to users. CDNs store cached content on edge servers in point-of-presence (POP) locations that are close to end users, to minimize latency. [Read more](https://docs.microsoft.com/en-us/azure/cdn/cdn-overview).

## Description

- Update the app's HTML to use CDN for static content (CSS and JS files) rather than serving it directly from the host.

## Success Criteria

To complete this challenge successfully, you should be able to:

- The Rock/Paper/Scissors and Boom images on the home page of the app are served from CDN.
- Verify that your cached static content is not downloaded more than once during the cache duration. You can verify this by inspecting the request with Developer Tools in most modern browsers.

## Learning Resources

- [Azure Front Door](https://learn.microsoft.com/en-us/azure/frontdoor/create-front-door-cli)

## Tips

- Use Azure Front Door to serve static content from CDN via caching on a route.
