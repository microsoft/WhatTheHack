# Challenge 01 - Is your Application ready for the Super Bowl?

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites

Before creating your Azure Chaos Studio Experiment, ensure you have deployed and verified the pizzeria application is available. 

## Introduction

Welcome to Challenge 1.

In this challenge you will simulate failure in your compute tier. It is Super Bowl Sunday and you are the system owner of Contoso Pizza's pizza ordering
workload. This workload is hosted in Azure's Kubernetes Service (AKS). Super Bowl Sunday is Contoso Pizza's busiest day of the year. 
To make Super Bowl Sunday a success, your job is to plan for possible failures that could occur during the Superbowl event.  

If you are using your own AKS application, your application should be ready to handle its peak operating time --this is when Chaos strikes. 
 

## Description

Create failure at the AKS pod level in your preferred region e.g. EastUS

- Prepare environment for AKS failures 
- Load and scope the Chaos Experiment to the workload's web tier
- Observe the failure

During the experiment, were you able to order a pizza or perform your appplication's functionality? If not, what could you do to make your application resilient at the POD layer?  


## Success Criteria

- Verify Chaos Mesh is running on the Cluster
- Verify Pod Chaos restarted the application's AKS pod
- Observe any failure in the the application
- Was your application available? 
- If not how can you make it available during such an outtage? 

## Tips

These tips apply to the Pizza Application

verify the the "selector" in the experiment uses namespace of the application

Command to view the private and public IP of the pizza application 

```bash
kubectl get -n contosoappmysql svc

```

Command to view all names spaces running in the AKS cluster

```bash
kubectl get pods --all-namespaces

```


## Learning Resources  
- [Simulate AKS pod failure with Chaos Studio](https://docs.microsoft.com/en-us/azure/chaos-studio/chaos-studio-tutorial-aks-portal)
- [AKS cheat-sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)


