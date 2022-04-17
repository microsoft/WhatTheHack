# Challenge 02 - AzureLoadTesting - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

- Install the sample app [GitHub Link](https://github.com/Azure-Samples/nodejs-appsvc-cosmosdb-bottleneck) (Copying instructions from GitHub)
    - az login
      az account set -s mySubscriptionName
    - git clone https://github.com/Azure-Samples/nodejs-appsvc-cosmosdb-bottleneck.git
    - Go into the directory where the repo was cloned to then run .\deploymentscript.ps1
    - You will be prompted for information such as app name, subscription, region etc.. as it creates your environment.  It will take some time to create.
    - Test to make sure you app worked.  https://<app_name>.azurewebsites.net
- Sample solution jmeter script is located in the resource directory.