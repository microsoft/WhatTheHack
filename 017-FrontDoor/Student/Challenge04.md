# Challenge 4 - Offload traffic for a high traffic event

[< Previous Challenge [3]](./Challenge03.md)&nbsp;&nbsp;-&nbsp;&nbsp;**[Home](../README.md)**&nbsp;&nbsp;-&nbsp;&nbsp;[Next Challenge [5] >](./Challenge05.md)

## Introduction

Things are going well.  The website is able to handle global traffic well and you are keeping the bad traffic out.  What else could go wrong?

Well, you had to ask.  

Change in events have caused a shift where everyone needs to work from home!  You need to get that message out, but that message is getting a significant amount of load. The direct link, /Message, got distributed by random people all over the internet and people are just constantly refresh/reloading that one page to get the latest information.

When you are faced with massive amounts of *valid* traffic for a specific page, the concept is called traffic shaping, where you use something like Front Door to direct traffic to different backend origins to host your content.  This is very commonly done in eCommerce for those burst events such as Black Friday, Cyber Monday, Single's Day, Boxing Day, etc...  Those are well planned out, and use a different DNS name, such as "deals.contosomasks.com".  

In this case, we don't have that luxury as the business put out an initial piece of content located at /Message.  Don't worry, Front Door and Azure Storage has your covered!  The Azure Storage service has a feature called [Static Web Site hosting](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website).  Sounds great?  For convenience, you can download the static version of /Message [here](https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/andywahr/WhatTheHack/blob/master/017-FrontDoor/Student/Resources/Challenge03).

## Description

For this challenge we are going to:
1. Provision a Azure Storage Account and create a Static Web Site from the static version of the /Message route
   1. You will need to unzip the static version of /Messages to a temporary location
   2. Upload the contents of that folder to the location in Azure Storage Account for the Static Web Site
2. Configure Front Door to direct /Message requests to the new Static Web Site with Routing Rules

## Success Criteria

- Demonstrate the website thru Front Door via https://frontdoor.***SITENAME***.contosomasks.com/Message works
  - ***HINT*** - The first line of the web page will also include the text:
&nbsp; `(And now from home!)`

## Learning Resources

- [Azure Blob Storage](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blobs-introduction)
- [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/)


