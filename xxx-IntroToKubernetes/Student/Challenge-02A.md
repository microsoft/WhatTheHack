# Challenge 02 - Path A: The Azure Container Registry

[< Previous Challenge](./Challenge-01A.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Now that we have our application packaged as container images, where do they go?

## Description

In this challenge we will be creating and setting up a new, private, Azure Container Registry. This will be the new home of the containers we just created. We will see later on how Kubernetes will pull our images from this registry.

- Deploy an Azure Container Registry (ACR)
- Ensure your ACR has proper permissions and credentials set up
- Login to your ACR
- Push your Docker container images to the ACR
- List all images in your ACR

## Success Criteria

1. Verify that you have provisioned a new Azure Container Registry
1. Verify that you have deployed your container images to the registry.
1. Verify that you can log into the registry and see all images.