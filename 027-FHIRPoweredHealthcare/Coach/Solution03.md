# Coach's Guide: Challenge 3 - Extract, transform and load C-CDA synthetic medical data

[< Previous Challenge](./Solution02.md) - **[Home](./readme.md)** - [Next Challenge>](./Solution04.md)

## Notes & Guidance

In this challenge, you will use the **[FHIR Converter](https://github.com/microsoft/FHIR-Converter)** reference architecture in **[Microsoft Health Architectures](https://github.com/microsoft/health-architectures)**, deployed in **[challenge 2](./Solution02.md)**, to ingest, transform, and load clinical healthcare data into FHIR Server.  You will generate synthetic patient clinical data (C-CDA), convert them into FHIR Bundle and ingest them into FHIR Server.  To generate synthetic patient data, you will use **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** open source Java tool to simulate patient clinical data in HL7 C-CDA format. 

**Clinical data ingest and convert Scenario**

In this scenario, you will develop a logic app based workflow to perform the C-CDA-to-FHIR conversion using **[FHIR Converter API](https://github.com/microsoft/FHIR-Converter/blob/master/docs/api-summary.md)** and import the resulting FHIR Bundle into FHIR Server.

**Deploy **[Microsoft Health Architectures](https://github.com/microsoft/health-architectures)** samples for C-CDA-to-FHIR ingest and convert scenarios**

- Use **[HL7toFHIR converion](https://github.com/microsoft/health-architectures/tree/master/HL7Conversion#hl7tofhir-conversion)** pipeline infrastructure (deployed in **[challenge 2](./Solution02.md)**) to expose the C-CDA Conversion service endpoint: 

   `https://<SERVICE_NAME>.azurewebsites.net/api/convert/cda/ccd.hbs`

- Deploy a new logic app based workflow to perform the C-CDA-to-FHIR conversion and import the resulting FHIR bundle into FHIR Server.  Your BLOB triggered logic app needs to perform the following steps in the workflow:
    - Step 1: Trigger workflow when a BLOB is added or modified in `cda` container
    - Step 2: Get BLOB content from C-CDA XML file in `cda` BLOB container.
    - Step 3: Compose BLOB content as Input object.
    - Step 4: HTTP - Call FHIR Converter API
        - Method: POST
        - URI: `https://<fhirhl7conv_SERVICE_NAME>.azurewebsites.net/api/convert/cda/ccd.hbs`
        - Body: Compose object output (file content)
    - Step 5: Import Response Body (FHIR bundle) to FHIR Server 
        - Connected to FHIR Server through **[FHIR Server Proxy](https://github.com/microsoft/health-architectures/blob/master/FHIR/FHIRProxy/readme.md)**
        - Set message object to retuned FHIR resource

**Generate patient clinical data using **[SyntheaTM Patient Generator](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** tool**

**[SyntheaTM](https://github.com/synthetichealth/synthea#syntheatm-patient-generator)** is a Synthetic Patient Population Simulator. The goal is to output synthetic, realistic (but not real), patient data and associated health records in a variety of formats.  Read **[Synthea wiki](https://github.com/synthetichealth/synthea/wiki)** for more information.
- **[Developer Quick Start](https://github.com/synthetichealth/synthea#developer-quick-start)**
    - **[Installation](https://github.com/synthetichealth/synthea#installation)**
        - System Requirements: SyntheaTM requires Java 1.8 or above.
        - Clone the SyntheaTM repo, then build and run the test suite:
            ```bash
            $ git clone https://github.com/synthetichealth/synthea.git
            $ cd synthea
            $ ./gradlew build check test
            ```
        Note: This step may have been done in **[Challenge 1](./Solution01.md)**.

    - Update the **[default properties](https://github.com/synthetichealth/synthea#changing-the-default-properties)** for CDA output
        ```propoerties
        exporter.baseDirectory = ./output/cda
        ...
        exporter.ccda.export = true
        exporter.fhir.export = false
        ...
        # the number of patients to generate, by default
        # this can be overridden by passing a different value to the Generator constructor
        generate.default_population = 1000
        ```
        
        **Note:** The default properties file values can be found at src/main/resources/synthea.properties. By default, synthea does not generate CCDA, CPCDA, CSV, or Bulk FHIR (ndjson). You'll need to adjust this file to activate these features. See the **[wiki](https://github.com/synthetichealth/synthea/wiki)** for more details.
    - Generate Synthetic Patients
        Generating the population 1000 at a time...
        ```bash
        ./run_synthea -p 1000
        ```
    - For this configuration, Synthea will output 1000 patient records in FHIR formats in `./output/cda` folder.

**Bulk Load Synthea generated patient FHIR Bundles to FHIR Server**
- Copy the Synthea generated C-CDA patient data (XML) in `./output/cda` folder to `cda` BLOB container in `{ENVIRONMENTNAME}store` Storage Account created for FHIR Converter.  This will automatically trigger the new logic app C-CDA to FHIR conversion workflow created above to convert and persist resulted FHIR bundle into FHIR Server. 
    - To Copy data to Azure Storage using **[AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)** commandline tool
        - **[Download AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-azcopy)**
        - **[Run AzCopy](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#run-azcopy)**
        - Add directory location of AzCopy executable to your system path
        - Type `azcopy` or `./azcopy` in Windows PowerShell command prompts to get started
        - Use a SAS token to copy Synthea generated patient clinical data XML file(s) to hl7ingest Azure Blob storage
            - Sample AzCopy command:
               ```bash
               azcopy copy "<your Synthea ./output/cda directory>" "<hl7ingest blob container URL appended with SAS token>"
               ```
    - Alternatively, copy data to Azure Storage using **[Azure Storage Explorer](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-quickstart-blobs-storage-explorer#upload-blobs-to-the-container)** user interface
        - Navigate to Storage Account blade in Azure Portal, expand BLOB CONTAINERS and click on `cda` to list container content
        - Click `Upload`, and in `Upload blob` window, browse to Synthea `./result/cda` folder and select C-CDA XML files to upload
    - Monitor Log Stream in function app `cdafhirconvert.BlobTrigger1`
        - Verify in log that `FhirBundleBlobTrigger` function auto runs when new blob detected
            Sample log output:
            ```bash
            Executing 'hl7ingestBlobTrigger' (Reason='New blob detected...)...
            ...
            Uploaded /...
            ...
            Executed 'hl7ingestBlobTrigger' (Succeeded, ...)
            ```
**Use Postman to retrieve Patients clinical data via FHIR Patients API**
- Open Postman and import Postman collection and environment variables for FHIR API (if you have not imported them).
- Run FHIR API HTTP Requests to validate imported clinical data.

**Note:** See **[challenge 1 solution file](./Solution01.md)** for detailed guide on using Postman to access FHIR Server APIs.




