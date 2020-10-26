# Event-driven FHIR Patient Search

# Introduction
Welcome to the coach's guide for the Event-driven FHIR Patient Search What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

Also remember that this hack includes a optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

# Coach's Guides
## Challenge 0: **[Pre-requisite - Ready, Set, GO!](./Solutions/Challenge00.md)**
- Install VS Code
- Install VS Code Extensions
- Install the Azure CLI if you haven’t already.
- Install the latest version of nodejs (at least 10.x) on your machine, if using Windows, use the bash shell in the Windows Subsystem for Linux.  
- Install ‘jq’ for your version of Linux/Mac/WSL:
   - brew install jq
   - sudo apt install jq
   - sudo yum install jq
   - sudo zypper install jq
   - If you see jq not found errors, make sure you’ve updated all your packages.

## Challenge 1: **[Extract, transform and load patient data](./Solutions/Challenge01.md)**
- Configure the FHIR server
- Configure the node.js data generation application
- Deploy node.js app to Azure Functions
- Run the data generation application to auto generate test patient data
- Alternatively, install, configure and run SyntheaTM Patient Generator tool to auto generate simulated patient data
- Ingest test FHIR patient data into FHIR Server by calling FHIR patient API or bulk ingestion from fhirimport Blob storage

 ## Challenge 2: **[Stream FHIR patient data and unit testing](./Solutions/Challenge02.md)**
- Run the data read application to read patient records in the FHIR Server
- For unit testing, extract FHIR patient data from FHIR Server and load them into Azure Cosmos DB (Unit Test container)
- When finish reading and loading data, make sure there at least 10,000 patient records stored in Azure Cosmos DB

## Challenge 3: **[Stream patient data with event-driven architecture](./Solutions/Challenge03.md)**
- Deploy Azure Event Hubs instance and configure partition to receive event stream of patient data from FHIR Server
- Update serverless function to read data from FHIR Server and write to Azure Event Hubs
- Alternatively, setup Azure Stream Analytics job with query to select input from FHIR Server and output to Azure Cosmos DB 

## Challenge 4: **[Index patient data for patient lookup](./Solutions/Challenge04.md)**
- Deploy Azure Cognitive Search and integrate Azure Cosmos DB with Azure Cognitive Search
- Setup index attributes to create indexer 
- Create the indexer for patient data stored in Azure Cosmos DB
- You can manually run the indexer once you create it.
- Expose indexer via REST API for patient lookup.

## Challenge 5: **[Display patient search results](./Solutions/Challenge05.md)**
- Build a web-app for your patient search API to lookup a patient
   - Your app should display patient records in pages of 10
   - Your app should include a search box that calls the indexer API
   - Include any other clever UI features to improve the user experience
- Deploy your web-app to Azure App Services
