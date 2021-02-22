# Coach's Guide: Challenge 2 - Extract, transform and load HL7 medical data

[< Previous Challenge](./Solution01.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution03.md)

## Notes & Guidance

In this challenge, you will deploy a Health Architecture **[HL7toFHIR Conversion](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** serverless solution that provides the following services within **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** and FHIR Proxy:
- Import and process valid HL7 bundles and persist them to a FHIR Compliant store
- FHIR Server Proxy connection to FHIR Server without exposing credentials
- Publish successful FHIR CUD events referencing FHIR Resources to an event hub to support pre-processing and/or post-processing for event driven workflow and orchestration scenarios.  This can be done by enabling the PublishFHIREventPostProcess module of the FHIR Proxy.

**NOTE**: This function is deployed and configured as a part of the HL72FHIR Workflow Platform.

**[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** is an open source project that runs as a REST web service for converting health data from legacy formats to FHIR bundles.  Microsoft FHIR Converter currently supports HL7v2 and C-CDA to FHIR conversion.  It uses pre-installed **[Handlebars templates](https://handlebarsjs.com/)** to define data mapping for HL7v2 to FHIR and C-CDA to FHIR conversion.  It can be deploy separately or as part of the **[HL7 to FHIR Conversion](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** pipeline.

**[HL7 Ingest Platform](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#deploying-your-own-hl7-ingest-platform)** reference architeture is deployed to ingest HL7 messages and produce a consumable event in a Service Bus queue for processing by FHIR Event Processor function app.  It provides a sample `samplemsg.hl7` for testing the `hl7overhttps` ingest service.

**[HL7 to FHIR Conversion](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** reference architecture deployment will create a Logic App based workflow that is triggered whenever new HL7 message is added to the queue of `hl7ingest` Service Bus. This conversion workflow performs the following tasks:
- Orderly conversion from HL7 to FHIR via the **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)**
- Persists converted HL7v2 message into FHIR Server through secure proxied FHIR Server connection (FHIR Server Proxy). 
- Publishes FHIR change events referencing FHIR Resources to an Event Hub.

**NOTE**: After successful deployment, the converter pipeline is integrated with HL7 Ingest platform.

**[Deploy HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7-ingest-conversion-samples)** reference architectures below:

**Deploy HL7 Ingest Platform**
- Download or Clone the **[Microsoft Health Archtectures](https://github.com/microsoft/health-architectures)** GitHub repo
- Open a bash shell into the Azure CLI 2.0 environment
- Switch to `HL7Conversion` subdirectory in your local repo
- Run the `./deployhl7ingest.bash` script and follow the prompts
    - Enter your subscription ID
    - Enter a Resource Group name (new or existing)
    - Enter Resource Group location
    - Enter deployment prefix (environment name)

    **NOTE:** You should receive the following acknowledgement at the end of deployment.
    ```bash
    HL7 Ingest Platform has successfully been deployed to group wth-fhir on Sat, Oct 31, 2020 11:26:59 PM
    Please note the following reference information for future use:
    Your ingest host is: https://hl7ingest#####.azurewebsites.net
    Your ingest host key is: a7P4X9F...X1w==
    Your hl7 ingest service bus namespace is: hlsb####
    Your hl7 ingest service bus destination queue is: hl7ingest
    Your hl7 storage account name is: [ENVIRONMENTNAME]fhirstore####
    Your hl7 storage account container is: hl7
    ```

- Validate resources created in the deployment
    - Storage account: `XXXstore#####` and container: `hl7`
    - Service Bus Namespace: `hlsb####` and queue: `hl7ingest`
    - Function App (HTTP Trigger): `hl7ingest#####`
    - Application Insights: `hl7ingest#####`

**Deploy HL7 to FHIR Conversion Workflow**
- In bash shell, run the `./deployhl72fhir.bash` script and follow the prompts
    - Enter your subscription ID
    - Enter a Resource Group name (new or existing)
    - Enter Resource Group location
    - Enter deployment prefix (environment name)
    - Enter a resource group name to deploy the converter to: `[EVIRONMENTNAME]hl7conv`
    - Enter the name of the HL7 Ingest Resource Group (from above `hl7ingest` deployment)
    - Enter the name of the HL7 Ingest storage account (from above `hl7ingest` deployment)
    - Enter the name of the HL7 ServiceBus namespace (from above `hl7ingest` deployment)
    - Enter the name of the HL7 ServiceBus destination queue (from above `hl7ingest` deployment)
    - Enter the destination FHIR Server URL
    - Enter the FHIR Server Service Client Application ID
    - Enter the FHIR Server Service Client Secret
    - Enter the FHIR Server/Service Client Audience/Resource (`https://azurehealthcareapis.com`)
    - Enter the FHIR Server/Service Client Tenant ID

    **NOTE**: You should receive the following acknowledgement at the end of deployment.
    ```bash
    HL72FHIR Workflow Platform has successfully been deployed to group [ENVIRONMENTNAME] on Sun, Nov 1, 2020  2:37:59 PM
    Please note the following reference information for future use:
    Your HL7 FHIR Converter Host is: XXXfhirhl7conv####
    Your HL7 FHIR Converter Key is:
    Your HL7 FHIR Converter Resource Group is: XXXfhirhl7conv
    ```
- Validate resources created in the deployment
    - Storage account: `[ENVIRONMENTNAME]store#####`
    - FHIR Event Hub Namespace: `fehub###`
    - FHIR Event Hub: `fhirevents`
    - FHIREventProcessor Function App: `fhirevt####`
    - Application Insights: `fhirevt####`
    - Logic App: `HL7toFHIR`.  Workflow steps are:
        - When a message is received in a `hl7ingest` queue (`HL7ServiceBus`)
        - Get blob content (`hl7blobstorage`)
        - Connections - Custom Logic App connection (`HL7FHIRConverter`)
        - Import Bundle to FHIR Server (Connected thru FHIR Server Proxy)
- Test send a sample hl7 message via HL7 over HTTPS
    - Locate the sample message `samplemsg.hl7` in the root directory of the cloned GitHub repo
    - Use a text editor to see contents
    - From the Linux command shell run the following command to test the `hl7overhttps` ingest
        ```bash
        curl --trace-ascii - -H "Content-Type:text/plain" --data-binary @samplemsg.hl7 <your ingest host name from above>/api/hl7ingest?code=<your ingest host key from above>
        ```
    - You should receive back an HL7 ACK message to validate that the sample hl7 message was accepted securely stored into blob storage and queued for HL7 to FHIR Conversion processing on the deployed service bus queue
    - You can also see execution from the `HL7toFHIR` Logic App Run History in the `HL7toFHIR` resource group. This will also provide you with detailed steps to see the transform process


