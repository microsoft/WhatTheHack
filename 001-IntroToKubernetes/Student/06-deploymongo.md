# Challenge 6: Deploy MongoDB to AKS

[< Previous Challenge](./05-scaling.md) - **[Home](../README.md)** - [Next Challenge >](./07-updaterollback.md)

## Introduction

We are going to need MongoDB for v2 of our application and we'll be running it in our Kubernetes cluster.

## Description

In this challenge we'll be installing MongoDB into our cluster.

- Deploy a MongoDB container in a pod for v2 of the FabMedical app.  Use the official MongoDB container image from https://hub.docker.com/_/mongo
- MongoDB is a _database_, and thus rather than using a **Deployment**, it's best to use a **Stateful Set** object to deploy it to Kubernetes.
- Confirm it is running with:
	- `kubectl exec -it <mongo pod name> -- mongo "--version"`
- Hint:  Follow the pattern you used in Challenge 4 and create a stateful set and service YAML file for MongoDB.
- Hint: MongoDB runs on port 27017
## Success Criteria

1. MongoDB is installed and running in our cluster as a stateful set
1. The `mongo --version` command can be run in a pod and shown to work.


## Learning Resources
* [Stateful Sets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
* [Stateful Set Basics](https://kubernetes.io/docs/tutorials/stateful-application/basic-stateful-set/)
* [Deployments vs Stateful Sets](https://www.baeldung.com/ops/kubernetes-deployment-vs-statefulsets)