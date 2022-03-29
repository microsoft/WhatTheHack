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
1. Challenge 02: **[Create Loading Testing Script(s)](Student/Challenge-02.md)**
	 - Creating JMeter scripts to support your load testing strategy
1. Challenge 03: **[Establish Baselines](Student/Challenge-03.md)**
	 - Learn techniques on how to establish baselines for your application
1. Challenge 04: **[Enable Automated Load Testing (CI/CD)](Student/Challenge-04.md)**
	 - Incorporating load testing into your CI/CD Pipeline
1. Challenge 05: **[Identify & Remediate Bottlenecks](Student/Challenge-05.md)**
	 - Reviewing load test results and identifying bottlenecks
1. Challenge 06: **[Stress & Multi-region Testing](Student/Challenge-06.md)**
	 - How to perform stress tests and the difference between your load tests
1. Challenge 07: **[ Load Testing During Chaos Experiment](Student/Challenge-07.md)**
	 - Incorporating load testing and chaos experiments together
## Prerequisites
- GitHub or Azure DevOps to automate load testing in your CI/CD pipelines.
- We assume you are familiar with the fundamentals of load testing.
- You will need a public application endpoint to test against for the WTH - whether it is running in Azure, on-prem or another cloud. You have two options:
    - Deploy your own, existing application
        - If you want to load test your own application, be sure you are load testing against a non-production, isolated environment. Ensure that every component you are testing against is not shared with production in any way - otherwise you risk impacting the availability of your production environment.
    - Deploy a sample application
        - The sample application consists of a Node.js web API, which interacts with a NoSQL database. You'll deploy the web API to Azure App Service web apps and use Azure Cosmos DB as the database. Follow the steps [here](https://docs.microsoft.com/en-us/azure/load-testing/tutorial-identify-bottlenecks-azure-portal#deploy-the-sample-app) to deploy the sample application.
- If you want to load test the application across regions, you will need to deploy it to multiple regions. This is especially critical since this will factor into the overall resiliency of the application.
- You may choose to create JMeter scripts in the native JMeter GUI to take advantage of the templates and other features it offers. That is out of the scope of this WTH, but you can find instructions for doing so [here](https://jmeter.apache.org/usermanual/get-started.html#install).

## Other Considerations
- Measure typical loads on your existing application. Knowing the typical and maximum loads on your system helps you understand when something is operating outside of its designed limits. Monitor traffic to understand application behavior and have that data handy so you can design realistic load testing scripts.
- Review the [Azure Load Testing region availability and load limits](https://azure.microsoft.com/en-us/services/load-testing/#faq).

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
