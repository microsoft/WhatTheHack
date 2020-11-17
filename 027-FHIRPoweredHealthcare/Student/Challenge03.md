# Challenge 3: Ingest and stream HL7 FHIR CRUD events for post-processing

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will deploy a Health Architecture **[FHIR Event Processor](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIREventProcessor)** serverless solution to provide the following services in the **[FHIR Converter}(https://github.com/microsoft/FHIR-Converter)** for ingesting FHIR Resouces into the FHIR Server:
- Import and process valid HL7 bundles and persist them to a FHIR Compliant store
- FHIR Server Proxy connection to FHIR Server without exposing credentials
- Publish successful FHIR CRUD events referencing FHIR Resources to an event hub

Note: This function is deployed and configured as a part of the HL72FHIR Workflow Platform.

![FHIR CRUD Post Processing Sample](../images/fhir-serverless-streaming.jpg)

**[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** is an open source project that runs as a REST web service for converting health data from legacy formats to FHIR bundles.  Microsoft FHIR Converter currently supports HL7v2 and C-CDA to FHIR conversion.  It uses pre-installed **[Handlebars templates](https://handlebarsjs.com/)** to define data mapping for HL7v2 to FHIR and C-CDA to FHIR conversion.  It can be deploy separately or as part of the **[HL7 to FHIR Conversion](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** pipeline.

**[HL7 Ingest Platform](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#deploying-your-own-hl7-ingest-platform)** reference architeture is deployed to ingest HL7 messages and produce a consumable event in a Service Bus for processing by FHIR Event Processor function app.  It provides a sample a sample message `samplemsg.hl7` for testing the hl7overhttps ingest service.

**[HL7 to FHIR Conversion](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** reference architecture deployment will create a Logic App based workflow that is triggered whenever new HL7 message is added to the queue of hl7ingest Service Bus. This conversion workflow performs the following tasks:
- Orderly conversion from HL7 to FHIR via the **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)**
- Persists converted HL7v2 message into FHIR Server through secure proxied FHIR Server connection (FHIR Server Proxy). 
- Publishes FHIR change events referencing FHIR Resouces to an Event Hub.

![HL7 to FHIR Conversion](../images/hl72fhirconversion.png)

Note: After successful deployment, the converter pipeline is now tied to HL7 Ingest platorm.

### Let's put it all together**...
You will extend the FHIR Server Samples, HL7 Ingest and FHIR Converter reference architectures to form the end-to-end ingest, transform and load event-driven platform as shown below:
![HL7 ingest, conversion and bulk load](../images/fhir-hl7-ingest-conversion-bulkload-samples-architecture.jpg)


## Description

- Deploy **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** logic app based workflow to perform orderly conversion from HL7v2 messages to FHIR via FHIR Converter, persist them into FHIR Server and publish FHIR CRUD events to Event Hubs for post-processing.

    Hint:
    - **[Download or Clone the Microsoft Health Archtectures GitHub repo](https://github.com/microsoft/health-architectures)**
    - Open a bash shell into the Azure CLI 2.0 environment
    - Switch to HL7Conversion subdirectory of this repo
    - Run the `deployhl72fhir.bash` script and follow the prompts
- Test send sample HL7v2 message via hl7overhttps ingestion service.

    Hint:
    - Locate the sample message `samplemsg.hl7` in the root directory of the cloned Health Architecture GitHub repo
    - Use a text editor to see contents
    - From the linux command shell run the following command to test the hl7overhttps ingest
        ```
        curl --trace-ascii - -H "Content-Type:text/plain" --data-binary @samplemsg.hl7 <your ingest host name from above>/api/hl7ingest?code=<your ingest host key from above>
        ```
    - You should receive back an HL7 ACK message to validate that the sample hl7 message was accepted securely stored into blob storage and queued for HL7 to FHIR Conversion processing on the deployed service bus queue
    - To validate the end-to-end HL7 Conversion process, you can see execution from the HL7toFHIR Logic App Run History in your HL7toFHIR resource group. This will also provide you with detailed steps to see the transform process in the Logic App run.

## Success Criteria
- You have deployed HL7 Ingest, Conversion reference architectures that includes the FHIR Event Processor and FHIR Converter components.
- You have tested sending sample HL7v2 message via HL7OverHTTPS ingest service.
- You have validated the end-to-end HL7 Ingest and Conversion process.
- You have validated FHIR CRUD event is published to Event Hub for post-processing.

## Learning Resources

- **[FHIR Event Processor](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIREventProcessor)**
- **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)**
- **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)**
- **[FHIR Converter API Details](https://github.com/microsoft/FHIR-Converter/blob/master/docs/api-summary.md)**
- **[Using FHIR Bundle Conversion APIs](https://github.com/microsoft/FHIR-Converter/blob/master/docs/convert-data-concept.md)**
- **[FHIR Converter pre-installed templates for C-CDA and HL7v2](https://github.com/microsoft/FHIR-Converter/tree/master/src/templates)**
- **[Sample HL7 messages](https://github.com/microsoft/FHIR-Converter/tree/master/src/sample-data/hl7v2)**
- **[How to create a FHIR Converter template](https://github.com/microsoft/FHIR-Converter/blob/master/docs/template-creation-how-to-guide.md)**
- **[Browser based FHIR Converter template editor](https://github.com/microsoft/FHIR-Converter/blob/master/docs/web-ui-summary.md)**




