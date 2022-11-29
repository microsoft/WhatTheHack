# Coach's Guide: Challenge 7 - Load DICOM Imaging Data

[< Previous Challenge](./Solution06.md) - **[Home](../README.md)**

## Notes & Guidance

In this challenge, you will deploy, configure and use **[DICOM service](https://docs.microsoft.com/azure/healthcare-apis/dicom/)** in **[Azure Health Data Services](https://docs.microsoft.com/azure/healthcare-apis/healthcare-apis-overview)** to work with medical images.  DICOM service facilitates transmission of imaging data with any DICOMweb™ enabled system or application through standard transactions including Store (STOW-RS), Search (QIDO-RS), and Retrieve (WADO-RS).  It persists imaging data in a *DICOMweb™-compliant server, and injects DICOM metadata into a FHIR server to create a holistic view of patient data.  You can upload PHI (Protected Health Information) data to the HIPAA/HITRUST compliant DICOM service, and the data will remain safely segregated within the compliant boundary in the Azure Health Data Services workspace.

- **Deploy a DICOM service instance within your Azure Health Data Services workspace (deployed in challenge 1).**
    - Go to your `Azure Health Data Service` workspace (deployed in challenge 1)
    - Select `Deploy DICOM service` in `Overview` page
    - Select `+ Add DICOM service` in `DICOM service` page
    - Enter DICOM service name and then select `Review + Create`
- **[Configure Azure roles for access to DICOM data](https://docs.microsoft.com/azure/healthcare-apis/configure-azure-rbac#assign-roles-for-the-dicom-service)**

  Hint: You will need to add the `DICOM Data Owner` role for yourself and the Postman service client (Service Principal created in challenge 1). 

    - Grant user (yourself) and service principal (created in challenge 1) access to the DICOM access plane
        - Go to DICOM service page and select `Access Control (IAM)` blade
        - Select `Role assignment` tab and select `+ Add` in `Access Control (IAM)` page
        - Search and select `DICOM Data Owner` role in the Role selection
        - Search for user (yourself) and service principle (created in challenge 1) to assign the `DICOM Data Owner` role to in the `Select` box
- **Import and configure Postman environment and collection files to connect to DICOM service.**  
  - You can find these Postman template files (`WTHFHIR.Conformance-as-Postman.postman_collection.json` and `WTHFHIR.dicom-service.postman_environment.json`) in the `/Postman` folder of the Resources.zip file provided by your coach. 
  - Import the environment and collection template files into Postman
    - In Postman `Environment` tab, click the `Import` button
    - Add `dicom-service.postman_environment.json` file to Postman using the `Upload Files` button
    - Add `Conformance-as-Postman.postman_collection.json` file to Postman using the `Upload Files` button
  - Configure Postman environment variables specific to your DICOM service instance

    Hint:

    From your existing fhir-service Postman environment:
    - tenantId - AAD tenant ID (you also can find it in AAD -> Overview -> Tenant ID).
    - clientId - Application (client) ID for Postman service client app.
    - clientSecret - Client secret for your Postman app.

    New values you need to input:
    - resource - https://dicom.healthcareapis.azure.com
    - baseUrl - Service URL appended with /v1. Go to Portal -> Resource Group -> DICOM service -> Service URL. Copy and add /v1 on the end: https://<workspace-name>-<dicom-service-name>.dicom.azurehealthcareapis.com/v1

- **Use DICOM service to load imaging files**
  - Obtain access token to connect with your DICOM service
    - Call `POST AuthorizeGetToken` API call in `Conformance-as-Postman` collection to obtian the access token needed to access DICOM data
  - Store DICOM instance with sample DICOM files
    - Select corresponding POST `Store-single-instance (xxx.dcm)` in `Conformance-as-Postman` collection for each sample DICOM files (red-triangle.dcm, green-square.dcm and blue-circle.dcm)
    - Select the appropriate .dcm file (downloaded previously) for each API call in the `Body` tab.
    - For each sample .dcm file, Send appropriate `POST Store-single-instance...` call to populate your DICOM service with the three .dcm single instance files.
  - Call `Search-for-xxx` API calls in `Conformance-as-Postman` collection to Search for DICOM studies
  - Call `Retrieve-xxx` API calls in `Conformance-as-Postman` collection to Retrieve DICOM studies
  - Check logs for changes in DICOM service via Change Feed
    - Call `GET /changefeed` API call to retreive logs of all the changes that occur in DICOM service
    - Call `GET /changefeed/latest` API call to retrieve log of latest changes that ocrrur in DICOM service
  - Call `xxx-extended-query tags` API calls in `Conformance-as-Postman` collection to manage extended query tags in DICOM studies
    - Add extended query tags
    - List extended query tags
    - Get extended query tags
    - Update extended query tags
    - Delete extended query tags



