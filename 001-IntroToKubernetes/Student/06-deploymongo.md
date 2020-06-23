# Challenge 6: Deploy MongoDB to AKS

[< Previous Challenge](./05-scaling.md) - **[Home](../README.md)** - [Next Challenge >](./07-updaterollback.md)

## Introduction

We are going to need MongoDB for v2 of our application and we'll be running it in our Kubernetes cluster.

## Description

In this challenge we'll be installing MongoDB into our cluster.

- Deploy a MongoDB container in a pod for v2 of the FabMedical app
- **Hint:** Check out the Docker Hub container registry and see what you can find. 
- Confirm it is running with:
	- `kubectl exec -it <mongo pod name> -- mongo "--version"`

## Success Criteria

1. MongoDB is installed and run in our cluster
1. The `mongo --version` command can be run in a pod and shown to work.