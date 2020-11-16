# Coach's notes for the Azure Serverless What The Hack

## Challenge 1 (Setup)
1) There is a DownGit link in the [Student Setup](./Student/Setup.md) for students to download a zip of the contents of the resources folder.  They will need to unzip the file to access the folders and content.


## Challenge 2 (Create a Hello World Function)
1) Some Windows users may get an execution policy error when running in a powershell terminal.  They can run Get-ExecutionPolicy to determine if they are restricted.  They can run [Set-ExecutionPolicy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7) with the desired scope.
2) Depending on which language is chosen by the student, there may be extra installations required.
3) Check for supported version language [versions](https://docs.microsoft.com/en-us/azure/azure-functions/supported-languages)


## Challenge 3 (Create Resources)
None

## Challenge 4 (Configuration)
None

## Challenge 5 (Deployment)
*As of May 2020, there is a new Portal view of the functions*
1) Those that are not familiar with Azure functions will not know about how the Applications Settings work with the Function Code
2) Key Vault reference in the Function App will require a reference __@Microsoft.KeyVault__ in the app setting value
3) __ERRORS on KEY VAULT__
You cannot see if there is an error in the new portal.  Navigate to the old portal and if you see this error, the reference to the key vault is bad: ![Key Vault Error](./images/keyvault-error.PNG)

Participants may need to allow an identity access [Identity Access](https://docs.microsoft.com/en-us/azure/app-service/overview-managed-identity?context=azure%2Factive-directory%2Fmanaged-identities-azure-resources%2Fcontext%2Fmsi-context&tabs=dotnet)

Then add permissions in Key Vault to the Function
Success looks like this ![Key Vault Success](./images/keyvault-success.PNG)


## Challenge 6 (Create Functions)
Integration has changed in the new functions portal.  Might have to go to the old portal to add the integration.

## Challenge 7 (Monitoring)
The App insights can be created in new or old functions portal.  In new, Instrumentation key is not needed.  In old, the key will need to be added to the app settings.

For edits to the App.config, the following will need to be added:
```javascript
  <appSettings>
    <add key ="blobStorageConnection" value="THEIR_BLOB_CONNECTION_STRING"></add>
  </appSettings>
```

If students still get a storage account error, then they need to add the connection string to the Debug tab in the Function's properties Command Line arguements

## Challenge 8 (Data Export Workflow)
None


## Optional Challenge 1 (Scale the Cognitive Service)
None

## Optional Challenge 2 (View Data in Cosmos DB)
None
