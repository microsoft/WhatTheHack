# What The Hack - Hack Coach Guide - Patient Search Primer

# Introduction
Welcome to the coach's guide for the Event-driven FHIR Patient Search What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

Also remember that this hack includes a optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

# Coach's Guides
## Challenge 0: **[Lab Environment Setup](Solution-00.md)**
- This hack will require a centralized environment to host a FHIR server that is prepopulated with patient data.
- We will be using the new Azure API for FHIR managed service and then populating it with dummy data.
- Install the Azure CLI if you haven’t already.
- Install the latest version of nodejs (at least 10.x) on your machine, if using Windows, use the bash shell in the Windows Subsystem for Linux.  
- Install ‘jq’ for your version of Linux/Mac/WSL:
   - brew install jq
   - sudo apt install jq
   - sudo yum install jq
   - sudo zypper install jq
   - If you see jq not found errors, make sure you’ve updated all your packages.

## Challenge 1: **[Prepare your auto-generated FHIR data and FHIR Server](Solution-01.md)**
- Configure the FHIR server:
   - First create a new service principal using this command:
      - az ad sp create-for-rbac -o json
   - Copy the “appId” and “password” that is output as we will need these later.
   - Find the “objectId” of this new service principal with this command:
      - az ad sp show --id {appId of the new SP} -o json | jq -r .objectId
   - Now we will deploy the ARM template for the new FHIR service:
      - We will need the ARM template file (azuredeploy.json) and parameters file (azuredeploy.parameters.json) in the current folder when running the commands below
         - These files are in the “0.0 - Hack Setup” folder.
      - Create a resource group in ‘northcentralus’ (this is one of the supported regions for preview):
      - az group create --name myRG --location northcentralus
   - Run the template and use the objectId from above:
      - az group deployment create --template-file azuredeploy.json --parameters @azuredeploy.parameters.json --parameters accessPolicyObjectId={objectId of SP} -g myRG --no-wait
   - Watch the deployment progress from the “Deployments” blade of the resource group.
- Configure the node.js data generation application:
   - We’ll be adding a new configuration section to the “config.json” file.
   - Copy and paste one of the pre-existing environments and change values that are different from the “default” configuration. Typically, these values include:
      - “tenant”: The Azure AD tenant in which you created the service principal above
      - “applicationId”: The “appId” value we saved during the creation of the service principal.
      - “clientSecret”: The “password” value we saved during the creation of the service principal.
      - “fhirApiUrl”: The URL to the FHIR service created above. You can find this on the Overview blade of the Azure API for FHIR resource:

 ## Challenge 2: **[Load patient data into FHIR Server](Solution-02.md)**
- Run the data generation application to insert patient records:
   - Download all dependencies by running: “npm install” at the root of the folder.
   - Run the datagen.js application and it will loop and create an endless number of patients. Press Ctrl-C when enough have been created.
   - node datagen.js

## Challenge 3: **[Deploy Event-driven architecture to read patient record from FHIR Server and store them in Azure Cosmos DB](Solution-03.md)**
- Run the data read application to read patient records in the FHIR Server:
   - Run the dataread.js application to make sure that the new patients can be read. NOTE: These records are read in pages of 100 at a time.
   - node dataread.js
- When finish reading and loading data, make sure there at least 10,000 patient records in Azure Cosmos DB

## Challenge 4: **[Build Patient Search API](Solution-04.md)**
- You have to manually run the indexer once you create it.
- Talk about Function authentication which is needed to make REST calls
   - Anonymous vs. Admin, etc
- Have to change function auth mode to hit it from laptops; works in portal without changing auth mode

## Challenge 5: **[Build a Patient Search web app to display patient record](Solution-05.md)**
- Build a web-app for your API
   - Your app should display patient records in pages of 10
   - Your app should include a search box
   - Include any other clever features that you want.
- Deploy your web-app to Azure App Services
