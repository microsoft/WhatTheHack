# Challenge 05 - Azure Pipelines: Build and Push Docker Image to Container Registry

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-06.md)

## Introduction

Now we need to extend our workflow with steps to build a Docker image and push it to Azure Container Registry (ACR). In the NEXT challenge, we will configure the Web App to pull the image from ACR.

Containers are a great way to package and deploy applications consistently across environments. If you are new to containers, there are 3 key steps to creating and publishing an image - outlined below. Because this is a What The Hack focused on DevOps and not containers, we strove to make this challenge as straightforward as possible.

- `docker login` - You need to login to the container registry that you will push your image to. As you can imagine, you don't want anyone to publish an image in your registry, so it is often setup as a private registry...requiring authentication to push and pull images.

- `docker build` - You need to call docker.exe (running locally on your machine or on your build server) to create the container image. A *critical* component of this is the `Dockerfile`, which gives instructions to docker.exe on how to build the image, the files to copy, ports to expose and startup commands.

- `docker push` - Once you have created your docker image, you need to store it in the container registry, which is our secured and centralized location to store docker images. Docker supports a push command that copies the Docker image to the registry in the proper repository. A repository is a logical way of grouping and versioning Docker images.

## Description

In this challenge, you will build and push a docker image to ACR:

- Create a new service connection to your container registry.  This will help bridge the connection from Azure DevOps to Azure Container Registry.  You should select the container registry created from the ARM template in the previous challenge.

- Return to your CI Build workflow and add a another **task** to your existing .NET Core workflow. We recommend finding and adding the "Docker" task via the assistant.  The Docker task will help with the login/build/push that we described earlier.

- Test the workflow by making a small change to the application code (i.e., add a comment). Commit, push, monitor the workflow and verify that a new container image is built, uniquely tagged and pushed to ACR after each successful workflow run.

## Success Criteria

- Show that a new container image is built, uniquely tagged and pushed to ACR after each successful workflow run.

## Learning Resources

- [Managing Service Connections](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml)
- [Building Docker Images](https://learn.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/building-net-docker-images?view=aspnetcore-7.0)
- [Azure Container Registry Operations](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-get-started-docker-cli?tabs=azure-cli)
- [Container Image Tags and Best Practices](https://learn.microsoft.com/en-us/azure/container-registry/container-registry-image-tag-version)

