# Coach's Guide: Challenge 7: Bulk export, anonymize and store FHIR data into Data Lake

[< Previous Challenge](./Solution06.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution08.md)

## Notes & Guidance

- **Complete [Challenge 0](./Solution00.md) and [Challenge 1](./Solution01.md)**.

- If you get **Azure Batch error**, either Azure Batch is not enabled in your subscription or Azure Batch already deployed the max number of time in your subscription.

- If you would like to **adjust the start time or run interval**, open the Logic App in the deployed resource group. The first step called 'Recurrence' is where the timer is stored.

- If **Logic App fails on Get Token**, create a new token for `{ENVIRONMENTNAME}-service-client` for Azure API for FHIR, and save that as new secret in `{ENVIRONMENTNAME}-clientsecret Secrets` created in this challenge.

- Logic App succeeded, but **no output was found in Storage Account `{ENVIRONMENTNAME}dlg2`**, check if blobstorageacctstring secret in `{ENVIRONMENTNAME}kv` KeyVault has the connection string of Export Storage Account.

