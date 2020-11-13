# Challenge 3: Incremental ETL HL7 patient data and stream FHIR CRUD events for post-processing

[< Previous Challenge](./Challenge02.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge04.md)

## Introduction

In this challenge, you will implent the **[FHIR Event Processor](https://github.com/microsoft/health-architectures/tree/master/FHIR/FHIREventProcessor)** services to import and process valid HL7 messages, persist them into FHIR server and publish successful FHIR server CRUD events to an Event Hub.  Consumers can subscribe to this Event Hub queue topic in order to orchestrate post-processing event-driven workflows. 

![FHIR Event Processor](../images/fhir-event-processor.jpg)

Let's put it all together, you will extend previous challenge's HL7 Ingest and Convert architecture to include the FHIR Event Processor component as depicted below:
![HL7 ingest, conversion and bulk load](../images/fhir-hl7-ingest-conversion-bulkload-samples-architecture.jpg)

## Description

- Deploy **[HL7 Ingest, Conversion Samples](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** logic app based workflow to perform orderly conversion from HL7 to FHIR via FHIR Converter, persist the HL7 messages into FHIR Server and publish FHIR CRUD change events to Event Hubs for post-Processing workflows.
    - **[Download or Clone the Microsoft Health Archtectures GitHub repo](https://github.com/microsoft/health-architectures)**
    - Open a bash shell into the Azure CLI 2.0 environment
    - Switch to HL7Conversion subdirectory of this repo
    - Run the `deployhl72fhir.bash` script and follow the prompts
- Send in an HL7 message via HL7 over HTTPS:
    - Locate the sample message samplemsg.hl7 in the root directory of the repo
    - Use a text editor to see contents
    - From the linux command shell run the following command to test the hl7overhttps ingest
    ```
    curl --trace-ascii - -H "Content-Type:text/plain" --data-binary @samplemsg.hl7 <your ingest host name from above>/api/hl7ingest?code=<your ingest host key from above>
    ```
    - You should receive back an HL7 ACK message to validate that the sample hl7 message was accepted securely stored into blob storage and queued for HL7 to FHIR Conversion processing on the deployed service bus queue
    - To test the end-to-end Conversion process, you can see execution from the HL7toFHIR Logic App Run History in your HL7toFHIR resource group. This will also provide you with detailed steps to see the transform process in the Logic App run.

## Success Criteria
- You have extend previous challenge's HL7 Ingest and Convert architecture by deploying the FHIR Event Processor.
- You have tested sending sample HL7 message via HL7OverHTTPS
- You have tested the end-to-end HL7 message to FHIR conversion process.
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




