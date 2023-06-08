# Challenge 09 - Leverage Azure CDN

[< Previous Challenge](./Challenge-08.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-10.md)

## Introduction

In this simple challenge you will leverage Azure CDN for serving static content.

A content delivery network (CDN) is a distributed network of servers that can efficiently deliver web content to users. CDNs store cached content on edge servers in point-of-presence (POP) locations that are close to end users, to minimize latency. [Read more](https://docs.microsoft.com/en-us/azure/cdn/cdn-overview).

## Description

1. Update the app's HTML to use CDN for static content (CSS and JS files) rather than serving it directly from the host.
1. For this challenge you will need to update the HTML code of your application. Use an editor like VS Code or Notepad. If you're working in Azure Cloud Shell, you can invoke the Cloud Shell editor. Learn more aboug it [here](https://azure.microsoft.com/en-us/blog/cloudshelleditor/).

## Success Criteria

To complete this challenge successfully, you should be able to:

1. The Rock/Paper/Scissors and Boom images on the home page of the app are served from CDN.
1. Verify that your cached static content is not downloaded more than once during the cache duration. You can verify this by inspecting the request with Developer Tools in most modern browsers.
1. In GitHub, make sure you documented the different commands you have used to update or provision your infrastructure. It could be in a `.md` file or in `.sh` file. You will complete this script as you are moving forward with the further challenges.
1. In Azure DevOps (Boards), from the Boards view, you could now drag and drop the user story associated to this Challenge to the `Resolved` or `Closed` column, congrats! ;)

## Learning Resources

1. [Compare Azure CDN product features](https://docs.microsoft.com/en-us/azure/cdn/cdn-features)

## Tips

1. [Azure CDN and Azure Web Apps](https://docs.microsoft.com/en-us/azure/cdn/cdn-add-to-web-app)
