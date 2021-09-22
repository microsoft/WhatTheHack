# Challenge 11: Operations and Monitoring

[< Previous Challenge](./10-networking.md) - **[Home](../README.md)**

## Introduction

Running a cluster without knowing what is going on inside of it is a show-stopper for any serious production deployment. It is imperative that we are familiar with operationalizing our Kubernetes clusters and having a full view into day to day running and error state alerts.

## Description

In this challenge you will learn how to view application logs and trouble-shoot errors. View performance metrics and identity bottlenecks.

- Find the logs for your application’s containers, using:
	- `kubectl`
	- Using the Kubernetes Dashboard
	- Notice how you can check the logs of any of your pods individually.
- Start a bash shell into one of the containers running on a pod and check the list of running processes
- Find out if your pods had any errors.
	- Figure out how to get details on a running pod to see reasons for failures.
- Azure Monitor:
	- Enable "Azure Monitor for Containers" on the AKS cluster
	- Show a screenshot of CPU and memory utilization of all nodes
	- Show a screenshot displaying logs from the frontend and backend containers
- Kibana:
	- Install Fluentd and Kibana resources on the Kubernetes cluster to use an external ElasticSearch cluster
	- Create a Kibana dashboard that shows a summary of logs from the front-end app only
	- Create a Kibana dashboard that shows a summary of logs from the back-end app only
	- Create a Kibana dashboard that gives a count of all log events from the kubernetes cluster for the last 30 minutes only.

## Success Criteria

1. Show logs for the containers running in your cluster.
2. Log into a running container and issue bash commands.
3. Show Azure Monitor working.
4. Show Kibana dashboards working.

## Learning Resources
- Azure Monitoring for Containers:
    - <https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-overview>
- ELK stack:
    - <https://logz.io/learn/complete-guide-elk-stack>
	- <https://v1-19.docs.kubernetes.io/docs/tasks/debug-application-cluster/logging-elasticsearch-kibana/>
- Fluentd:
    - <https://docs.fluentd.org>