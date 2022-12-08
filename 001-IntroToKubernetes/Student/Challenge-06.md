# Challenge 06 - Deploy MongoDB to AKS

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

We are going to need MongoDB for v2 of our application and we'll be running it in our Kubernetes cluster.

## Description

In this challenge we'll be installing MongoDB into our cluster.

- Deploy a MongoDB container in a pod for v2 of the FabMedical app.  Use the official MongoDB container image from https://hub.docker.com/_/mongo
- Confirm it is running with:
	- `kubectl exec -it <mongo pod name> -- mongosh "--version"`
- Hint:  Follow the pattern you used in Challenge 4 and create a deployment and service YAML file for MongoDB.
- Hint: MongoDB runs on port 27017

## Success Criteria

1. Verify MongoDB is installed and run in our cluster
1. Verify the `mongosh --version` command can be run in a pod and shown to work.
