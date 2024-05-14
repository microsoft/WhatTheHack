# Challenge 02 - Path A: The Azure Container Registry - Coach's Guide 

[< Previous Solution](./Solution-01A.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

This is **PATH A**. Use this path if your students want to understand what's involved in creating a Docker container, and understand basic docker commands.  In this path, your students will create a Dockerfile, build and test local containers, and then push these container images to Azure Container Registry.

*Note that for Azure Government deployments, the container registry url suffix is `*.azurecr.us.*`

- To create the registry from the CLI, use: 
    - `az acr create -n <name of registry> -g <resource group> --sku Standard`
- To login to the ACR, use: 
    - `az acr login --name <name of ACR>`
- To tag images, use: 
    - `docker tag <name of image> <name of ACR>/<namespace>/<name of image>`
    - For example: 
        - `docker tag content-web peteacr01.azurecr.io/wthaks/content-web`
        - `docker tag content-api peteacr01.azurecr.io/wthaks/content-api`
- To push the docker image, use: 
    - `docker push <name of ACR>/<namespace>/<name of image> `
    - For example: 
        - `docker push peteacr01.azurecr.io/wthaks/content-web `
        - `docker push peteacr01.azurecr.io/wthaks/content-api`
- To list images in the repository, use:
    - `az acr repository list --name <name of ACR>`

## Videos

### Challenge 2A Solution

[![Challenge 2A solution](../Images/WthVideoCover.jpg)](https://youtu.be/EuNLBxVZQ2g "Challenge 2A Solution")
