# Challenge 00 - Prerequisites - Ready, Set, GO! - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Ensure students have all prerequisites installed before proceeding:

- Verify students have Azure CLI, Terraform CLI, and Confluent CLI installed and authenticated
- Students should extract the Resources.zip file and navigate to the Terraform directory
- The Terraform modules require Azure subscription ID, principal IDs, and Confluent API keys to be set in the variables files
- Run `terraform init` followed by `terraform plan` and `terraform apply` to deploy all infrastructure
- Common issues:
  - Insufficient Azure permissions or quota limits for Azure OpenAI
  - Missing or incorrect Confluent Cloud API keys
  - Terraform state lock issues if multiple students share a subscription
- After deployment, verify all connectors are in a "Running" state in Confluent Cloud
- Confirm the MCP-powered AI agent responds when prompted with its name and can list the eight grocery store departments
