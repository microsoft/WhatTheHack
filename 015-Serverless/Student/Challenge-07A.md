# Optional Challenge 07A - Scale the Cognitive Service

[< Previous Challenge](./Challenge-07.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07B.md)

## Pre-requisites

- [Challenge 07 - Monitoring](./Challenge-07.md) should be done successfuly.

## Introduction

In this challenge, you will change the Computer Vision API to the Free tier. This will limit the number of requests to the OCR service to 10 per minute. Once changed, run the UploadImages console app to upload 1,000 images again. The resiliency policy programmed into the FindLicensePlateText.MakeOCRRequest method of the ProcessImage function will begin exponentially backing off requests to the Computer Vision API, allowing it to recover and lift the rate limit. This intentional delay will greatly increase the function&#39;s response time, thus causing the Consumption plan&#39;s dynamic scaling to kick in, allocating several more servers. You will watch all of this happen in real time using the Live Metrics Stream view.

## Description

1. Change the Computer Vision service to the Free tier
2. Start a new instance of the UploadImages project.  Press 2 in the console.
3. Observe the Live Metrics Stream.  After running for a couple of minutes, you should start to notice a few things. The Request Duration will start to increase over time. As this happens, you should notice more servers being brought online. Each time a server is brought online, you should see a message in the Sample Telemetry stating that it is &quot;Generating 2 job function(s)&quot;, followed by a Starting Host message. You should also see messages logged by the resilience policy that the Computer Vision API server is throttling the requests. This is known by the response codes sent back from the service (429). A sample message is &quot;Computer Vision API server is throttling our requests. Automatically delaying for 32000ms&quot;.
4. Return the Computer Vision service to S1 Standard

## Success Criteria

1. You have received a 429 error code