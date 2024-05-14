# Challenge 07 - Load Testing With Chaos Experiment (Resilience Testing)

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)**

## Introduction

We have gone over load testing for the majority of this hack.  While the information you gather from load testing can help determine how you scale your application.  The resiliency of an application isn’t solely decided by how quickly it can scale up or out - but also how it handles failures. This means planning for a failure of every application component: a single container, cluster, VM, database and region.  Testing while having certain components fail is called Resilience testing.  We will be going over that here.

## Description

- Use Azure Chaos Studio to design a Chaos experiment
- Run a load test (make sure you have a recent baseline first)
- During the load test, start the Chaos experiment and note the failures
- Prioritize the failure points and build an action plan to remediate

## Success Criteria

- Show the failure points that occurred during your resilience testing and your remediation plan

## Learning Resources

[What is Azure Chaos Studio](https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-overview)


## Advanced Challenges

- Add your Chaos Experiment to your CI/CD workflow and configure it to run during your load test.