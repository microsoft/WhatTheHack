# Challenge 4: Secrets and Configuration Management

[< Previous Challenge](./03-aks_monitoring.md) - **[Home](../README.md)** - [Next Challenge >](./05-aks_security.md)

## Introduction

This challenge will cover the management of app configuration, and secret injection in AKS from Azure Key Vault

## Description

You need to fulfill these requirements to complete this challenge:

- Supply environment variables to the Web and API containers over Kubernetes config maps or secrets
- For sensitive parameters (like the database user password) make sure that they are not stored anywhere in the Kubernetes cluster, but in a purpose-built secret store such as Azure Key Vault
- Non-sensitive configuration for the containers should be supplied from a configuration map, not hard coded in the manifests
- Make sure that no static password is stored in the AKS cluster that allows access to the Azure Key Vault

## Success Criteria

- Environment variables in the deployment manifests are not hard coded, but imported from Kubernetes configuration maps
- The SQL password is not stored as a Kubernetes secret or Kubernetes config map
- No Service Principal secret is stored in Kubernetes

## Advanced Challenges (Optional)

- Enable SSL in the ingress controller, and have its SSL certificate supplied from a purpose-built store such as Azure Key Vault

## Learning Resources

These docs might help you achieving these objectives:

- [Azure Key Vault](https://docs.microsoft.com/azure/key-vault/general/basic-concepts)
- [AKV provider for secrets store CSI driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure)
- [AKS Overview](https://docs.microsoft.com/azure/aks/)
- [Pod Identity - github.io docs](https://azure.github.io/aad-pod-identity/docs/getting-started/)
- [Pod Identity - Microsoft docs](https://docs.microsoft.com/azure/aks/use-azure-ad-pod-identity)
- [AAD Workload Identity for Kubernetes announcement](https://cloudblogs.microsoft.com/opensource/2022/01/18/announcing-azure-active-directory-azure-ad-workload-identity-for-kubernetes/)
- [AKV Secret Provider - Microsoft docs](https://docs.microsoft.com/azure/aks/csi-secrets-store-driver)
- [AKV Secret Provider - github.io docs](https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/)
- [Provide an identity to access the AKV Provider for Secrets Store CSI Driver](https://docs.microsoft.com/azure/aks/csi-secrets-store-identity-access)
