# Coach's Guide: Challenge 6 - Stream IoMT Device data into FHIR using MedTech service

[< Previous Challenge](./Solution05.md) - **[Home](../readme.md)**

## Notes & Guidance

In this challenge, you will work with medical IoT device data using the **[MedTech service](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/get-started-with-iot)** in Azure Health Data Services.  You will use **[MedTech service toolkit](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper)** to transform medical IoT device data into Fast Healthcare Interoperability Resources (FHIR®)-based Observation resources.  You will deploy a **[MedTech service data pipeline](microsoft.com/en-us/azure/healthcare-apis/iot/iot-data-flow)** to ingest medical IoT data, normaize and group these messages,transform the grouped-normalized messages into FHIR-based Observation resources, and then persist the transformed messages into the FHIR service (previously deployed in challenge 1).

The **[MedTech service](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/get-started-with-iot)** in Azure Health Data Services uses an event hub to ingests streaming event data from IoT medical devices, transforms them into FHIR-based Observation resources, retrieves associated Patient resource from FHIR service, adds them as reference to the Observation resource created, and then persists the transformed messages to the FHIR service.

**[Azure IoMT Connector Data Mapper](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper)** is the MedTech toolkit to visualize and configure normalize mapping between the medical Iot data and FHIR.  Once you completed the FHIR mapping, you can export it and upload the mapping files to your **[MedTech service Device Mapping](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/how-to-use-device-mappings)** configuration in Azure Portal.

### IoMT MedTech service scenario
You will deploy an instance of MedTech service in your Azure Health Data Service workspace, and configure it to receive and transform medical IoT data for persitence in your FHIR service (deployed in challenge 1) as Observation resources.

**Deploy **[Azure Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/)** for MedTech service to **[ingest](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/iot-data-flow#ingest)** medical IoT device data**

****[Deploy](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure)** a new instance of the MedTech service in your Azure Health Data Services workspace (deployed in challenge 1) and configure it to ingest IoT data from the above Event Hubs instance**

**Deploy the **[IoT mapper tool](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper)****
  - Import **[sample IoT messages](https://github.com/microsoft/azure-health-data-services-workshop/tree/main/Challenge-09%20-%20MedTech%20service/SampleData/Answers)** into tool to customize device mapping to FHIR
  - Export customized mapping in tool to generate the new Device Mapping and FHIR Mapping files

**Import the newly generated FHIR mapping into your MedTech service**
  - Configure and save the **[Device mapping](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#configure-device-mapping-properties)** JSON in the MedTech service (Device Mapping setting)
  - Configure and save the Destination mapping JSON to in the MedTech service (Destination setting)

**Send sample device data to persist in the FHIR service using Postman via **[MedTech service Event Hub service](https://docs.microsoft.com/en-us/rest/api/eventhub/get-azure-active-directory-token)****
