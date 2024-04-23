# Challenge 8: OMOP Analytics

[< Previous Challenge](./Challenge07.md) - **[Home](../README.md)**

## Introduction

In the Healthcare data solutions (preview), OMOP analytics in the Fabric lakehouse allows for the deployment of the Observational Medical Outcomes Partnership (OMOP) Common Data Model (CDM), giving researchers within the OMOP community access to OneLake’s scale and Microsoft Fabric’s AI. This setup supports standardized analytics for observational studies, enabling researchers to compare procedures and drug exposures and explore drug-condition correlations.

Below is the overview of the **[Healthcare data solutions in Fabric](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/solution-architecture) solution architecture**:
<center><img src="../images/challenge08-architecture.png" width="550"></center>

## Description

In this challenge, you will [deploy](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy) [Healthcare data solutions (preview)](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/overview) to your Fabric workspace to access the Healthcare data foundations capabilities. Configure it to meet OMOP standards, use pre-built pipelines to process data exported from your FHIR service, transform it to OMOP, and implement the OMOP CDM within the Fabric medallion architecture, which consists of the following three core layers:
- Bronze (raw zone): this first layer stores the source data in its original format. The data in this layer is typically append-only and immutable.
- Silver (enriched zone): this layer receives data from the Bronze layer and refines it through validation and enrichment processes, improving its accuracy and value for downstream analytics.
- Gold (curated zone): this final layer, sourced from the Silver layer, refines data to align with specific downstream business and analytical needs.  It’s the primary source for high-quality, aggregated datasets, ready for in-depth analysis and insight extraction.

(Optional) After transforming FHIR data to OMOP standards in the Gold Lakehouse, you can leverage the provided notebooks to build statistical models, perform population distribution studies, and use Power BI reports for visual comparisons of different interventions and their impact on patient health outcomes.

- **Prerequisites:**
  - [Set up data connection using FHIR service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#use-fhir-service)
  - [Set up Azure Lanugage Service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#set-up-azure-language-service)
  - [Deploy the Healthcare data solutions in Microsoft Fabric via Azure Marketplace](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#deploy-azure-marketplace-offer)

- **First, [Deploy Healthcare data foundations](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#deploy-healthcare-data-foundations)** to provide ready-to-run data pipelines designed to efficiently structure data for analytics and AI/machine learning modeling. 

  Hint: After deploying the Healthcare data solutions (preview) to your Fabric workspace, it’s essential to set up the Healthcare data foundations OMOP Analytics capability to align with your FHIR to OMOP data transformation needs.

- **[Configure the global configuration notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#configure-the-global-configuration-notebook) deployed with Healthcare data foundation running the deployed pipelines or notebooks**

- **[Deploy & configure FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure) to bring FHIR data from Azure Health Data Service (AHDS) FHIR service to OneLake.**

**Configure and deploy [msft_raw_bronze_ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_raw_bronze_ingestion) Notebook to ingest data into delta tables in the `msft_bronze` lakehouse**

**Configure and deploy [msft_bronze_silver_flatten](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_bronze_silver_flatten) to flatten FHIR resources in the `msft_bronze` lakehouse and to ingest the resulting data into the healthcare#_msft_silver lakehouse**

- **[Deploy & configure OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure) to prepare data for standardized analytics through Observational Medical Outcomes Partnership (OMOP) open community standards.**
  - [Configure the OMOP silver notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure#configure-the-omop-silver-notebook) to transform resources in the sliver lakehouse into OMOP common data model

## Success Criteria

To complete this challenge successfully, you should be able to:
- Confirm that the raw FHIR data export is stored in the Bronze Datalake’s delta tables
- Verify that the Bronze Lakehouse data has been flattened for standardized analytics through OMOP standards and is stored in the Silver Lakehouse
- Check that the flattened data in the Silver Lakehouse has been transformed into the OMOP Common Data Model (CDM) and is stored in the Gold Lakehouse.

## Learning Resources

- [What is Healthcare data solutions](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/overview)
- [Healthcare data soluton architecture overview](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/solution-architecture)
- [Deploy Healthcare data solutions](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy)
- [Set up data connection using FHIR service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#use-fhir-service)
- [Set up Azure Lanugage Service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#set-up-azure-language-service)
- [Deploy the Healthcare data solutions in Microsoft Fabric via Azure Marketplace](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#deploy-azure-marketplace-offer)
- [Deploy and configure Healthcare data foundation](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure)
- [Configure the global configuration notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#configure-the-global-configuration-notebook)
- [Deploy and configure FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure)
- [Configure the FHIR export service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure#configure-the-fhir-export-service)
- [Configure and deploy msft_raw_bronze_ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_raw_bronze_ingestion)
- [Configure and deploy msft_bronze_silver_flatten](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_bronze_silver_flatten)
- [Overview of OMOP analytics in Healthcare data solutions](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-overview)
- [Deploy and configure OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure)
- [Configure the OMOP silver notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure#configure-the-omop-silver-notebook)

