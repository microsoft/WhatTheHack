# Challenge 02 - Path C: The Azure Container Registry

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

The first step in our journey will be to create a container registry and import our application images to it.

## Description

- Deploy an Azure Container Registry (ACR)
- Ensure your ACR has proper permissions and credentials configured
- Using the appropriate cli commands, import the following existing container images into your ACR from Docker Hub:
  - **API app:** whatthehackmsft/content-api
  - **Web app:** whatthehackmsft/content-web
- List all images in your ACR

## Success Criteria

1. Verify that you have provisioned a new Azure Container Registry
1. Verify that you have imported your container images to the registry.
1. Verify that you can log into the registry and see all images.