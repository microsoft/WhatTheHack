# Coach's Guide: Challenge 6 - Stream IoMT Device data into FHIR using MedTech service

[< Previous Challenge](./Solution05.md) - **[Home](../readme.md)**

## Notes & Guidance

In this challenge, you will work with medical IoT device data using the **[MedTech service](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/get-started-with-iot)** in Azure Health Data Services.  You will use **[MedTech service toolkit](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper)** to transform medical IoT device data into Fast Healthcare Interoperability Resources (FHIR®)-based Observation resources.  You will deploy a **[MedTech service data pipeline](microsoft.com/en-us/azure/healthcare-apis/iot/iot-data-flow)** to ingest medical IoT data, normaize and group these messages,transform the grouped-normalized messages into FHIR-based Observation resources, and then persist the transformed messages into the FHIR service (previously deployed in challenge 1).

The **[MedTech service](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/get-started-with-iot)** in Azure Health Data Services uses an event hub to ingests streaming event data from IoT medical devices, transforms them into FHIR-based Observation resources, retrieves associated Patient resource from FHIR service, adds them as reference to the Observation resource created, and then persists the transformed messages to the FHIR service.

**[Azure IoMT Connector Data Mapper](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper)** is the MedTech toolkit to visualize and configure normalize mapping between the medical Iot data and FHIR.  Once you completed the FHIR mapping, you can export it and upload the mapping files to your **[MedTech service Device Mapping](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/how-to-use-device-mappings)** configuration in Azure Portal.

### IoMT MedTech service scenario
You will deploy an instance of MedTech service in your Azure Health Data Service workspace, and configure it to receive and transform medical IoT data for persitence in your FHIR service (deployed in challenge 1) as Observation resources.

**Deploy and configure **[Azure Event Hubs](https://docs.microsoft.com/en-us/azure/event-hubs/)** for MedTech service to **[ingest](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/iot-data-flow#ingest)** medical IoT device data**
- Create **[Event Hubs namespace](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create#create-an-event-hubs-namespace)** using Azure Portal
    - Search and select Event Hubs in Azure Portal
    - Click +Add in Event Hubs
    - Enter a unique name and other Azure parameters on the Create namespace page
    - Review and create Event Hubs Namespace
   
    Hint: An Event Hubs namespace provides a unique scoping container, in which you create one or more event hubs. 

- Create an **[Event Hub](https://docs.microsoft.com/en-us/azure/event-hubs/event-hubs-create#create-an-event-hub)** within the namespace
    - Click +Event Hub on the Event Hub blade of the Event Hubs Namespace page
    - Enter name and create your event hub

    Hint: 
    - The partition count setting allows you to parallelize consumption across many consumers.
    - The message retention setting specifies how long the Event Hubs service keeps data.

**Deploy **[MedTech Service manually](ttps://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#deploy-the-medtech-service-manually)** in your AHDS workspace and configure it to use FHIR service deployed in challenge 1**
- Open your AHDS worksapce
- Select Deploy MedTech service button
- Select +Add MedTech service
- Configure it to ingest IoT data from the newly created Event Hubs instance in this challenge
    - Enter MedTech service name (a friendly, unique name for your MedTech service)
    - Enter Event Hubs Namespace (name of the Event Hubs Namespace that you've previously deployed)
    - Enter Event Hubs name (the event hub that you previously deployed within the Event Hubs Namespace, i.e. `devicedata`)
    - Enter Consumer group (Defaults to `$Default`)
    - Under Device Mapping, 
        - Enter the Device mapping JSON code for use with your MedTech service
    - Under Destination,
        - Enter the destination properties associated with your MedTech service.
        - Enter the FHIR Service name (previously deployed in challenge 1)
        - Enter Destination Name (a friendly name for the destination)
        - Select `Create` or `Lookup` for Resolution Type (If device and patient resource doesn't exist in FHIR service, `Create` option will new resources will be created; otherwise an error will occur for `Lookup` option )
    
    Hint: The Device Mapping and Destination (FHIR) Mapping be generated using the IoT mapper tool later on in this challenge.

**Deploy the **[IoT mapper tool](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper)****
  - Import **[sample IoT messages](https://github.com/microsoft/azure-health-data-services-workshop/tree/main/Challenge-09%20-%20MedTech%20service/SampleData/Answers)** into tool to customize device mapping to FHIR
  - Export customized mapping in tool to generate the new Device Mapping and FHIR Mapping files

**Import the newly generated FHIR mapping into your MedTech service**
  - Configure and save the **[Device mapping](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#configure-device-mapping-properties)** JSON in the MedTech service (Device Mapping setting)
  - Configure and save the Destination mapping JSON to in the MedTech service (Destination setting)

**Send sample device data to persist in the FHIR service using Postman via **[MedTech service Event Hub service](https://docs.microsoft.com/en-us/rest/api/eventhub/get-azure-active-directory-token)****
