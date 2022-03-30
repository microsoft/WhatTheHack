# Challenge 02 - Create Loading Testing Service & Script(s)

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Pre-requisites

- Before creating or using your load testing scripts, ensure you have outlined your load testing strategy as described in the previous challenge.
- You will need an Azure subscription to create the Load Testing service and host the sample application.

## Introduction

In this challenge, you will create the Load Testing service in Azure, deploy an application to load test against and create one or more load testing scripts. Your load testing scripts should be designed to implement the load testing *strategy* you created in the previous challenge. 

You will need an application deployed to Azure with a public endpoint to test against for the hack. You have two options:

- Deploy a sample application:
    - The [sample application](https://github.com/Azure-Samples/nodejs-appsvc-cosmosdb-bottleneck) consists of a Node.js web API, which interacts with a NoSQL database. 
- Deploy your own application:
    - If you want to load test your own application, be sure you are load testing against a non-production, isolated environment. Ensure that every component you are testing against is not shared with production in any way - otherwise you risk impacting the availability of your production environment.

Azure Load Testing is based on JMeter - a popular open source load testing tool. This means you can reuse existing JMeter scripts or create new scripts by referencing existing JMeter documentation.

## Description

- Create a Load Testing service in Azure.
- Deploy the [sample application](https://docs.microsoft.com/en-us/azure/load-testing/tutorial-identify-bottlenecks-azure-portal#deploy-the-sample-app) in the same region as your Load Testing service.
    - If you want to load test the application across regions, you will need to deploy it to multiple regions. This is especially critical since this will factor into the overall resiliency of the application.
- Based on the load testing strategy you created in the previous challenge, create one or more load testing scripts. Your scripts be designed to help you get a baseline for how the application can handle typical user loads.

## Success Criteria

- You have a Load Testing service running in Azure.
- You have a sample application deployed with a publicly accessible endpoint.
- You have one or more load testing scripts (.jmx) and relevant configuration/data files to emulate typical loads.

## Learning Resources

- [Load Testing documentation](https://docs.microsoft.com/en-us/azure/load-testing/)
- [Node.js sample application](https://docs.microsoft.com/en-us/azure/load-testing/tutorial-identify-bottlenecks-azure-portal#deploy-the-sample-app)
- [Apache JMeter Docs](https://jmeter.apache.org/index.html)
- [Create Test Plan from Template](https://jmeter.apache.org/usermanual/get-started.html#template)
- [JMeter best practices](https://jmeter.apache.org/usermanual/best-practices.html)
- [Custom Plugins for Apache JMeter](https://jmeter-plugins.org/)

## Tips
- You may choose to create JMeter scripts in the native JMeter GUI to take advantage of the templates and other features it offers. That is out of the scope of this WTH, but you can find instructions for doing so [here](https://jmeter.apache.org/usermanual/get-started.html#install).
