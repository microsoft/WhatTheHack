# Challenge 03 - Logging and Metrics

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction
In the last challenge, we deployed our application, but if we press the buttons, nothing seems to be working! In this challenge, we will be exploring tools ARO offers to uncover what about our application is broken.

## Description
In this challenge we will use two different strategies to view the logs and metrics of our application, in order to uncover why it does not work. This challenge gives us the opportunity to debug our application in two different ways, and get more comfortable with the CLI as well as the ARO console & Azure Monitor.

This challenge has no concrete steps because we want you to explore! Poke around the ARO console and try out different CLI commands. 
  - **NOTE:** You **WILL NOT** be fixing the application in this challenge, the goal is to find out why our application is broken!

### *Some hints if you get stuck:*
- Understand what pods are running on your cluster 
- Think about what the buttons on your application should show
- Think about what your application is missing

## Success Criteria
To complete this challenge successfully, you should be able to:
- Explain why the application is broken 
- Demonstrate the ability to view logs using the CLI
- Demonstrate the ability to view logs on the ARO console
- **Optional:** Demonstrate the ability to integrate ARO with Azure Monitor to see logs on Container Insights

## Learning Resources
- [Using the OpenShift CLI](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html#cli-using-cli_cli-developer-commands)
- [Logging on ARO](https://docs.openshift.com/container-platform/4.11/logging/cluster-logging.html)
- [Connect an existing cluster to Azure Arc](https://docs.microsoft.com/en-us/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli)
- [Azure Monitor Container Insights for Azure Arc-enabled Kubernetes clusters](https://docs.microsoft.com/en-us/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters?toc=%2Fazure%2Fazure-arc%2Fkubernetes%2Ftoc.json&bc=%2Fazure%2Fazure-arc%2Fkubernetes%2Fbreadcrumb%2Ftoc.json)