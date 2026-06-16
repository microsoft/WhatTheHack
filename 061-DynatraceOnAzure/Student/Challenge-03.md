# Challenge 03 - Automated Root Cause Analysis with Davis

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)


## Introduction

Organizations often face challenges with their monitoring tools when working with complex ecosystems of microservices and technologies like Kubernetes.

Identifying the root cause of problems has become more difficult. The task now requires more effort than ever before due to applications spanning across cloud providers, data centers, and an increasing number of interconnected services. With software driving more than just the application, there are now more opportunities for failures and more places for problems to emerge in the environment.

In this lab, we will simulate several problem scenarios and demonstrate how AI can significantly reduce troubleshooting time by automatically detecting issues and identifying the root cause, while explaining the business impact without the need for manual configurations.

## Description

### Objectives of this Challenge
-  Enable a problem pattern in the application and walk through what [Dynatrace Davis](https://www.dynatrace.com/platform/artificial-intelligence/) found as a root cause.

### Tasks
* Enable Backend Service Problem
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh backend 2
    ```
* Wait for ~5-10 minutes.  Then, Go to Dynatrace menu -> Problems and check if a problem card is generated for response time degradation
    - How many observed users by this problem?
    - What was identified as the root cause of this problem?

* Disable the problem pattern on Backend Service
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh backend 1
    ```

* Enable the problem pattern on Order Service on AKS and analyze the problem in Dynatrace
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh k8-order 3
    ```
* Wait for ~5-10 minutes.  Then, Go to Dynatrace menu -> Problems and check if a problem card is generated for failure rate increase
    - How many affected service calls were impacted by this problem?
    - What were identified as the root cause of this problem?
        - Was it related to deployment?
* Disable the problem pattern on Order service 
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh k8-order 1
    ```



## Success Criteria

- [x] Problem Card for Backend Service is generated
- [x] Problem card for Order Service is generated


## Learning Resources
- [Dynatrace Information Events](https://www.dynatrace.com/support/help/dynatrace-api/environment-api/events-v2)
- [Dynatrace how problems are detected & analyzed](https://www.dynatrace.com/support/help/how-to-use-dynatrace/problem-detection-and-analysis/basic-concepts/how-problems-are-detected-and-analyzed)
- [Problem Card Overview](https://www.dynatrace.com/support/help/how-to-use-dynatrace/problem-detection-and-analysis/basic-concepts/problem-overview-page)


## Advanced Challenges 
- Analyze the failure rate degradation in the order service problem card to identify the exception details in the code stack trace 

