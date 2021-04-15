# Challenge 2: Coach's Guide

[< Previous Challenge](./01-containers.md) - **[Home](README.md)** - [Next Challenge >](./03-k8sintro.md)

## Notes & Guidance

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


