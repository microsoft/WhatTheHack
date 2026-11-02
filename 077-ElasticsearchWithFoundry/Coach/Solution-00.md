# Challenge 00 - Ready, Set, Connect - Coach's Guide

**[Home](./README.md)** - [Next Solution >](./Solution-01.md)

## Notes & Guidance

This challenge prepares three independent environments: an Azure lab subscription, an Elastic Cloud Serverless project, and a GitHub Codespace. Success means that students can authenticate to the right environments and find the loaded sample data, not that they have already created a Foundry agent. Follow the current [student challenge](../Student/Challenge-00.md); older notebooks and draft resource descriptions are not the delivery path for challenges 00-03.

### Prepare before the event

- **Pilot both portals shortly before delivery.** Microsoft Foundry and Elastic Kibana are changing rapidly. Verify the current menu names, connection forms, screenshots, and feature availability. Keep notes on differences so coaches can help students navigate by purpose rather than by an exact button label.
- Coordinate with the lab proctor on the Azure launch procedure and Spektra credentials. The student guide still contains a launch-instructions placeholder; know what students will actually be given and how to recover an expired or inaccessible lab.
  - Use separate browser profiles or private windows for lab identities. A student may be signed into Azure with a personal or corporate account while the terminal uses the lab account.
  - Test device-code sign-in from the actual Codespace with a lab identity. Conditional Access policy can block it. The documented desktop alternative, `CODESPACES=false az login`, still requires an approved sign-in path; it does not bypass policy.
- Test the published Codespace link with a personal GitHub account, not just an organizer account. Verify that the hack's dev container is selected and that the resource files are where the student commands expect them.
  - The [dev container configuration](../Student/Resources/.devcontainer/devcontainer.json) is nested in the content repository. Opening a generic Codespace at the full repository root does not automatically select it.
  - Identify the student resource root: the directory containing [`.env.sample`](../Student/Resources/.env.sample), [`data/`](../Student/Resources/data/), and [`workflows/`](../Student/Resources/workflows/). Help students find it rather than assuming a particular terminal starting directory.
  - The current container configuration does not automatically install the loader's Python packages. Keep the student's `python3 -m pip install elasticsearch python-dotenv` step until the distributed environment has been verified to include them.
- Confirm trial signup, project provisioning, and native Context Engine/workflow access in the intended Elastic environment. An Elasticsearch project is required; an Observability or Security project is not the instructed choice.
  - Context Engine is experimental in the documentation reviewed for this guide. Trial access to Elasticsearch alone is not proof that the later challenges will work.
  - Preflight the LLM connector and external MCP tools needed in challenges 02 and 03. Resolve missing features with the organizer before delivery; do not discover eligibility problems halfway through the event.
- Confirm Azure resource-creation permissions, Foundry project access, model availability, and quota for Challenge 01. Recommend `gpt-5-mini`, but pilot its deployment in the actual lab subscription and region. Prepare an available alternative and use the same deployment for both agents.
- Allow time for account verification, Codespace startup, and provisioning. Check GitHub usage limits and Azure/Elastic trial expiry. Free trials and credits do not guarantee every operation is free.

### When students share an Azure subscription

Some labs require two students to share one Azure subscription and its lab identity. Confirm this arrangement with the proctor before setup.

- Advise the pair to share the **event-provided Azure lab credentials** privately with each other. Both students use those same credentials for Azure CLI sign-in and the Microsoft Foundry portal. This is a lab-specific arrangement, not a recommendation to share personal or corporate passwords.
- Each student must create their **own Foundry project**, using their name or initials to differentiate it, for example `precision-support-alex` and `precision-support-jb`.
  - Both students will see each other's projects because they use the same identity. Check the selected project before creating agents, connections, or deployments. Separate projects organize the work; they do not isolate permissions for a shared identity.
  - Each student keeps Mole and Optimus in their own project throughout the hack. Subscription-level model quota and costs are still shared, so coordinate deployment capacity with the proctor.
