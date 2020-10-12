# What The Hack - Azure Arc enabled Kubernetes Hack

## Challenge 4 – Enable Monitoring and Alerting
[Back](challenge03.md) - [Home](../readme.md) - [Next](challenge05.md)

### Introduction

With both the clusters deployed and onboarded on to Azure, in this challenge we will take the next step by enabling monitoring on each of the clusters. This will allow us to centrally observe and manage these  clusters from within the Azure portal. 

 ![](../img/image6.png)

### Challenge

1. Enable monitoring on GKE Arc enabled cluster.
2. Enable monitoring on the locally deployed cluster.
3. Ensure Azure Log Analytics workspaces are deployed and the cluster specific metrics are being streamed into the workspaces to be visually graphed.
4. Verify **Node CPU utilization %** of each of the notes within the deployed clusters is within acceptable range (below 60% CPU utilization)
   * **Hint**: Look at the graph within Log Analytics.
5. Create an **Azure Alert** whenever a node within the cluster has its CPU utilization go higher than 60%.


### Success Criteria

This challenge will be complete when both the clusters are enabled for monitoring and verifing that each cluster is sending logs to Azure Log Analytics workspaces. Also ensure an alert is triggered whenever any node's CPU utilization goes higher than 60%.

[Back](challenge03.md) - [Home](../readme.md) - [Next](challenge05.md)
