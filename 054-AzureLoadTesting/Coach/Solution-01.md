# Challenge 01 - Develop a Load Testing Strategy - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

Below is a sample load testing plan we have mapped out.  Students will have something different as we left it up to the student to interpret the environment however the overall feel should be similar.

- Sample Load Testing Plan


- Define what services and the scope of your testing - Requirements
    - We will be simulating an average day when a user hits our website during normal business hours 8 - 5 PM.  We will be testing all 3 endpoints (Get/Add/lasttimestamp) to ensure all features are tested.  

- Environment Requirements
    - Since we are testing the user, we will need the following resources at the same level as production.
        - App Service
        - Cosmos DB


- Identify the load characteristics and scenario
    - Our current average daily load is 1000 users/hour.  We will mimic the average daily load hitting all 3 endpoints.  Since there is consistent daily load we will mimic this with gradual load increasing linearly.  

- Identify the test failure criteria
    - Our test will fail if we are unable to support 1000 users as we already know this is the current demand.
    - We will also consider this a failed test if we find performance below expected thresholds as this may impact customer satisfaction.

- Identify how you will be monitoring your application
    - We will be monitoring our applications with Application Insights to detect any errors and monitor performance.
    
- Identify potential bottlenecks/limitations in advance
    - Since we do not cache any data at any level.  Any component failing could cause an issue downstream.
    
- Please note any assumptions
    - We are assuming these are only casual end users and not other 3rd parties who could be trying to obtain information about our traffic.
    - We are using consumption based model for Azure App Services
    - Application is not caching any data and always makes calls to Cosmos DB

- Reinforce the importance of using existing metrics/usage patterns/data to inform the load testing on their own application.
