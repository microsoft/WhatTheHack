# Challenge 04 - Secret Values with Azure Key Vault - Coach's Guide

[< Previous Challenge](./Solution-03.md) - **[Home](./README.md)** - [Next Challenge >](./Solution-05.md)

## Notes & Guidance

In this challenge, we're showing the proper use of Azure Key Vault to protect secrets and their values.

The goal of this challenge is for students to learn how to RETRIEVE a secret value from Key Vault and pass it into a Bicep template. The goal is not to teach how to create a Key Vault and add a secret value to it. The hack provides a Bicep template to do this. The expectation is that the students should deploy the template without worrying what is in it at this point in the hack.

It is up to the Coach if you want to encourage students to explore the contents of the template and figure out how it works. Be prepared to answer questions about the contents if asked. 

When students try to view the secret value in the Key Vault in the Azure portal, they should NOT be allowed to see it by default.  It is listed as an "Advanced Challenge" for students to figure out how.  
- To view the secret in the portal, the student will need to add their user ID to the key vault's access policies.

## Learning Resources

- [Use Azure Key Vault to pass secure parameter value during Bicep deployment](https://learn.microsoft.com/azure/azure-resource-manager/bicep/key-vault-parameter?tabs=azure-cli)
