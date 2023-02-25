# Challenge 05 - Configure CD - Coach's guide

## Notes & guidance

- [deploy.yml](./deploy.yml) workflow file
- Workflows need to be created in **.github/workflows**
- Ensure all Actions secrets are created:
  - AZURE_CREDENTIALS
  - AZURE_SUBSCRIPTION
  - AZURE_RG
  - AZURE_PREFIX
  - AZURE_CONTAINER_REGISTRY
- Ensure the Azure Container Registry name is being read correctly in the workflow

[< Previous Solution](./solution03.md) - **[Home](./README.md)** - [Next Solution >](./solution05.md)