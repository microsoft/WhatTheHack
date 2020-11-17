# Challenge 3: Ingest and stream HL7 FHIR CRUD events for post-processing

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will deploy HL7 Ingest platform and HL7 Conversion workflow, which includes the following reference architectures

**[FHIR Event Processor](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIREventProcessor)** reference architeture to import and process valid HL7 messages, persist them into FHIR server and publish FHIR CRUD events referencing FHIR resources to a high speed Event Hub.  Consumers can subscribe to these events in order to orchestrate post-processing event-driven processing (below). 

![FHIR CRUD Post Processing Sample](../images/fhir-serverless-streaming.jpg)

**[HL7 to FHIR Conversion](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** reference architecture will create a logic app based workflow that is triggered whenever a new hl7 message is pushed to hl7ingest Service Bus queue. This conversion workflow performs orderly conversion from HL7 to FHIR via the FHIR Converter, persists converted hl7 message to FHIR Server.

![HL7 to FHIR Conversion](../images/hl72fhirconversion.png)

Note: After successful deployment, the converter pipeline is now tied to HL7 Ingest platorm.

Let's put it all together, you will extend the FHIR Server Samples and FHIR Converter reference architectures with HL7 Ingest/FHIR Event Processor reference architecture (below):
![HL7 ingest, conversion and bulk load](../images/fhir-hl7-ingest-conversion-bulkload-samples-architecture.jpg)

## Description



- Deploy **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** logic app based workflow to perform orderly conversion from HL7 messages to FHIR via FHIR Converter, persist them into FHIR Server and publish FHIR CRUD change events to Event Hubs for post-Processing.

    Hint:
    - **[Download or Clone the Microsoft Health Archtectures GitHub repo](https://github.com/microsoft/health-architectures)**
    - Open a bash shell into the Azure CLI 2.0 environment
    - Switch to HL7Conversion subdirectory of this repo
    - Run the `deployhl72fhir.bash` script and follow the prompts
- Test send sample HL7 message via hl7overhttps ingestion service.

    Hint:
    - Locate the sample message samplemsg.hl7 in the root directory of the cloned GitHub repo
    - Use a text editor to see contents
    - From the linux command shell run the following command to test the hl7overhttps ingest
        ```
        curl --trace-ascii - -H "Content-Type:text/plain" --data-binary @samplemsg.hl7 <your ingest host name from above>/api/hl7ingest?code=<your ingest host key from above>
        ```
    - You should receive back an HL7 ACK message to validate that the sample hl7 message was accepted securely stored into blob storage and queued for HL7 to FHIR Conversion processing on the deployed service bus queue
    - To validate the end-to-end HL7 Conversion process, you can see execution from the HL7toFHIR Logic App Run History in your HL7toFHIR resource group. This will also provide you with detailed steps to see the transform process in the Logic App run.

## Success Criteria
- You have deployed HL7 Ingest, Conversion and FHIR Event Processor reference architectures.
- You have tested sending sample HL7 message via HL7OverHTTPS
- You have validated the end-to-end HL7 message to FHIR conversion process.
- You have validated CRUD event is published to Event Hub

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




