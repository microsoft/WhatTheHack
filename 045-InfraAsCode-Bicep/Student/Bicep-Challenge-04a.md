# Challenge 4 - Secret Values with Azure Key Vault

[< Previous Challenge](./Bicep-Challenge-03.md) - [Home](../README.md) - [Next Challenge >](./Bicep-Challenge-05.md)

## Introduction

The goals for this challenge are to understand how to handle secret values, e.g., **Don't encode secrets in your code!**

So far, the only parameters you have passed into your template have been related to storage accounts. In a later challenge, you will deploy resources requiring secret credentials as parameters. It is an **ANTI-pattern** to put a secret value such as a password in plain text in a parameter file! NEVER do this!

It is a BEST practice to store secret values (such as passwords) in the Azure Key Vault service.

## Description

In this challenge, you will create an Azure Key Vault and store a secret in it.  Then you will create a Bicep template & parameters file that reads from the key vault.

## Setup

It can be tricky to deploy an Azure Key Vault. In the interest of time, we are providing a Bicep template for you to deploy.


Key Vault Bicep file:

```bicep
var keyVaultName = 'kvwth${uniqueString(resourceGroup().id)}'

@description('Specifies the Azure region where the Key Vault should be created.')
param location string = resourceGroup().location

@description('Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the Key Vault.')
param enabledForDeployment bool = true

@description('Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the Vault and unwrap keys.')
param enabledForDiskEncryption bool = false

@description('Specifies whether Azure Resource Manager is permitted to retrieve secrets from the Key Vault.')
param enabledForTemplateDeployment bool = false

@description('Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the Key Vault. Get it by using `Get-AzSubscription` cmdlet.')
param tenantId string = subscription().tenantId

@description('Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.')
param keysPermissions array = [
  'list'
]

@description('Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.')
param secretsPermissions array = [
  'list'
]

@description('Specifies whether the Key Vault is a Standard vault or a Premium vault.')
@allowed([
  'standard'
  'premium'
])
param skuName string = 'standard'

@description('Specifies the name of the secret that you want to create.')
param secretName string = 'adminPassword'

@description('Specifies the value of the secret that you want to create.')
@secure()
param secretValue string

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    enabledForTemplateDeployment: enabledForTemplateDeployment
    tenantId: tenantId
    accessPolicies: []
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource secret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: kv
  name: secretName
  properties: {
    value: secretValue
  }
}
```

Sample Powershell script for deployment

_Note: this is a sample script; feel free to modify_

```powershell
$RG="<your rg>" 
$LOCATION="<your region>"
$DEPLOYMENT="ch4deployment"

az group create --name $RG --location $LOCATION
az deployment group create --resource-group $RG --template-file akv.bicep
```

Key Vault creation script (Bash):

```bash
RG="<your rg>" 
LOCATION="<your region>"
DEPLOYMENT="ch4deployment"

az group create --name $RG --location $LOCATIONaz deployment group create --resource-group $RG --template-file akv.bicep
```

## Challenges

Your challenges are:

+ Create an Azure Key Vault and store a secret value in it by running the provided Bicep template (provided in Setup section above).  
+ Next, check that the key vault has been created in the Azure portal. To view the secret in the portal, you'll need to add your userid to the keyvault access policies.
+ Next, create an new Bicep template and parameters file that reads the secret from Azure Key Vault and outputs the secret value as a template output.  _(Yes this is a anti-pattern! We are just doing it as a learning exercise)_

## Success Criteria

1. Verify the value of the parameter output from your Bicep template
