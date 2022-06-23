# Challenge 4 - Secret Values with Azure Key Vault

[< Previous Challenge](./Bicep-Challenge-03.md) - [Home](../README.md) - [Next Challenge>](./Bicep-Challenge-05.md)

## Introduction

The goals for this challenge are to understand:
- Handling secret values
- Not getting fired!

So far, the only parameters you have passed into your template have been related to the Virtual Network. In the next challenge you will deploy a VM which will require you to pass in a password for the VM's admin account.  It is an **ANTI-pattern** to put a secret value such as a password in plain text in a parameter file! NEVER do this!

#### **Seriously, this is something that could cost you your job!**

It is a BEST practice to store secret values (such as passwords) in the Azure Key Vault service. We have provided you with a script that can create a Key Vault for you, and prompt you to enter the secret value (password) you want to store in the vault.

## Description

Your challenge, should you accept it, is to:
+ Create an Azure Key Vault and store a secret value in it by running one of the provided KeyVault scripts of your choice. You can find the scripts in the Resources folder for **Bicep-Challenge-04**:
    - create-key-vault-CLI.sh - Azure CLI
    - create-key-vault-PS.ps1 - PowerShell
+ Retrieve the secret value from Azure Key Vault and pass it into your template as a parameter without having the value exposed as plain text at any point in time!


## Success Criteria

1. Verify the value of the parameter in the portal after deployment

## Advanced Challenge (Optional)

The goal of this challenge was focused on how to _retrieve_ secret values from Key Vault for use in an ARM Template with Bicep. You can create an Azure Key Vault using an ARM Template too.  Feel free to try this as a bonus challenge.