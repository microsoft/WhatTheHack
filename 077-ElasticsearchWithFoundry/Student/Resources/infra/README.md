# Draft Azure provisioning

These assets are untested. They propose a minimal current-generation Microsoft Foundry account, project, one model deployment, and user role assignments. They do not provision Elastic, enable trial entitlements, create a classic hub, or deploy Azure AI Search.

**Attach existing:** set `AZURE_AI_PROJECT_ENDPOINT` and `AZURE_AI_MODEL_DEPLOYMENT_NAME` in `.env`; do not run `deploy.sh`. An administrator must grant the required agent, connection-management, model-inference, and evaluation permissions.

**Create new:** review `main.bicep` with your administrator, choose a supported region/model/version, and run the explicit provisioning cell in `00-Setup.ipynb`. The cell defaults to disabled. It invokes `bash infra/deploy.sh` using named environment inputs and requires a matching workshop confirmation.

The role GUID is deliberately an administrator input: resolve the actual **Foundry Project Manager** or another suitable least-privilege role in your tenant. Role display names have changed; do not guess a GUID from an unrelated Azure ML role. The template separately grants Cognitive Services OpenAI User on the account for model inference.

Creating the group/resources requires appropriate resource-management permissions. Creating role assignments additionally requires an authorized role such as Role Based Access Control Administrator at the relevant scope. Subscription Owner is not required merely to run an already-provisioned workshop.

The draft uses public endpoints for a synthetic-data lab. Private networking, enterprise policy, storage requirements for the selected evaluation path, regional quota, provider registration, and preview/experimental eligibility must be checked before delivery. If the evaluation path requires additional storage or connections, update the template after the pilot; do not claim those are already covered.

The script does not automatically retry deployment failures or change regions/models. Inspect failures instead of redeploying unrelated resources. It refuses an existing group without the matching workshop tag. Re-running with the same parameters is intended to update only that dedicated deployment.

Cleanup is deliberate and scoped: use the cleanup notebook to review the group, verify its tag, and delete it only if every resource is workshop-owned. Soft-deleted Cognitive Services accounts can retain names; purge only after checking the current service guidance and retention requirements.
