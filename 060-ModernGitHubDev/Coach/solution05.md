# Challenge 05 - Configure CD - Coach's guide

## Notes & guidance

- [deploy.yml](./deploy.yml) workflow file
- Workflows need to be created in **.github/workflows**
- Ensure all Actions secrets are created:
  - **AZURE_CREDENTIALS**
  - **AZURE_CONTAINER_REGISTRY**
  - **AZURE_RG**
  - **AZURE_CONTAINER_APP**
  - **AZURE_CONTAINER_APP_ENVIRONMENT**
- Ensure the path to the source is correct as **${{ github.workspace }}/src**

[< Previous Solution](./solution03.md) - **[Home](./README.md)** - [Next Solution >](./solution05.md)
