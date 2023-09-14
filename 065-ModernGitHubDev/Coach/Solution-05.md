# Challenge 05 - Deploying The Project - Coach's Guide 

[< Previous Solution](./Solution-04.md) - **[Home](./README.md)**

## Notes & Guidance

- [deploy.yml](./Solutions/deploy.yml) workflow file
- Workflows need to be created in **.github/workflows**
- Ensure all Actions secrets are created:
  - **AZURE_CREDENTIALS**
  - **AZURE_CONTAINER_REGISTRY**
  - **AZURE_RG**
  - **AZURE_CONTAINER_APP**
  - **AZURE_CONTAINER_APP_ENVIRONMENT**
- Ensure the path to the source is correct as **${{ github.workspace }}/src**
