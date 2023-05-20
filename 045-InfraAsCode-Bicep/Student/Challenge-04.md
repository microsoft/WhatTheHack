# Challenge 04 - Secret Values with Azure Key Vault

[< Previous Challenge](./Challenge-03.md) - [Home](../README.md) - [Next Challenge >](./Challenge-05.md)

## Introduction

The goal for this challenge is to understand how to handle secret values, e.g., **Don't encode secrets in your code!**

So far, the only parameters you have passed into your template have been related to storage accounts. In a later challenge, you will deploy resources requiring secret credentials as parameters. It is an **ANTI-pattern** to put a secret value such as a password in plain text in a parameter file! 

**NEVER. DO. THIS... EVER!**

It is a BEST practice to store secret values (such as passwords) in the Azure Key Vault service.

**FACT:** Committing a secret value into a public Git repository automatically compromises it, even if you immediately reverse the commit to delete the secret from the repo. This is because the secret value will remain in the repository's history for all to see. You should consider that secret compromised and replace it with a new value immediately.

## Description

In this challenge, you will create an Azure Key Vault and store a secret in it.  Then you will create a Bicep template and parameters file that reads from the key vault.

It can be tricky to deploy an Azure Key Vault. In the interest of time, we are providing a Bicep template that does it for you. You can find the `create-key-vault.bicep` file in the `/Challenge-04` folder of the `Resources.zip` file provided by your coach.

This Bicep template will create a Key Vault for you and prompt you to enter a secret value (password) that you want to store in the vault. 
- The key vault will have a unique name that is prefixed with: `kvwth`
- The secret value you enter will be stored in the key vault in a secret named `adminPassword`. 

Your challenges are:

- Create an Azure Key Vault and store a secret value in it by deploying the provided Bicep template.

**HINT:** You have just deployed other Bicep templates in the previous challenges, so you should know HOW to do this by now. 
- Check that the key vault has been created in the Azure portal. 
- Create a new Bicep template and parameters file that reads the secret from Azure Key Vault and outputs the secret value as a template output.  
  - *Yes, this is an anti-pattern! We are just doing it as a learning exercise. You will correct this anti-pattern in a later challenge.*

## Success Criteria

1. Verify the value of the parameter output from your Bicep template

## Advanced Challenge (Optional)

- You should NOT be able to view the secret value in the Azure portal by default. Figure out how to view the secret in the portal.
