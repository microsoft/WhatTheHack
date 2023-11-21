# Challenge 07 - Scaling

[< Previous Challenge](./Challenge-06.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-08.md)

## Introduction
OpenShift allows users to scale the number of pods for each part of an application as needed. Looking at the deployment definition we have, we stated that we only want one pod to start with. Let's try and change that! 

## Description
In this challenge, we will be scaling up the number of pods that we have running in our applications. You will need to:
- Scale the `rating-api` backend application to 4 pods
- Scale the `rating-web` frontend application to 2 pods

## Success Criteria
To complete this challenge successfully, you should be able to:
- Demonstrate that more than one pod is up and running by either using the following command `oc get pods` or looking in the ARO Web Console

## Learning Resources
- [Developer CLI Options](https://docs.openshift.com/container-platform/3.11/cli_reference/basic_cli_operations.html)
- [oc-scale Man Page](https://www.mankier.com/1/oc-scale)

## Pod Autoscaling (Optional):
This optional section should be done in the ARO Web Console. 
- **NOTE:** Before you continue, please read the note at the bottom of this section. 

In this part of the challenge you will need to:
- Add resource limits to the `rating-web` frontend deployment
  - Set CPU Request: 500m
  - Set CPU Limit: 1 core
- Add a HorizontalPodAutoscaler to the `rating-web` frontend deployment 
  - Set Minimum Pods: 1
  - Set Maximum Pods: 3
  - Set CPU Utilization: 20%

When the resource limits are set and the HPA is added, let's see autoscaling in action! To do that:
- Copy your frontend application URL to the clipboard
- Deploy the following application and replace  `<rating-web-url>` with your frontend application route using the command below:
  - **NOTE**: This will increase the traffic to the frontend application. After a few minutes we should see the `rating-web` deployment have more than 1 pod deployed
```
kubectl create deployment busybox --image=busybox --replicas=10 -- /bin/sh -c "while true; do wget -q -O- <rating-web-url>; done"
```
- When we see the autoscaler in action, we are done with the challenge. Delete the `busybox` deployment using the command: `kubectl delete deployment busybox`

**NOTE:** To autoscale future applications in the CLI and in your production environments make sure to include resource limits in your deployments. That way you won't need to use the Web Console later on to autoscale or have to redeploy resources! Here are some learning resources to bookmark:
- [Understanding Deployment and DeploymentConfig objects](https://docs.openshift.com/container-platform/4.6/applications/deployments/what-deployments-are.html#what-deployments-are-build-blocks)
- [Configuring Requests and Limits in Kubernetes Deployments](https://devtron.ai/blog/configuring-requests-and-limits-in-kubernetes-deployments/)
- [Automatically scaling pods with the horizontal pod autoscaler](https://docs.openshift.com/container-platform/4.8/nodes/pods/nodes-pods-autoscaling.html)