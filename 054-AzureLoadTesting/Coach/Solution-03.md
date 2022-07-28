# Challenge 03 - Create Azure Load Testing Service and Establish Baselines - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

Below are the instructions to complete challenge 3

- Create Azure Load Testing resource
    - Search for the Azure Load Testing resource on the top search bar and select the resource.
    - On the top left hand corner select "Create"
    - Select the Resource Group that was created by the sample app or create your own.  The resources must be in the same location.
    - Enter a unique name for the resource.
    - Ensure the location matches the location that your application is deployed to.
    - Select "Review + create"
    - Review your configurations and then select "Create"
- Create Load Test
    - Go into your new resource.  You may see a warning on the top depending on your current access describing the access levels required.  If so, add yourself as one of the roles such as "Load Testing Owner" or "Load Testing Contributor" as you will not be able to proceed otherwise.
    - Select "Create"
    - Fill out the name of the test and a description of the test.
    - Go to the "Test Plan" tab and select the JMeter script you have locally and then select "Upload"
    - Under the "Parameters" tab, enter "webapp" for the name of the environment variable, followed by the URL for your sample app in the "Value" section.
    - Under the "Monitoring" tab, select "Add/Modify" and select the resources from the sample app followed by "Apply" so they are monitored.
    - Select "Review + create"
    - Review the settings and select "Create"
- Run the load test
    - In your Azure Load Test service, select "Tests" from the left hand side
    - Select the test that you created from the list
    - At the top of the screen select "Run"
    - A summary page should appear.  Add that this run is the baseline in the description.  Select "Run"
- Set Pass/Fail Criteria
    - Go back to your load test and select "Configure" followed by "Test"
    - Go to the "Test Criteria" Tab.
    - Enter in your test criteria such as failure rate under x %

Sample solution JMeter script is located in the solution directory [here](./Solutions/Challenge3/).