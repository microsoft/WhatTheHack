# Challenge 01 - AzureLoadTesting - Coach's Guide 

**[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance
- Sample Load Testing Plan


- Define what services and the scope of your testing - Requirements
    - We will be simulating an average day where a user attempts to calculate ROI in a YTD timespan across multiple individual stocks and funds.  This will test the primary functionality of the service along with the majority of the Azure Services such as the Web App, API Management, Function App, and Cosmos DB.  This scope will not cover the other function app and 3rd party integration with exchanges as it is a separate process with different testing requirements.  We want this load test to always ensure our applications are functioning as expected now and in the future.

- Environment Requirements
    - Since we are only testing the ROI calculation we will need the following resources at the same level as production.
        - Function for calculating ROI
        - Cosmos DB
        - API Management
        - Web App

- Identify the load characteristics and scenario
    - Our current average daily load is 1000 users/hour.  We will mimic the average daily load along with our most common scenario which is calculating ROI YTD.  Since there is a consistent daily load, we will mimic this with a gradual start simulating the start of the day where you only get east cost traffic and peaking later when all 3 time zones wake up.  Since it does not spike straight to 1000 users, we will gradually increase load to simulate a normal day.

- Identify the test failure criteria
    - Our test will fail if we are unable to support 1000 users as we already know this is the current demand.
    - We will also consider this a failed test if we find performance below expected thresholds as this may impact customer satisfaction.

- Identify how you will be monitoring your application
    - We will be monitoring our applications with application insights to detect any errors and monitor performance.
    
- Identify potential bottlenecks/limitations in advance
    - Since we do not cache any data at any level.  Any component failing could cause an issue downstream.
    
- Please note any assumptions
    - We are assuming these are only casual end users and not other 3rd parties who could hit API Management to access the same data.
    - We are using consumption based model for Azure Functions
    - Application is not caching any data and always makes calls to Cosmos DB


