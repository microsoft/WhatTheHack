# Challenge 03 - Automated Root Cause Analysis with Davis

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)


## Introduction

Often the monitoring tools organizations use simply don’t work in the complex ecosystem of microservices and for technologies like Kubernetes.

Finding the root cause of problems is harder than ever before and the effort required goes beyond what is humanly possible when the application spans to the cloud providers and data centers and the explosion of interconnected services. There are more possibilities for failures and more hiding spots for problems to sneak into the environment when software driving more than just the application.

In this lab, we will trigger a few problem patterns and see how troubleshooting time is significantly reduced by letting AI automatically detect problems and pinpoints the root cause, explaining business impact with no manual configurations.

## Description

### Objectives of this Challenge
-  Enable a problem pattern in the application and walk through what [Dynatrace Davis](https://www.dynatrace.com/platform/artificial-intelligence/) found as a root cause.

### Tasks
1. Enable Backend Service Problem
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh backend 2
    ```
1. Wait for ~5-10 minutes.  Then, Go to Dynatrace menu -> Problems and check if a problem card is generated for response time degradation
    - How many observed users by this problem?
    - What was identified as the root cause of this problem?

1. Disable the problem pattern on Backend Service
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh backend 1
    ```

1. Enable the problem pattern on Order Service on AKS and analyze the problem in Dynatrace
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh k8-order 3
    ```
1. Wait for ~5-10 minutes.  Then, Go to Dynatrace menu -> Problems and check if a problem card is generated for failure rate increase
    - How many affected service calls were impacted by this problem?
    - What were identified as the root cause of this problem?
        - Was it related to deployment?
1. Disable the problem pattern on Order service 
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

## Tips
- In this challenge we leveraged Dynatrace events API to add additional context for Davis AI engine to correlate a deployment event with the problem.
- You can feed in information events to Dynatrace via CI/CD tools such as Azure Devops to provide additional context.  Below is an example of deployment and performance testing event sent to Dynatrace.

    ![](images/cicd.png)

    >👍 How this helps    
    > Having information events speeds up triage by adding context to what's happening with the application. Just imagine getting alerted about an issue and immediately seeing a load test or deployment took place, and in one click of the event, review the system, job, and team responsible!

## Advanced Challenges 
- Analyze the failure rate degradation in the order service problem card to identify the exception details in the code stack trace 

