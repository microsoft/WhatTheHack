# Challenge 7: Ingest, search & retrieve DICOM imaging data

[< Previous Challenge](./Challenge06.md) - **[Home](../readme.md)**

## Introduction

In this challenge, you will deploy, configure and use **[DICOM service](https://docs.microsoft.com/azure/healthcare-apis/dicom/)** in **[Azure Health Data Services](https://docs.microsoft.com/azure/healthcare-apis/healthcare-apis-overview)** to work with medical images.  DICOM service facilitates transmission of imaging data with any DICOMweb™ enabled system or application through standard transactions including Store (STOW-RS), Search (QIDO-RS), and Retrieve (WADO-RS).  It persists imaging data in a *DICOMweb™-compliant server, and injects DICOM metadata into a FHIR server to create a holistic view of patient data.  You can upload PHI (Protected Health Information) data to the HIPAA and HITRUST compliant DICOM service, and the data will remain safely segregated within the compliant boundary in the Azure Health Data Services workspace.

Below is the overview of the **[DICOMcast synchronization pipeline](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-cast-overview)**:
<center><img src="../images/challenge07-architecture.png" width="550"></center>

## Description

You will deploy an instance of DICOM service in your Azure Health Data Service workspace, and configure it to ingest DICOM files for persitence in your DICOM service.  Its DICOMcast pipeline will synchronize image metadata to FHIR service (deployed in challenge 1) that will enable healthcare organizations to integrate clinical and imaging data.  DICOMcast expands the heath data use cases by supporting a longitudinal patient data and creating cohorts for medical studies, analytics, and machine learning.

- **Deploy a DICOM service instance within your Azure Health Data Services workspace (deployed in challenge 1).**

- **[Configure Azure roles for access to DICOM data](https://docs.microsoft.com/azure/healthcare-apis/configure-azure-rbac#assign-roles-for-the-dicom-service)**
  Hint: You will need to add the `DICOM Data Owner` role for yourself (i.e., your username in Azure) and the Postman service client (Service Principal created in challenge 1). (documentation available here).
- **Import and configure Postman environment and collection files to connect to DICOM service.**
- **Use DICOM service to load imaging files**
- **Store DICOM instance with sample DICOM files**
- **Search for DICOM instance**
- **Retrieve DICOM instance**
- **Check logs for changes in DICOM service via Change Feed**
- **Manage extended query tags in your DICOM service instance**
  - Add extended query tags
  - List extended query tags
  - Get extended query tags
  - Update extended query tags
  - Delete extended query tags

## Success Criteria
- You have successfully provision and configure DICOM service for ingestion and storage of DICOM studies
- You have successfully use DICOM service to upload, search, and retrieve DICOM studies
- You have successfully check log (Change Feed)
- You have successfully add/remove additional query tags.


## Learning Resources

- **[What is the DICOM service?](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-services-overview)**
- **[DICOMcast architecture overview](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-cast-overview)**
- **[DICOM Change Feed Overview](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-change-feed-overview)**
- **[DICOM Extended Query Tag Overview](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-extended-query-tags-overview)**
- **[Using DICOMweb™Standard APIs with DICOM services](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicomweb-standard-apis-with-dicom-services)**
- **[HDICOM Conformance Statement-DICOMweb™ Standard Service Documentation](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-services-conformance-statement)**
- **[Pull DICOM changes using the Change Feed](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/pull-dicom-changes-from-change-feed)**
- **[Obtain and use an access token for the DICOM service](https://learn.microsoft.com/en-us/azure/healthcare-apis/get-access-token?tabs=azure-cli#obtain-and-use-an-access-token-for-the-dicom-service)**
- **[Get started with the DICOM service](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/get-started-with-dicom)**
- **[Deploy DICOM service using the Azure portal](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/deploy-dicom-services-in-azure)**
- **[Configure Azure RBAC for the DICOM service](https://learn.microsoft.com/en-us/azure/healthcare-apis/configure-azure-rbac#assign-roles-for-the-dicom-service)**
- **[Register a client application for the DICOM service in Azure Active Directory](https://learn.microsoft.com/en-us/azure/healthcare-apis/dicom/dicom-register-application)**
- **[OSS DICOM Server: Medical Imaging Server for DICOM](https://github.com/microsoft/dicom-server)**