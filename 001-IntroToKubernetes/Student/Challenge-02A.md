# Challenge 02 - Path A: The Azure Container Registry

[< Previous Challenge](./Challenge-01A.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Now that we have our application packaged as container images, where do they go?

Azure Container Registry is a managed registry service based on the open-source Docker Registry 2.0. You can create and maintain Azure container registries to store and manage your container images and related artifacts.

You can use Azure container registries with your existing container development and deployment pipelines, or use Azure Container Registry Tasks to build container images in Azure. Build on demand, or fully automate builds with triggers such as source code commits and base image updates.

## Description

In this challenge we will be creating and setting up a new Azure Container Registry. As opposed to Docker Hub which is publicly accessible, this registry will only be available to your AKS cluster through a managed identity. This will be the new home of the containers we just created. We will see later on how Kubernetes will pull our images from this registry.

- Deploy an Azure Container Registry (ACR)
- Ensure your ACR has proper permissions and credentials set up
- Login to your ACR
- Push your Docker container images to the ACR
- List all images in your ACR

## Success Criteria

1. Verify that you have provisioned a new Azure Container Registry
1. Verify that you have deployed your container images to the registry.
1. Verify that you can log into the registry and see all images.