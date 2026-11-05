# Challenge 03 - AKS Monitoring

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

This challenge covers cluster monitoring and application observability in AKS using Azure Monitor and Prometheus-compatible metrics.

## Description

- Collect and visualize cluster and container metrics. Consider Azure Monitor managed service for Prometheus and the built-in Azure Monitor dashboards rather than operating your own monitoring stack.
- Collect container logs with Azure Monitor Container Insights.
- Enable Application Insights for **both** the Node.js web app and the Python API. Investigate OpenTelemetry autoinstrumentation so you can collect application telemetry without changing application source code; check language-specific AKS feature availability before choosing a path.
- Increase the CPU utilization of the API container with the `pi` API endpoint, and see the corresponding metric increase in your monitoring views.
- Implement a mechanism so that Kubernetes increases the amount of API pods when CPU utilization goes high
- If you didn't do it already, configure a mechanism that scales the cluster automatically in and out depending on the required capacity

## Success Criteria

- You can display cluster metrics graphically
- You can show live container logs with Azure Container Insights
- You can show incoming requests for **both** the web app and API in Application Insights, and explain how an application request differs from a container metric or log. Show web-to-API dependency or end-to-end trace data if your instrumentation captures it.
- Verify that the cluster auto-scales when there are not enough CPU resources
- Participants can explain the autoscaling event using AKS metrics

## Learning Resources

These docs might help you achieving these objectives:

- [AKS Overview](https://docs.microsoft.com/azure/aks/)
- [Enable AKS monitoring](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-monitoring-enable)
- [Kubernetes dashboards in Azure Monitor](https://learn.microsoft.com/azure/azure-monitor/visualize/grafana-kubernetes)
- [Autoinstrument AKS applications with Application Insights](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-codeless) (check [Python limited-preview availability](https://learn.microsoft.com/azure/azure-monitor/containers/kubernetes-codeless-python-net))
- [Prometheus](https://prometheus.io/)
- [HPA](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)