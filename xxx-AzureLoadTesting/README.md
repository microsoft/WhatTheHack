# What The Hack - xxx-AzureLoadTesting

## Introduction
Azure Load Testing Service (Preview) enables developers and testers to generate high-scale load that reveal actionable insights into app performance, scalability, capacity - and ultimately resiliency - with a fully managed service.

## Learning Objectives
This hack is designed to introduce you to Azure Load Testing and guide you through a series of hands-on challenges to accomplish the following:

- Leverage a cloud-based load testing service with high fidelity support for JMeter and new/existing JMeter scripts
- Build a comprehensive view of curated client and server metrics with actionable insights into app performance
- Integrate with CI/CD workflows for automated, collaborative load-testing
- Perform load testing in conjunction with Azure Chaos Studio to ensure resiliency during an application/service/region degradation or failure

## Challenges
1. Challenge 01: **[Develop a Load Testing Strategy](Student/Challenge-01.md)**
	 - How to develop a load testing strategy for your application
1. Challenge 02: **[Create Load Testing Script(s)](Student/Challenge-02.md)**
	 - Creating JMeter scripts to support your load testing strategy
1. Challenge 03: **[Create Azure Load Testing Service and Establish Baselines](Student/Challenge-03.md)**
	 - Create Azure Load Testing Service and learn techniques on how to establish baselines for your application
1. Challenge 04: **[Enable Automated Load Testing (CI/CD)](Student/Challenge-04.md)**
	 - Incorporating load testing into your CI/CD Pipeline
1. Challenge 05: **[Identify & Remediate Bottlenecks](Student/Challenge-05.md)**
	 - Reviewing load test results and identifying bottlenecks
1. Challenge 06: **[Stress & Multi-region Testing](Student/Challenge-06.md)**
	 - How to perform stress tests and the difference between your load tests
1. Challenge 07: **[ Load Testing During Chaos Experiment](Student/Challenge-07.md)**
	 - Incorporating load testing and chaos experiments together

## Prerequisites
- Familiarality with the fundamentals of load testing.
- Azure subscription for creating the Load Testing service and running the sample application.
- GitHub or Azure DevOps to automate load testing in your CI/CD pipelines.
- You will need an application deployed to Azure with a public endpoint to test against for the hack. If you want to load test the application across regions (and use a global load balancer like Azure Front Door), you will need to deploy it to multiple regions. This is especially critical since this will factor into the overall resiliency of the application. For the application, you have two options:
    - Deploy your own, existing application
        - If you want to load test your own application, be sure you are load testing against a non-production, isolated environment. Ensure that every component you are testing against is not shared with production in any way - otherwise you risk impacting the availability of your production environment.
    - Deploy a sample application
        - The sample application consists of a Node.js web API, which interacts with a NoSQL database. You'll deploy the web API to Azure App Service web apps and use Azure Cosmos DB as the database. Follow the steps [here](https://docs.microsoft.com/en-us/azure/load-testing/tutorial-identify-bottlenecks-azure-portal#deploy-the-sample-app) to deploy the sample application.
- 

## Repository Contents (Optional)
- `./Coach/Guides`
  - Coach's Guide and related files
- `./images`
  - Generic image files needed
- `./Student/Guides`
  - Student's Challenge Guide

## Contributors
- Kevin M. Gates
- Andy Huang
