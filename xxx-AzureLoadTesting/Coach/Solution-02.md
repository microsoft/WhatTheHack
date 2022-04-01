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
- Create Azure Load Testing resource
    - Search for the Azure Load Testing resource on the top search bar and select the resource.
    - On the top left hand corner select "Create"
    - Select the Resource Group that was created by the sample app or create your own.  The resources must be in the same location.
    - Enter a unique name for the resource.
    - Ensure the location matches the location of your application deployed to.
    - Select "Review + create"
    - Review your configurations and then select "Create"
- Create Load Test
    - Go into your new resource.  You may see a warning on the top depending on your current access describing the access levels required.  If so add yourself as one of the roles such as "Load Testing Owner" or "Load Testing Contributor" as you will not be able to proceed otherwise.
    - Select "Create"
    - Fill out the name of the test and a description of the test.
    - Go to the "Test Plan" tab and select the jmeter script you have locally and then select "Upload"
    - Under the "Parameters" tab, enter "webapp" for the name of the environment variable.  Followed by the url for your sample app in the "Value" section.
    - Under the "Monitoring" tab, select "Add/Modify" and select the resources from the sample app followed by "Apply" so they are monitored.
    - Select "Review + create"
    - Review the settings and select "Create"
- Run the load test
    - In your Azure Load Test service, select "Tests" from the left hand side
    - Select the test that you created from the list
    - On the top of the screen select "Run"
    - A summary page should appear, you dont need to change anything here.  Select "Run"