- An Elastic Marketplace trial is limited to **one per Azure subscription**. Do not have both students attempt to provision a Marketplace trial against the shared subscription.
  - The first student provisions Elasticsearch through Microsoft Marketplace.
  - The second student signs up for a separate trial directly at [Elastic.co](https://cloud.elastic.co/registration), using their own Elastic account.
  - Confirm that each provisioning route provides an **Elasticsearch Serverless project** with the Context Engine features needed for this hack; a hosted deployment is not automatically equivalent.
- Each student must have their **own Elastic Serverless environment**, endpoints, and API keys. Each loads the sample data into their own environment and connects only that environment to their own Foundry project. Do not copy one student's Elastic `.env` file or reuse their MCP connection for the other student.
- During cleanup, remove only the student's own resources. Do not delete a shared subscription's resource group or other resources that the partner still needs.

### Keep endpoints and credentials straight

Students often have the right information in the wrong field. Have them identify what each value is for without displaying the secret itself.

| Value | Used for | Common mistake |
| --- | --- | --- |
| Azure lab identity | Azure CLI and Foundry portal sign-in | Using the personal Azure identity instead |
| Elasticsearch endpoint | Loading data and Elasticsearch APIs | Supplying the Kibana browser URL |
| Kibana URL | Browsing data, Context Engine, and the MCP endpoint | Supplying the Elasticsearch endpoint |
| Encoded Elastic setup API key | Creating and populating workshop indices | Copying only the key ID, a masked value, or the wrong key type |

- Copy the encoded key when it is created; it is shown only once. If lost, create a replacement and revoke the unused key. Do not ask students to paste credentials into chat, projected terminals, or screenshots.
- Keep the `.env` file local and private. Save it before running the loader, skip the copy command if it already exists, and never commit it. The sample's other settings can remain unchanged for the default Kibana space.
- Use a dedicated workshop project. The setup key has write privileges; it is not an appropriate general-purpose agent credential. Before Challenge 01, prepare a scoped, read-only runtime key with the necessary Kibana Agent Builder access as well as source-index access.
  - Context Engine retrieval later also needs its feature privilege and access to the AI Index's backing data. Elasticsearch index permissions alone do not grant all Kibana capabilities.
  - Shared Foundry project connections contain shared credentials. Restrict who can access the project and revoke event keys afterward.

### Data loading and recovery

The current [loader](../Student/Resources/data/load_data.sh) runs three seeded generators and then checks counts. The expected result is:

| Index | Documents |
| --- | --- |
| `precision-crm-accounts` | 500 |
| `precision-support-tickets` | 3,000 |
| `precision-kb-articles` | 150 |

- **Every run deletes and recreates these three exact indices.** This is not an upsert-only operation and has no workshop-ownership safeguard. Confirm the endpoint belongs to the student's disposable workshop project before rerunning. Reloading also removes any manual changes students made to source records.
- The default data is deterministic, using seed 42. It is not the old tiny fixture containing a few accounts and tickets. Do not use older expected-answer files as the answer key for this dataset.
- Exported environment variables override `.env`, and legacy `ES_URL` / `ES_API_KEY` exports take precedence over `ELASTICSEARCH_URL` / `ELASTIC_API_KEY`. If editing `.env` appears to have no effect, inspect which variable names are set without printing key values.
- If a run fails, read the first failing operation. Resolve missing packages, a wrong URL, an expired key, or insufficient privileges before retrying. A partial run can leave only some of the indices populated.
- **Do not accept the final banner or exit status alone as success.** The count loop can print `ERR` and continue. Require all three numeric counts and confirm the documents in Kibana.
- Useful recovery checks:
  - `az account show`: verify the subscription is the lab subscription. If needed, use `az account set --subscription <lab-subscription-id>`, then verify again.
  - `401`: inspect the key value/type and expiration; `403`: inspect permissions on the operation that failed.
  - HTML instead of an Elasticsearch response: check for a Kibana URL or a proxy/login page.
  - Missing records in Discover: check the selected index/data view and time range before reloading. The tickets and articles contain historical dates, so a default "last 15 minutes" view can hide valid data.

### Dataset concepts to introduce

- CRM has one record per account; tickets link to it through **CRM `customer_id` = ticket `account_id`**. Company names can repeat and are not reliable join keys.
- `arr` means **annual recurring revenue in USD**, not an array. The source mapping already contains that definition; a baseline agent that reads metadata well may understand it without KIs.
- Dates are synthetic and fixed: account renewals are in 2026, ticket creation dates span January 2025 through August 2026, and article updates are historical. Use the actual event date for relative-date questions and accept a verified empty result. Do not secretly shift the scenario clock or alter the dataset to force a result.
- Only the supplied fictional data belongs in this lab. Later MCP calls send retrieved source content to Foundry; connecting a real customer datastore would introduce a different data-handling decision.

### What to ask students to demonstrate

- The terminal is authenticated to the lab subscription, and both browser portals are accessible with the intended identities.
- The resource workspace and private configuration are ready, without exposing the key.
- The loader produced all three expected counts, and Kibana shows actual records.
- Students can distinguish Elasticsearch, Kibana, and Azure endpoints and explain why rerunning the loader requires care.

### Product references for coaches

- [Sign in with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)
- [GitHub Codespaces overview](https://docs.github.com/en/codespaces/overview)
- [Elastic Cloud Serverless](https://www.elastic.co/docs/deploy-manage/deploy/elastic-cloud/serverless)
- [Authenticate Elastic MCP clients with API keys](https://www.elastic.co/docs/explore-analyze/ai-features/agent-builder/mcp-server-api-keys)
- [Context Engine quickstart and prerequisites](https://www.elastic.co/docs/explore-analyze/ai-features/context-engine/quickstart)
