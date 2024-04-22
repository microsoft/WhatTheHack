# Challenge 8: OMOP Analytics

[< Previous Challenge](./Challenge07.md) - **[Home](../README.md)**

## Introduction

In Healthcare data solutions (preview), the OMOP analytics capability facilitates the deployment of the Observational Medical Outcomes Partnership (OMOP) common data model (CDM) in the Fabric lakehouse environment. This deployment provides researchers within the OMOP community access to OneLake's expansive scale and the AI capabilities of the Fabric platform. The setup enables efficient and reliable execution of standardized analytics for patient and population-level observational studies.  The OMOP analytical capabilities empower researchers to perform comparative analyses, such as evaluating different procedures and drug exposures, or examining correlations between drug exposures and condition occurrences.

Below is the overview of the **[Healthcare data solution architecture](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/solution-architecture)**:
<center><img src="../images/challenge08-architecture.png" width="550"></center>

## Description

In this challenge, you will [deploy](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy) your [Healthcare data solutions (preview)](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/overview) to the Fabric workspace and unlock the Healthcare data foundations capability. Once deployed, you can configure the system to align with the Observational Medical Outcomes Partnership (OMOP) community standards.  You'll use prebuilt pipelines to extract and flatten the data from your FHIR service (deployed in challenge 1), transform the prepared data to OMOP and deploy the OMOP CDM to the Fabric medallion architecture.  It comprises of three fundamental layers:
- Bronze (raw zone): this first layer stores the source data in its original format. The data in this layer is typically append-only and immutable.
- Silver (enriched zone): this layer stores data sourced from the bronze layer. Here, data undergoes refinement processes, including validation checks and enrichment techniques, to enhance its accuracy and utility for downstream analytics.
- Gold (curated zone): this final layer stores data sourced from the silver layer. The data is refined to meet specific downstream business and analytics requirements. This layer serves as the primary source for high-quality, aggregated data sets ready for comprehensive analysis and insights extraction.

(Optional) Once the FHIR data is transformed into OMOP standards persisted in the Gold Lakehouse you can utilize the provided notebooks to construct statistical models, conduct population distribution studies and utilize Power BI reports to visually compare various interventions and their effects on patient outcomes.

- **Prerequisites:**
  - [Set up data connection using FHIR service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#use-fhir-service)
  - [Set up Azure Lanugage Service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#set-up-azure-language-service)
  - [Deploy the Healthcare data solutions in Microsoft Fabric via Azure Marketplace](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#deploy-azure-marketplace-offer)

- **First, [Deploy Healthcare data foundations](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#deploy-healthcare-data-foundations)** to provide ready-to-run data pipelines designed to efficiently structure data for analytics and AI/machine learning modeling. 

  Hint: You need to deploy and configure the Healthcare data foundations capability after deploying Healthcare data solutions (preview) to your Fabric workspace.

- **[Configure the global configuration notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#configure-the-global-configuration-notebook) deployed with Healthcare data foundation running the deployed pipelines or notebooks**

- **[Deploy & configure FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure) to bring FHIR data from Azure Health Data Service (AHDS) FHIR service to OneLake.**

**Configure and deploy [msft_raw_bronze_ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_raw_bronze_ingestion) Notebook to ingest data into delta tables in the 'msft_bronze' lakehouse**

**Configure and deploy [msft_bronze_silver_flatten](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_bronze_silver_flatten) to flatten FHIR resources in the 'msft_bronze' lakehouse and to ingest the resulting data into the healthcare#_msft_silver lakehouse**

- **[Deploy & configure OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure) to prepare data for standardized analytics through Observational Medical Outcomes Partnership (OMOP) open community standards.**
  - [Configure the OMOP silver notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure#configure-the-omop-silver-notebook) to transform resources in the sliver lakehouse into OMOP common data model

You can find a sample \`thingamajig.config\` file in the \`/Challenge08\` folder of the Resources.zip file provided by your coach. This is a good starting reference, but you will need to discover how to set exact settings.

## Success Criteria

To complete this challenge successfully, you should be able to:
- Verify that the Healthcare data solution foundation is deployed and configured
- Verify that the data connection is set up using FHIR service
- Verify that the FHIR export service extracted data in FHIR service to a container named 'export-landing-zone' in your Azure Storage 
- Verity that the exported raw FHIR data is persisted in the delta tables in the Bronze Datalake
- Verified that data in the Bronze Lakehouse has been flatten in preparation for standardized analytics through Observational Medical Outcomes Partnership (OMOP) standards and persisted in Siver Lakehouse
- Verify that the OMOP analytics is deployed and configured
- Verify that the prepared flatten data in Silver Lakehouse is tranformed into OMOP Common Data Model (CDM) and persisted in the Gold Lakehouse

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

