# Challenge 02 - Path C: The Azure Container Registry

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

The first step in our journey will be to create a container registry and import our application images to it.

Azure Container Registry is a managed registry service based on the open-source Docker Registry 2.0. You can create and maintain Azure container registries to store and manage your container images and related artifacts.

You can use Azure container registries with your existing container development and deployment pipelines, or use Azure Container Registry Tasks to build container images in Azure. Build on demand, or fully automate builds with triggers such as source code commits and base image updates.

## Description

- Deploy an Azure Container Registry (ACR)
- Ensure your ACR has proper permissions and credentials configured
- Using the appropriate cli commands, import the following existing container images into your ACR from Docker Hub:
  - **API app:** `whatthehackmsft/content-api`
  - **Web app:** `whatthehackmsft/content-web`
- List all images in your ACR

## Success Criteria

1. Verify that you have provisioned a new Azure Container Registry
1. Verify that you have imported your container images to the registry.
1. Verify that you can log into the registry and see all images.