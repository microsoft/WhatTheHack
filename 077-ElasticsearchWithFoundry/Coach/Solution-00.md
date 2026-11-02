# Challenge 00 - Ready, Set, Connect - Coach's Guide

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

Setup should remove toil, not become the central lesson. Account/signup and native feature eligibility are pre-event work. This draft has not been tested; resolve the release gates in the coach guide before students arrive.

### One solution path

- Publish the allowlisted student package with its contents at the Codespaces repository root.
- Have students create a unique `.env`, sign in using Azure CLI, and choose attach-existing or explicitly run the provided Bicep deployment.
- Supply an administrator-approved project role GUID, region, model version, and quota configuration. Do not assume a subscription-level Contributor role grants all data-plane permissions.
- Load the three bundled sources: expected counts are 3 accounts, 4 tickets, and 7 KB articles. Reruns upsert stable IDs and refuse unowned indices.
- Enable native Context Engine in the intended Kibana space. Verify workflow and inference access, not merely whether the landing page loads.
- Configure two remote MCP project connections targeting Elastic's hosted endpoint. Header `Authorization` must contain the `ApiKey` scheme and the encoded runtime key.
- Discover actual tool wire names using each runtime key. Save names in `.env`; select only discovery and read-only source tools for the baseline.

### Permission boundaries

Setup needs workshop source creation/write access plus native Context Engine/workflow management. Baseline runtime access must exclude AI Index backing data. Optimus adds Context Engine read and backing-index read/metadata access. Both runtime keys may read the exact safety index after activation, but neither may write.

Use the service's supported Serverless role/key configuration. An AI Index description is not access control, and a Foundry tool allowlist does not prevent a general query tool from reading data authorized by its key.

### Progressive hints

- Authentication failures: check which endpoint is being called and whether the key has Kibana/space privileges, not only Elasticsearch index privileges.
- Context API 404: check the setting in the exact space and feature eligibility; do not assume the resource is missing.
- Foundry connection failures: local MCP discovery is not evidence of service-to-service reachability. Inspect the project connection and network path.
- Deployment failures: inspect the model/version/SKU availability, quota, role-assignment permission, and active subscription. Do not repeatedly change regions without checking evaluation support.

### Evidence and recovery

Ask students to identify the model request, local seed operation, and eventual Foundry MCP call as three different paths. An empty native AI Index list is possible before Challenge 02 and does not verify KI generation.

If a student lacks Context Engine access, record the native objective as blocked. They can still explore baseline agents and safety; do not fabricate completion or give them an unlabeled simulation.

See the [native quickstart](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/quickstart) and [Foundry MCP authentication guidance](https://learn.microsoft.com/en-us/azure/foundry/agents/how-to/mcp-authentication).
