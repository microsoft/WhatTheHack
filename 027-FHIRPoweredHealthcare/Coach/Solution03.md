# Coach's Guide: Challenge 2 - Ingest and stream HL7 FHIR CRUD events for post-processing

[< Previous Challenge](./Solution01.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution03.md)

## Notes & Guidance
In this challenge, you will implent the **[FHIR Event Processor](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIREventProcessor)** reference architeture to import and process valid HL7 messages, persist them into FHIR server and publish FHIR CRUD events referencing FHIR resources to a high speed Event Hub.  Consumers can subscribe to these events in order to orchestrate post-processing event-driven processing (below). 

![FHIR CRUD Post Processing Sample](../images/fhir-serverless-streaming.jpg)

You will create a logic app based workflow triggered whenever a new hl7 message is pushed to hl7ingest Service Bus queue. This conversion workflow performs orderly conversion from HL7 to FHIR via the FHIR Converter, persists converted hl7 message to FHIR Server.

![HL7 to FHIR Conversion](../images/hl72fhirconversion.png)

Let's put it all together, you will extend the FHIR Server Samples and FHIR Converter reference architectures with HL7 Ingest/FHIR Event Processor reference architecture (below):
![HL7 ingest, conversion and bulk load](../images/fhir-hl7-ingest-conversion-bulkload-samples-architecture.jpg)

**Deploy **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** logic app based workflow to perform orderly conversion from HL7 messages to FHIR via FHIR Converter, persist them into FHIR Server and publish FHIR CRUD change events to Event Hubs for post-Processing.
- 
**Deploy HL7 Ingest Platform**
- **[Download or Clone the Microsoft Health Archtectures GitHub repo](https://github.com/microsoft/health-architectures)**
- Open a bash shell into the Azure CLI 2.0 environment
- Switch to 'HL7Conversion' subdirectory of in your local repo
- Run the `./deployhl7ingest.bash` script and follow the prompts
    - Enter your subscription ID
    - Enter a Resource Group name (new or exising)
    - Enter Resource Group location
    - Enter deployment prefix (environment name)

    Note: You should receive the following acknowledgement at the end of dpeloyment.
    *****************************************************************************
    HL7 Ingest Platform has successfully been deployed to group wth-fhir on Sat, Oct 31, 2020 11:26:59 PM
    Please note the following reference information for future use:
    Your ingest host is: https://hl7ingest#####.azurewebsites.net
    Your ingest host key is: a7P4X9F...X1w==
    Your hl7 ingest service bus namespace is: hlsb####
    Your hl7 ingest service bus destination queue is: hl7ingest
    Your hl7 storage account name is: [ENVIRONMENTNAME]fhirstore####
    Your hl7 storage account container is: hl7
    *****************************************************************************

- Validate resources created in the deployment
    - Storage account: XXXstore##### and container: hl7
    - Service Bus Namespace: hlsb#### and queue: hl7ingest
    - Function App (HTTP Trigger): hl7ingest#####
    - Application Insights: hl7ingest#####
**Deploy HL7 to FHIR Conversion Workflow**
- In bash shell, run the `./deployhl72fhir.bash` script and follow the prompts
    - Enter your subscription ID
    - Enter a Resource Group name (new or exising)
    - Enter Resource Group location
    - Enter deployment prefix (environment name)
    - Enter a resource group name to deploy the converter to: [EVIRONMENTNAME]hl7conv
    - Enter the name of the HL7 Ingest Resource Group (from above hl7ingest deployment)
    - Enter the name of the HL7 Ingest storage account (from above hl7ingest deployment)
    - Enter the name of the HL7 ServiceBus namespace (from above hl7ingest deployment)
    - Enter the name of the HL7 ServiceBus destination queue (from above hl7ingest deployment)
    - Enter the destination FHIR Server URL
    - Enter the FHIR Server Service Client Application ID
    - Enter the FHIR Server Service Client Secret:
    - Enter the FHIR Server/Service Client Audience/Resource (https://azurehealthcareapis.com)
    - Enter the FHIR Server/Service Client Tenant ID

    Note: You should receive the following acknowledgement at the end of dpeloyment.
    *****************************************************************************
    HL72FHIR Workflow Platform has successfully been deployed to group [ENVIRONMENTNAME] on Sun, Nov  1, 2020  2:37:59 PM
    Please note the following reference information for future use:
    Your HL7 FHIR Converter Host is: XXXfhirhl7conv####
    Your HL7 FHIR Converter Key is:
    Your HL7 FHIR Converter Resource Group is: XXXfhirhl7conv
    *****************************************************************************
- Validate resources created in the deployment
    - Storage account: [ENVIRONMENTNAME]store#####
    - FHIR Event Hub Namespace: fehub###
    - FHIR Event Hub: fhirevents
    - FHIREventProcessor Function App: fhirevt####
    - Application Insights: fhirevt####
    - Logic App: HL7toFHIR.  Workflow steps are:
        - When a message is received in a hl7ingest queue (HL7ServiceBus)
        - Get blob content (hl7blobstorage)
        - Connections - Custom Logic App connection (HL7FHIRConverter)
        - Import Bundle to FHIR Server (Connected thru FHIR Server Proxy)
    
Note: After successful deployment, converter pipeline is now tied to ingest platorm.

- Test send a sample hl7 message via HL7 over HTTPS
    - Locate the sample message samplemsg.hl7 in the root directory of the cloned GitHub repo
    - Use a text editor to see contents
    - From the linux command shell run the following command to test the hl7overhttps ingest
        ```
        curl --trace-ascii - -H "Content-Type:text/plain" --data-binary @samplemsg.hl7 <your ingest host name from above>/api/hl7ingest?code=<your ingest host key from above>
        ```
    - You should receive back an HL7 ACK message to validate that the sample hl7 message was accepted securely stored into blob storage and queued for HL7 to FHIR Conversion processing on the deployed service bus queue
    - You can also see execution from the HL7toFHIR Logic App Run History in the HL7toFHIR resource group. This will also provide you with detailed steps to see the transform process


