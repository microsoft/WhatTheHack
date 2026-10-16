# Challenge 5: Coach's Guide - GitOps

[< Previous Challenge](./04-scaling.md) - **[Home](README.md)** - [Next Challenge>](./06-service-mesh.md)

Students complete either Flux or Argo CD. Use a student-owned Git repository containing a `demo` Namespace, a basic Deployment, and a Service. Any suitable application image is acceptable. Reuse app routing from [Challenge 2 - Helm](../Student/02-helm.md).

## Option 1 - Flux

Follow the [Azure-managed Flux v2 tutorial](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2?tabs=azure-cli) for prerequisites and authentication. Use the managed `microsoft.flux` extension, not upstream `flux bootstrap`.

Create one configuration and one kustomization pointing to the application's repository path. Example for PowerShell:

```powershell
$group = "<existing-resource-group>"
$cluster = "<existing-aks-cluster>"
$repoUrl = "https://github.com/<github-username>/<repository>"
az k8s-configuration flux create -g $group -c $cluster -t managedClusters -n cluster-config --namespace cluster-config --scope cluster -u $repoUrl --branch main --sync-interval 1m --kustomization name=apps path=./apps prune=true sync_interval=1m
```

- Replace `./apps` with the student's manifest directory. Include the `demo` Namespace in that directory; no separate infrastructure kustomization is needed.
- The command installs the extension if needed. Controllers run in `flux-system`; configuration objects run in `cluster-config`.
- Verify the configuration is **Compliant** and its Git source and kustomization are **Ready**:

```powershell
az k8s-configuration flux show -g $group -c $cluster -t managedClusters -n cluster-config
kubectl get gitrepositories,kustomizations -n cluster-config
```

Pruning removes managed resources when their manifests or configuration are deleted. Keep the configuration limited to lab resources.

## Option 2 - Argo CD

Follow the [Azure-managed Argo CD tutorial](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-argocd) to enable the extension and access its UI. Disable Redis HA for lab clusters with fewer than four nodes; keep administration access private.

Create an Application with these settings:

| Setting | Value |
| --- | --- |
| Repository / revision / path | Student's repository, branch, and manifest directory |
| Destination cluster | `https://kubernetes.default.svc` |
| Destination namespace | `demo` |
| Synchronization policy | Automatic |

Keep the Application definition in `argocd`, separate from the workload namespace. Verify the Application reports **Synced** and **Healthy**.

## Validate either option

- Confirm Git reconciliation creates the `demo` namespace, Deployment, and Service without manually applying the application manifests.
- Change the image or replica count in Git, commit, and push. Verify the cluster reflects the change.
- Confirm the application is accessible through app routing.
- For failures, check repository access, branch, path, manifest validity, and reconciliation events. Never commit credentials or let both tools manage the same resources.

## Optional challenge - Helm in Git

Store a Helm chart in the student's repository and deploy it instead of plain application manifests:

- **Flux:** Use a `HelmRelease` (`helm.toolkit.fluxcd.io/v2`) with `clusterconfig.azure.com/use-managed-source: "true"` in its annotations. Reference the chart's Git path; use `reconcileStrategy: Revision` or bump the chart version after template changes. See the [managed Helm guidance](https://learn.microsoft.com/en-us/azure/azure-arc/kubernetes/tutorial-use-gitops-flux2#manage-helm-chart-releases-by-using-the-flux-helm-controller).
- **Argo CD:** Point the Application's source path to the chart directory. No separate Helm operator is required.
- Avoid overlapping ownership with the plain-manifest deployment; use a separate release/namespace or plan a clean replacement.
- Change the chart or its values in Git and verify the resulting application update without manually running `helm upgrade`.