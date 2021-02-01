# Challenge 8: Stream IoMT Device data into FHIR from IoT Central

[< Previous Challenge](./Challenge07.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge09.md)

## Introduction

In this challenge, you will stream IoMT Device data into FHIR from IoT Central. 

The **[Azure IoT Connector for FHIR](https://docs.microsoft.com/en-us/azure/healthcare-apis/iot-fhir-portal-quickstart)** for Fast Healthcare Interoperability Resources (FHIR®)* is a feature of Azure API for FHIR that provides the capability to ingest data from Internet of Medical Things (IoMT) devices. Azure IoT Connector for FHIR needs two mapping templates to transform device messages into FHIR-based Observation resource(s): device mapping and FHIR mapping. Device mapping template transforms device data into a normalized schema. On the IoT Connector page, click on Configure device mapping button to go to the Device mapping page. FHIR mapping template transforms a normalized message to a FHIR-based Observation resource. On the IoT Connector page, click on Configure FHIR mapping button to go to the FHIR mapping page.

Azure offers an extensive suite of IoT products to connect and manage your IoT devices. Users can build their own solution based on PaaS using Azure IoT Hub, or start with a manage IoT apps platform with Azure IoT Central. This challenge leverages Azure IoT Central, which has industry-focused solution templates to help get started. Once IoT Central application is deployed, two out-of-the-box simulated devices will start generating telemetry.
 
<center><img src="../images/challenge08-architecture.jpg" width="350"></center>

## Description

You will deploy IoT Connector for FHIR and Setup IoT Device in IoT Central and Connect to FHIR.

- **Deploy Azure IoT Connector for FHIR**
	- Navigate to Azure API for FHIR resource. Click on IoT Connector under the Add-ins section. Click on the Add button to open the Create IoT Connector page. Enter Connector name for the new Azure IoT Connector for FHIR. Choose Create for Resolution Type and click on Create button.
- **Configure Azure IoT Connector for FHIR**. To **upload mapping templates**, click on the newly deployed Azure IoT Connector for FHIR to go to the IoT Connector page.
   * Device mapping template transforms **device data into a normalized schema**. On the IoT Connector page, click on **Configure device mapping** button to go to the Device mapping page. On the Device mapping page, add the following script to the JSON editor and click Save.
      ```json
      {
        "templateType": "CollectionContent",
        "template": [
          {
            "templateType": "IotJsonPathContent",
            "template": {
              "typeName": "heartrate",
              "typeMatchExpression": "$..[?(@Body.HeartRate)]",
              "patientIdExpression": "$.SystemProperties.iothub-connection-device-id",
              "values": [
                {
                  "required": "true",
                  "valueExpression": "$.Body.HeartRate",
                  "valueName": "hr"
                }
              ]
            }
          }
        ]
      }
     ``` 
   * FHIR mapping template **transforms a normalized message to a FHIR-based Observation resource**. On the IoT Connector page, click on **Configure FHIR mapping** button to go to the FHIR mapping page. On the FHIR mapping page, add the following script to the JSON editor and click Save.
      ```json
      {
        "templateType": "CollectionFhir",
        "template": [
          {
            "templateType": "CodeValueFhir",
            "template": {
              "codes": [
                {
                  "code": "8867-4",
                  "system": "http://loinc.org",
                  "display": "Heart rate"
                }
              ],
              "periodInterval": 0,
              "typeName": "heartrate",
              "value": {
                "unit": "count/min",
                "valueName": "hr",
                "valueType": "Quantity"
              }
            }
          }
        ]
      }
     ``` 
- **Generate a connection string for IoT Device**
    - On the IoT Connector page, select **Manage client connections** button. Click on **Add** button. Provide a name and select the **Create** button. Select the newly created connection from the Connections page and copy the value of Primary connection string field from the overlay window on the right.

- **Create App in IoT Central**
    - Navigate to the [Azure IoT Central application manager website](https://apps.azureiotcentral.com/). Select **Build** from the left-hand navigation bar and then click the **Healthcare** tab.
    - Click the **Create app** button and sign in. It will take you to the **New application** page.
    - Change the **Application name** and **URL** or leave as-is. 
    - Check the **Pricing plan** and select free pricing plan or one of the standard pricing plans. 
    - Select **Create** at the bottom of the page to deploy your application.
    - More details on [Continuous Patient Monitoring](https://docs.microsoft.com/en-us/azure/iot-central/healthcare/tutorial-continuous-patient-monitoring#create-an-application-template).
- **Connect your IoT data with the Azure IoT Connector for FHIR**
    - Navigate to IoT Central App created, click on **Data Export (legacy)** under App Settings in the left navigation.
    - Choose **New --> Azure Event Hubs**. Enter a display name for your new export, and make sure the data export is Enabled.
    - Choose **Connection String** in Event Hubs namespace and paste the Connection String copied from above. Event Hub name will autofill.
    - Make sure **Telemetry** is enabled, Devices and Device templates are disabled.
    - More details on [Data Export](https://docs.microsoft.com/en-us/azure/iot-central/core/howto-export-data#set-up-data-export).

- **Validate export and anonymization**
    - Connect to Azure API for FHIR from Postman and check if Device and Observsation resources return data. 

## Success Criteria
- You have successfully configured IoT Connector for FHIR.
- You have successfully configured IoT Central Continuous Patient Monitoring Application.

## Learning Resources

- **[HIPPA Safe Harbor Method](https://www.hhs.gov/hipaa/for-professionals/privacy/special-topics/de-identification/index.html)**
- **[HL7 bulk export](https://hl7.org/Fhir/uv/bulkdata/export/index.html)**
- **[FHIR Tools for Anonymization](https://github.com/microsoft/FHIR-Tools-for-Anonymization)**
