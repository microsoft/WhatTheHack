# Challenge 02 - Path B: Dockerfiles & Azure Container Registry

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

The first step in our journey will be to take our application and package it as a container image, which will be stored in a container registry.

Azure Container Registry is a managed registry service based on the open-source Docker Registry 2.0. You can create and maintain Azure container registries to store and manage your container images and related artifacts.

You can use Azure container registries with your existing container development and deployment pipelines, or use Azure Container Registry Tasks to build container images in Azure. Build on demand, or fully automate builds with triggers such as source code commits and base image updates.

## Description

- You will find two sample Dockerfiles which will be used to build the container images for your application in the `/Challenge-02` folder of the `Resources.zip` files provided by your coach.
- You will find the source code for `content-web` and `content-api` in the `/Challenge-01/` folder of the `Resources.zip` file provided by your coach. Review how the provided Dockerfiles correspond to each of these applications.
- Deploy an Azure Container Registry (ACR)
- Ensure your ACR has proper permissions and credentials configured
- Use the cloud-based container image building feature of ACR Tasks to build and store images for `content-web` and `content-api`
- List all images in your ACR

## Success Criteria

1. Verify that you have provisioned a new Azure Container Registry
1. Verify that you have built and deployed your container images to the registry.
1. Verify that you can log into the registry and see all images.