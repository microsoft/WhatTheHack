# Coach's Guide: Challenge 6 - : Ingest and Persist IoT Medical Device Data

[< Previous Challenge](./Solution05.md) - **[Home](../README.md)** - [Next Challenge>](./Solution07.md)

## Notes & Guidance

In this challenge, you will work with IoT medical device data using the **[MedTech service](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/get-started-with-iot)** in Azure Health Data Services.  You will use **[MedTech service toolkit](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper)** to transform IoT medical device data into Fast Healthcare Interoperability Resources (FHIR®)-based Observation resources.  You will deploy a **[MedTech service data pipeline](microsoft.com/en-us/azure/healthcare-apis/iot/iot-data-flow)** to ingest medical IoT data, normalize and group these messages,transform the grouped-normalized messages into FHIR-based Observation resources, and then persist the transformed messages into the FHIR service (previously deployed in challenge 1).

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
    - Enter name and create your event hub (i.e. `devicedata`)

    Hint: 
    - The partition count setting allows you to parallelize consumption across many consumers.
    - The message retention setting specifies how long the Event Hubs service keeps data.

**Deploy **[MedTech Service manually](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#deploy-the-medtech-service-manually)** in your AHDS workspace and configure it to use FHIR service deployed in challenge 1**
- Open your AHDS worksapce
- Select Deploy MedTech service button
- Select `+Add` MedTech service
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
        - Select `Create` or `Lookup` for Resolution Type 
        Hint: If device and patient resource doesn't exist in FHIR service, `Create` option will enable new resources will be created; otherwise an error will occur for `Lookup` option.
    
    Hint: The custom Device Mapping and Destination (FHIR) Mapping will be configured and generated using the IoT mapper tool later on in this challenge.

**Deploy the **[IoT mapper tool](https://github.com/microsoft/iomt-fhir/tree/main/tools/data-mapper)****
  - Import **[sample IoT messages](https://github.com/microsoft/azure-health-data-services-workshop/tree/main/Challenge-09%20-%20MedTech%20service/SampleData/Answers)** into tool to customize device mapping to FHIR
  - Export customized mapping in tool to generate the new Device Mapping and FHIR Mapping files

**Import the newly generated FHIR mapping into your MedTech service**
  - Configure and save the **[Device mapping](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot/deploy-iot-connector-in-azure#configure-device-mapping-properties)** JSON in the MedTech service (Device Mapping setting)
  - Configure and save the Destination (FHIR) mapping JSON to in the MedTech service (Destination setting)

**Send sample device data to persist in the FHIR service using Postman via **[MedTech service Event Hub service](https://docs.microsoft.com/en-us/rest/api/eventhub/get-azure-active-directory-token)****
- Get an Azure Active Directory (Azure AD) token to send events to an event hub
    - **[Register your app with AAD](https://docs.microsoft.com/en-us/rest/api/eventhub/get-azure-active-directory-token#register-your-app-with-azure-ad)**
        - In Azure Portal, go to AAD -> App registrations -> select `+ New registration`
        - Enter name for the client app/service principle and select `Register`
        - Go to `Overview` page for the client app service registered, save the following values for use in Postman configuration to get AAD token later.
            - Application (client) ID 
            - Directory (tenant) ID
        - Go to  `Certificates & secrets` page and select `+New client secret`
            - Enter description and when certificate will expire, then select `Add`
            - Copy the client secret value for use in Postman configuration to get AAD token later.
    - **[Add application to the Event Hubs Data Sender role](https://docs.microsoft.com/en-us/rest/api/eventhub/get-azure-active-directory-token#add-application-to-the-event-hubs-data-sender-role)**
        - In `Event Hubs Namespace`, select `Access Control (IAM)` page
            - Select `+Add` to add Role Assignment
                - Select Azure Event Hubs Data Sender for `Role` dropdown
                - Select `Azure AD user, group or principla` for `Assign access to` dropdown
                - Select your application for the service principal (name of client app/service principle created above).
                - Select `Save` to add the new role assignment
- Send events to an event hub via Postman
    - Open Postman and **[import Postman data](https://learning.postman.com/docs/getting-started/importing-and-exporting-data/)**: 
        - In Postman, click Import.
        - In your **[Student Resources folder for Postman](../Student/Resources/Postman)**, select **[Environment](../Student/Resources/Postman/WTHFHIR.IoT-MedTech.postman_environment.json)** and **[Collection](../Student/Resources/Postman/WTHFHIR.IoT-MedTech.postman_collection.json)** JSON files.
        - Confirm the name, format, and import as, then click Import to bring your data into your Postman.
        - You will get confirmation that `WTH FHIR-IoT-MedTech` Collection and Environment were imported and see in Postman a new `WTH FHIR-IoT-MedTech` in `Collections` (left) blade and top right `Manage Environments` drop-down list.
    - Select `WTH FHIR-IoT-MedTech_event hub namespace` environment and click `Environment Quick Look` button to see a list of env vars: 
        - Click `Edit` to open `Management Environments` window and input the corresponding FHIR environment values:
            - `adtenantId`: This is the tenant Id of the AD tenant
            - `clientId`: This is the client Id that is stored in Secret.
            - `clientSecret`: This is the client Secret that is stored in Secret.
            - `bearerToken`: The value will be set when `AuthorizeGetToken SetBearer` request below is sent.
            - `fhirurl`: This is the FHIR URL `https://{ENVIRONMENTNAME}.azurehealthcareapis.com` from FHIR service you created in challenge 1.
            - `resource`: `https://eventhubs.azure.net`
            - `eventhubnamespaceurl`: event hub namespace url created for MedTech service
        - Click the Update button and close the `MANAGE ENVIRONMENTS` window.
        
        - Run `Send message to devicedata` API HTTP Request in the `WTH FHIR-IoT-MedTech` Postman collection:
        - First, open `AuthorizeGetToken SetBearer` and confirm `WTH FHIR-IoT-MedTech_event hub namespace` environment is selected in the top-right `Environment` drop-down. 
            - Click the Send button to pass the values in the Body to AD Tenant, get the bearer token back and assign it to variable bearerToken.
        - Open `Send message to devicedata`
            - On the `Body` tab,
                - Select `raw` for the data type
                - Enter the test device data as the message for the body
            - Select `Send` to send the message to the Event Hub queue for processing by the MedTech service
                - If successful, you'll see the status as Created with the code 201 as shown in the following image.
                - On the `Event Hub Namespace` Overview page in the Azure portal, you'll' see that the messages are posted to the queue in the `Incoming Messages` section.
        **Note:** `bearerToken` has expiration, so if you get Authentication errors in any requests, re-run `AuthorizeGetToken SetBearer` to get a new `bearerToken`.

    - **Alternatively, you can configure Postman collection and environment manually as follows:**
        - **[Use Postman to get the AAD token](https://docs.microsoft.com/en-us/rest/api/eventhub/get-azure-active-directory-token#use-postman-to-get-the-azure-ad-token)**
        - **[Send messages to a queue](https://docs.microsoft.com/en-us/rest/api/eventhub/get-azure-active-directory-token#send-messages-to-a-queue)**
            - Configure a new Postman opertation
                - Select `Post` for method
                - Enter URI: `https://<EVENT HUBS NAMESPACE NAME>.servicebus.windows.net/<QUEUE NAME>/messages. Replace <EVENT HUBS NAMESPACE NAME>`
                    - Replace <EVENT HUBS NAMESPACE NAME> with the name of the Event Hubs namespace
                    - Replace <QUEUE NAME> with the name of the queue
                - on `Header` tab, add the following
                    - Add `Authorization` key and value: `Bearer <TOKEN from Azure AD>`
                    Hint: Don't copy the enclosing double quotes in the token value
                    - Add `Content-Type` key and `application/atom+xml;type=entry;charset=utf-8` as the value for it.
                - On the `Body` tab,
                    - Select `raw` for the data type
                    - Enter the test device data as the message for the body
                - Select `Send` to send the message to the Event Hub queue for processing by the MedTech service
                    - If successful, you'll see the status as Created with the code 201 as shown in the following image.
                - On the `Event Hub Namespace` Overview page in the Azure portal, you'll' see that the messages are posted to the queue in the `Incoming Messages` section.
- Verify device data is saved in the FHIR service as Observation resource(s) using Postman
    - Open Postman collection: `WTH FHIR` (imported in challenge 1)
    - First, run `AuthorizeGetToken SetBearer` API request and confirm `WTH FHIR` environment is selected in the top-right `Environment` drop-down. 
        - Click the Send button to pass the values in the Body to AD Tenant, get the bearer token back and assign it to variable `bearerToken`.
    - Run `Get Observation` API request and click the `Send` button. This will return all patients' Observation resources in the Response body.
    - Search for the test device data persisted in the FHIR service as Observation resource, i.e. sample Vital Signs data for Heart Rate.
    
    **Hint:** `bearerToken` has expiration, so if you get Authentication errors in any requests, re-run `AuthorizeGetToken SetBearer` to get a new `bearerToken`.



