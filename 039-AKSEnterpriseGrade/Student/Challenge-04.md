# Challenge 04 - Secrets and Configuration Management

[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

The goals of this challenge focus on managing configuration settings and secrets for the sample application in Kubernetes. e.g., **Don't encode secrets in your code!**

You should have observed by now:

- The sample application's Web container requires one configuration setting:
    - `API_URL`: URL where the SQL API can be found, for example `http://1.2.3.4:8080` or `http://api:8080`
- The sample application's API container requires two configuration settings:
    - `SQL_SERVER_FQDN`: FQDN of the SQL server
    - `SQL_SERVER_USERNAME`: username for the SQL server
- The API container also requires one secret value:
    - `SQL_SERVER_PASSWORD`: password for the SQL server

The Web & API containers look for these values in environment variables by default. Alternatively, they can be configured to read these values from a mounted storage volume.

- **HINT:** Refer to the [Web](./Resources/web) and [API](./Resources/api) container documentation for details.

At this point in time, you have likely set those environment variable values by "hard coding" them into your deployment YAML manifest files. It is an **ANTI-pattern** to put a secret value such as a password in plain text in a YAML manifest file! 

# NEVER. DO. THIS... EVER!!!

> **Warning** Committing a secret value into a public Git repository automatically compromises it, even if you immediately reverse the commit to delete the secret from the repo. This is because the secret value will remain in the repository's history for all to see. You must consider that secret value compromised and replace it with a new value immediately.

Kubernetes has built in mechanisms to handle configuration data and secrets. These include:
- [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)

> **Warning** ConfigMap does not provide secrecy or encryption. If the data you want to store are confidential, use a Secret rather than a ConfigMap, or use additional (third party) tools to keep your data private.

> **Warning** Kubernetes Secrets are, by default, stored unencrypted in the Control Plane's underlying data store (etcd). Anyone with Control Plane access can retrieve or modify a Secret, and so can anyone with access to etcd. 

It is a **BEST** practice to store secret values (such as passwords) in the [Azure Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/overview) service.

Luckily, there is an Azure Key Vault Provider for Secrets Store CSI Driver for AKS.  This provider allows you to use Azure Key Vault as a secret store in an AKS cluster by mounting secrets to a pod as a storage ([CSI](https://kubernetes-csi.github.io/docs/)) volume or syncing them to Kubernetes secrets.

## Description

You need to fulfill these requirements to complete this challenge:

- Supply environment variables to the Web and API containers over Kubernetes config maps or secrets.
- For sensitive parameters (like the database user password) make sure that they are not stored anywhere in the Kubernetes cluster, but in a purpose-built secret store such as Azure Key Vault.
- Non-sensitive configuration for the containers should be supplied from a configuration map, not hard coded in the manifests.
- Make sure that no static password is stored in the AKS cluster that allows access to the Azure Key Vault.

## Success Criteria

- Verify that environment variables in the deployment manifests are not hard coded, but imported from Kubernetes configuration maps.
- Verify that the SQL password is not stored as a Kubernetes Secret or Kubernetes ConfigMap.
- Verify the Web site can access and view the database after properly handling the configuration and secret values.
- Verify that no Azure Service Principal secret is stored in Kubernetes.

## Advanced Challenges (Optional)

- Enable SSL in the ingress controller, and have its SSL certificate supplied from a purpose-built store such as Azure Key Vault

## Learning Resources

These docs might help you achieving these objectives:

- [Kubernetes ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Azure Key Vault Overview](https://learn.microsoft.com/en-us/azure/key-vault/general/overview)
- [Azure Key Vault Basic Concepts](https://docs.microsoft.com/azure/key-vault/general/basic-concepts)
- [AKV Secret Provider - Microsoft docs](https://docs.microsoft.com/azure/aks/csi-secrets-store-driver)
- [Using the Azure Key Vault Provider](https://azure.github.io/secrets-store-csi-driver-provider-azure/docs/getting-started/usage/)
- [Provide an identity to access the Azure Key Vault Provider for Secrets Store CSI Driver](https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-identity-access)
