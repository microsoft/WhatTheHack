# Challenge 04 - Enable Automated Load Testing (CI/CD)

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Pre-requisites

- You will need a GitHub account or Azure DevOps environment to create/run your workflows.

## Introduction

You can integrate Azure Load Testing in your CI/CD pipeline at meaningful points during the development lifecycle. For example, you could automatically run a load test at the end of each sprint or in a staging environment to validate a release candidate build. In the test configuration, you specify pass/fail rules to catch performance regressions early in the development cycle. For example, when the average response time exceeds a threshold, the test should fail. To get the maximum value from this approach, it is critical to integrate this in your CI/CD workflow as soon as possible.

You can trigger Azure Load Testing from Azure Pipelines or GitHub Actions workflows.

## Description

- Use Azure DevOps or GitHub to execute your load test with every commit or merged PR or with a manual trigger.
- Intentionally set the pass/fail rules in your test configuration to a value (i.e., response time) that would cause the test to fail during the workflow. 
- On load test failure, automatically create a work item or issue.

## Success Criteria

- Demonstrate that you can execute your load test on every commit or merged PR or with a manual trigger.
- Demonstrate that when the load test fails due to it not meeting the performance target, a work item or issue is created automatically.

## Learning Resources

- [Load Testing documentation](https://docs.microsoft.com/en-us/azure/load-testing/)


