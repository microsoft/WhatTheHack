# Challenge 01 - AzureLoadTesting

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction (Optional)

Before we jump into load testing, it’s critical to take a step back and develop a load testing strategy that is tailored to the application. This means breaking down the architecture, internal/external dependencies, high availability design, scaling and the data tier.

*Provide an overview of the technologies or tasks that will be needed to complete the next challenge.  This includes the technical context for the challenge, as well as any new "lessons" the attendees should learn before completing the challenge.*

*Optionally, the coach or event host may present a mini-lesson (with a PPT or video) to set up the context & introduction to the next topic.*

**Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce commodo nulla elit, vitae scelerisque lorem maximus eu. Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo. Vivamus venenatis accumsan neque non lacinia.**

## Description

- Define what services you are load testing (APIs, functions, webhooks, etc)
- Are you creating JMeter scripts or reusing existing ones? Either way, store them in a centralized repo.
    - Identify any data and/or configuration files needed
    - Identify any environment variables and/or secrets needed
- Identify the load characteristics: # of threads (max of 250 per engine instance)
- Identify the test failure criteria (response time and/or error rates)
- Identify if you will use client-side Monitoring (App Insights) and/or server-side monitoring (monitoring the Azure resources themselves)
- Identify any other app components that need to be load tested and/or monitored
- Identify potential bottlenecks in advance; for example, is your application CPU or memory bound or database bound?
- TODO: auto-scaling enabled? i.e., app service plan, VMSS
- Identify how the following will impact your load testing strategy:
    - [Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)
    - **Measure typical loads:** Knowing the typical and maximum loads on your system helps you understand when something is operating outside of its designed limits. Monitor traffic to understand application behavior.

## Success Criteria

- Present your comprehensive load testing plan - paying special attention to how the load test will ‘touch’ the various application tiers (front-end, APIs, database) and components (microservices, backend workers/jobs, serverless).
- Explain what potential bottlenecks you might encounter during the test. For each bottleneck, how will you tweak or mitigate the bottleneck?
- Explain how a service failure or degradation might impact the performance of the application and/or load test

## Learning Resources

[Azure subscription and service limits, quotas, and constraints](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits)