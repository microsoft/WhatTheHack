# What The Hack - AKS Integration with Azure Services

## Introduction

The main goal of this What The Hack is for participants who are already familiar with Kubernetes how to interact with the rest of the Azure platform.

## Notes

* Let participants find their own solutions, even if they are wrong. Let them hit walls and learn from their mistakes, unless you see them investing too much time and effort. Give them hints that put them on the right track, but not solutions
* Most challenges can be solved in multiple ways, all of them correct solutions
* If there is any concept not clear for everybody, try to make participants explain to each other. Intervene only when no participant has the knowledge
* **Make sure no one is left behind**
* Make sure participants have a way to share code, ideally git-based
* Most challenges involve some level of subscription ownership to create identities or service principals, or for the AAD integration challenge.
* Leave participants try options even if you know it is not going to work, let them explore on themselves. Stop them only if they consume too much time
* For each challenge, you can ask the least participative members to describe what has been done and why

**NOTE**: The code snippets provided here are just an orientation for you as a coach, and might not work 100% in your particular environment. They have been tested, but the rapid nature of Azure CLI versions, Kubernetes, AKS, helm, etc makes it very difficult constantly reviewing them on a regular basis. If you find errors in the code, please send a PR to this repo with the correction.

## Challenges

- Challenge 1: **[Containers](./01-containers.md)**
   - Get familiar with the application for this hack, and roll it out locally or with Azure Container Instances
- Challenge 2: **[AKS Network Integration and Private Clusters](./02-aks_private.md)**
   - Deploy the application in an AKS cluster with strict network requirements
- Challenge 3: **[AKS Monitoring](./03-aks_monitoring.md)**
   - Monitor the application, either using Prometheus or Azure Monitor
- Challenge 4: **[Secrets and Configuration Management](./04-aks_secrets.md)**
   - Harden secret management with the help of Azure Key Vault
- Challenge 5: **[AKS Security](./05-aks_security.md)**
   - Explore AKS security concepts such as Azure Policy for Kubernetes
- Challenge 6: **[Persistent Storage in AKS](./06-aks_storage.md)**
   - Evaluate different storage classes by deploying the database in AKS
- Challenge 7: **[Service Mesh](./07-aks_mesh.md)**
   - Explore the usage of a Service Mesh to further protect the application
- Challenge 8: **[Arc-Enabled Kubernetes and Arc-Enabled Data Services](./08-arc.md)**
   - Leverage Arc for Kubernetes to manage a non-AKS cluster, and Arc for data to deploy a managed database there
