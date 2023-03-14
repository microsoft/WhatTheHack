# Challenge 03 - Automated Root Cause Analysis with Davis

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)



## Pre-requisites (Optional)
None


## Introduction

Often the monitoring tools organizations use simply don’t work in the complex ecosystem of microservices and for technologies like Kubernetes.

Finding the root cause of problems is harder than ever before and the effort required goes beyond what is humanly possible when the application spans to the cloud providers and data centers and the explosion of interconnected services. There are more possibilities for failures and more hiding spots for problems to sneak into the environment when software driving more than just the application.

In this lab, we will trigger a few problem and see how troubleshooting time is Significantly reduced by letting AI automatically detect problems and pinpoints the root cause, explaining business impact with no manual configurations.

## Description

### Objectives of this Challenge
🔷 Enable a problem pattern in the application and walk through what [Dynatrace Davis](https://www.dynatrace.com/platform/artificial-intelligence/) found

### Tasks
- Enable Backend Service Problem and Analyze the problem in Dynatrace

    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh backend 2
    ```
- Wait for ~5-10 minutes.  Then, Go to Dynatrace menu -> Problems and review the problem card generated
    -https://www.dynatrace.com/support/help/how-to-use-dynatrace/problem-detection-and-analysis/basic-concepts/problem-overview-page

- Disable the problem pattern on Backend Service
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh backend 1
    ```

- Enable the problem pattern on Order Service on AKS and analyze the problem in Dynatrace
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh k8-order 3
    ```
- Wait for ~5-10 minutes.  Then, Go to Dynatrace menu -> Problems and review the problem card generated
    -https://www.dynatrace.com/support/help/how-to-use-dynatrace/problem-detection-and-analysis/basic-concepts/problem-overview-page
- Disable the problem pattern on Order service on AKS
    ```bash
        cd ~/azure-modernization-dt-orders-setup/learner-scripts
        ./set-version.sh k8-order 1
    ```



## Success Criteria

- [x] Problem Card for Backend Service is generated
- [x] Problem card for Order Service is generated


## Learning Resources
- [Dynatrace Information Events](https://www.dynatrace.com/support/help/dynatrace-api/environment-api/events/post-event/)
- [Dynatrace how problems are detected & analyzed](https://www.dynatrace.com/support/help/how-to-use-dynatrace/problem-detection-and-analysis/basic-concepts/how-problems-are-detected-and-analyzed)


## Tips


## Advanced Challenges (Optional)

