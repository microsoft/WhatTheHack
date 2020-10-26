# Coach's Guide: Challenge 2 - Stream patient data and unit testing

[< Previous Challenge](./Solution01.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution03.md)

# Notes & Guidance

## Deploy an Azure Function that reads from FHIR server and writes to the SQL interface of CosmosDB.
- Provide sample code for reading from FHIR
    - dataread.js + config.json
- Trigger your function manually for now
- **[Tutorial: Build a Node.js console app with the JavaScript SDK to manage Azure Cosmos DB SQL API data](https://docs.microsoft.com/en-us/azure/cosmos-db/sql-api-nodejs-get-started)**
- Setup your Node.js app:
    - Before you start writing code to build the application, you can build the framework for your app. Run the following steps to set up your Node.js application that has the framework code:
        - Open your favorite terminal.
        - Locate the folder or directory where you'd like to save your Node.js application.
        - Create two empty JavaScript files with the following commands in Windows:
            - $ fsutil file createnew app.js 0
            - $ fsutil file createnew config.js 0
        - Create and initialize a package.json file if not already exist, using the following command:
            - $ npm init -y
        - Install the @azure/cosmos module via npm, usig the following command:
            - npm install @azure/cosmos --save
- Set your app's configurations, update config.js:
    // ADD THIS PART TO YOUR CODE
    var config = {}

    config.endpoint = "~your Azure Cosmos DB endpoint uri here~";
    config.primaryKey = "~your primary key here~";
- Create Azure Functions for your app
    - Click 'Functions' icon in VS Code Azure Function Explorer
    - Choose and name HTTP Trigger
    - Set Authentication = Anomynous
- Run and test function app locally:
    - To run the project locally, press F5
    - Browse to the outputted localhost url to test 
- Deploy dataread.js app to Azure Functions:
    - Click on the up arrow icon
    - Input globally unique name for your function app
    - Select your location/region
    - Choose to create new storage account and hit 'Enter'
