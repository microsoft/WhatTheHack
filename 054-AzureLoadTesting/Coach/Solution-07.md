# Challenge 07 - Load Testing With Chaos Experiment (Resilience Testing) - Coach's Guide 

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)**

## Notes & Guidance

Here are instructions on how to setup Chaos Studio and run the experiment.  Chaos Studio does not offer a GitHub Action at this time.  We want the users to get a taste of chaos engineering so they can trigger the chaos experiment manually while the load test runs.  They are not required to implement this all in the pipeline.  That is an advanced challenge.

- Azure Chaos studio only supports a number of faults such as VMs, AKS, Cosmos DB, and networking to name a few.  Since our sample app only contains App Services and Cosmos DB, we will use the Cosmos DB faults.
- First you will need to enable geo-redundancy in your Cosmos DB.  Go to your Cosmos DB instance and select "Enable Geo Redundancy" on the top bar.  Keep note of the paired region your Cosmos DB is paired with.
- Create Azure Chaos Studio/Experiment
    - Register Chaos Studio Provider
        - Go to your subscription
        - On the left-hand side, select "Resource provider"
        - In the list of providers, search for "Microsoft.Chaos"
        - Click on the provider and select "Register"
    - Go to Azure Chaos Studio
    - Under "Targets" select "Enable Targets" then "Enable service-direct targets"
    - Select the Cosmos DB service for your load test.
    - On the left-hand side, select "Experiments"
    - Select "Add an experiment"
    - Fill in your subscription, resource group, location, and name for this experiment.  Keep track of the experiment name as a managed user will be created for you.
    - Go to the experiment designer on the next tab.  Change the name of the step or branch if you wish.
    - Select "Add Action" follows by "Add Fault"
    - Select "Cosmos DB Failover" as the Fault.  You can choose the duration but 2-3 mins should be enough.  Finally, enter the region that your instance is paired with in the "readRegion" section.
    - Save your experiment.
- Update Cosmos DB Permissions
    - In Cosmos DB select "Access Control"
    - Select "Add" followed by "Add Role Assignment"
    - Select the CosmosDBOperator role, then click "Select members".
    - Search the name of the experiment from the earlier step and then click "Select".
    - Review and assign the permissions which will grant the role to the experiment.

- Run load test + experiment
    - Run the load test first, then while the load test is running kick off the chaos experiment.  You should notice that the application does not fail, but there will be a large spike in response time when you kick off the chaos experiment.  You should only see one spike and the app should return to normal behavior afterwards.


