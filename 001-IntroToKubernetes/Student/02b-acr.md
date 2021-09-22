# Challenge 2: Dockerfiles & Azure Container Registry

[< Previous Challenge](./01-containers.md) - **[Home](../README.md)** - [Next Challenge >](./03-k8sintro.md)


## Introduction

The first step in our journey will be to take our application and package it as a container image, which will be stored in a container registry.

## Description

Your coach will provide you two sample Dockerfiles, which will be used to build the container images for your application.

- Download the source code for `content-web` and `content-api` into your local folder.  Review how the provided Dockerfiles correspond to each of these applications.
- Deploy an Azure Container Registry (ACR)
- Ensure your ACR has proper permissions and credentials configured
- Use the cloud-based container image building feature of ACR Tasks to build and store images for `content-web` and `content-api`
- List all images in your ACR


## Success Criteria

1. You have provisioned a new Azure Container Registry
1. You have built and deployed your container images to the registry.
2. You can log into the registry and see all images.


