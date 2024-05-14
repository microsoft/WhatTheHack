# Challenge 03 - Create Azure Load Testing Service and Establish Baselines

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Pre-requisites

- Before creating your Azure Load Test service, ensure you have created your load testing script(s) in the previous challenge.
## Introduction

In this challenge you will create the Load Testing service in Azure and use the load testing scripts you created in our last challenge to run baseline tests.

Baselines help to determine the current efficiency state of your application and its supporting infrastructure. They can provide good insights for improvements and determine if the application is meeting business goals. Lastly, they can be created for any application regardless of its maturity. No matter when you establish the baseline, measure performance against that baseline during continued development. When code and/or infrastructure changes, the effect on performance can be actively measured.

## Description

- Create a Load Testing service in Azure.
- Create a load test in the Load Testing service that accepts the website URL as an environment variable and passes that value to your load testing script.
- Run your load test multiple times using a typical user load and establish a performance baseline.
- Review the test results, identify the bottlenecks (CPU, memory, resource limits) and compile a list of insights.
- Discuss where you may be able to leverage this baseline data you have gathered.

## Success Criteria

- Show your load tests run in Azure Load Testing service and what your performance baseline is.
- Verify you can run the same load test and change parameters to hit different environments.

## Learning Resources

- [Establish Baselines](https://docs.microsoft.com/en-us/azure/architecture/framework/scalability/performance-test#establish-baselines)
- [Create configurable load tests with secrets and environment variables](https://docs.microsoft.com/en-us/azure/load-testing/how-to-parameterize-load-tests)
- [Load Testing documentation](https://docs.microsoft.com/en-us/azure/load-testing/)

