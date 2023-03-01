# Challenge 04 - Create a deployment environment - Coach's guide

## Notes & guidance

- [create-azure-resources.yml](./create-azure-resources.yml) workflow file
- Workflows need to be created in **.github/workflows**
- Ensure all Actions secrets are created:
  - AZURE_CREDENTIALS
  - AZURE_SUBSCRIPTION
  - AZURE_RG
  - AZURE_PREFIX
- `workflow_dispatch` must be used for the trigger for the workflow to run manually
- The path to the config file 8s **${{ github.workspace }}/config/main.bicep**

[< Previous Solution](./solution03.md) - **[Home](./README.md)** - [Next Solution >](./solution05.md)