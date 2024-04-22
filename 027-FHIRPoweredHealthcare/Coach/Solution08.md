# Coach's Guide: Challenge 8 - OMOP Analytics

[< Previous Challenge](./Solution07.md) - **[Home](../README.md)**

## Notes & Guidance

In this challenge, you will deploy deploy the [OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure?toc=%2Findustry%2Fhealthcare%2Ftoc.json&bc=%2Findustry%2Fbreadcrumb%2Ftoc.json#deploy-omop-analytics) capability in [Health Data Solutions in Fabric](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/overview) to your workspace to prepare data for standardized analytics through [Observational Medical Outcomes Partnership (OMOP)](https://www.ohdsi.org/data-standardization/) open community standards.  The [OMOP Common Data Model (CDM)](https://www.ohdsi.org/data-standardization/) is an open community data standard, designed to standardize the structure and content of observational data and to enable efficient analyses that can produce reliable evidence.

- **Prerequites:**
  - **[Deploy and configure Healthcare data foundations](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure)**
    - Open Healthcare data foundations capability on the Healthcare data solutions home page
    - Run 'Deploy to workspace' on the Healthcare data foundation capability page to deploy lakehouse and notebook artifacts to transform FHIR data to OMOP standards.
      - msft_bronze Lakehouse
      - msft_gold_omop Lakehouse
      - msft_silver Lakehouse
      - msft_config_notebook Notebook
      - msft_bronze_silver_flatten Notebook
      - msft_raw_bronze_ingestion Notebook
      - msft_silver_sample_flatten_extensions_utility Notebook
    - [Configure the global configuration notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#configure-the-global-configuration-notebook) deployed with Healthcare data foundation running the deployed pipelines or notebooks.  
      - Use the 'msft_config_notebook' to configure key configuration parameters for all data transformation:
          - Workspace Config
            - workspace_name: Identifier for the workspace, either its GUID or name.
            - solution_name: Identifier for the healthcare workload artifact, formatted as
            - one_lake_endpoint: Identifier for the OneLake endpoint.
          - Lakehouse/Database Config for bronze, silver and OMOP databases
            - bronze_database_name: Bronze lakehouse identifier.
            - silver_database_name: Silver lakehouse identifier.
            - omop_database_name: OMOP or the gold lakehouse identifier.
          - Secrets and Keys Config for the key vault name and the application insights key.
            - kv_name: Specifies the name of the key vault service containing all the necessary secrets and keys for running the Healthcare data solutions (preview) pipelines.
            - Misc Config: Other extra configuration such as whether to skip the package installation or not.
            - Workload Config is set to 'True' tp use the artifact workload folder, and 'False' to use the lakehouse for sample data and transformation configuration.
          - Assign required permission to user(s) of data pipeline
            - Key Vault Secrets User role on the deployed key vault service
            - Contributor role on the Fabric workspace
  - **[Deploy and configure FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure) to bring your Fast Healthcare Interoperability Resources (FHIR) data to OneLake from a Azure Health Data Services FHIR service (deployed in challenge 1)**
    - [Deploy FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure#deploy-fhir-data-ingestion) to your workspace
      - Open 'FHIR data ingestion' capability on the Health Data Solutions home page
      - Run 'Deploy to workspace' on the capability page to provision the 'mfst_fhir_export_service' notebook
      - [Configure the FHIR export service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure#configure-the-fhir-export-service) on the 'FHIR data ingestion' capability management page
        - Before running the 'msft_fhir_export_service' notebook, you must have already [configure the global configuration notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#configure-the-global-configuration-notebook).
        - Configure the 'msft_fhir_export_service' notebook key parameters as follows:
          - spark: Spark session
          - max_polling_days: The maximum number of days to poll the FHIR server for export to complete. The default value is set to three days. The values can range from one day to seven days
          - kv_name: Name of the key vault service. Configure this value in the global configuration notebook
          - function_url_secret_name: Name of the secret in the key vault service that contains the function URL. Configure this value too in the global configuration notebook
    - Run the 'msft_fhir_export_service' notebook to export FHIR data to a container named 'export-landing-zone' in the Azure Storage account
    - Create a shortcut of this folder in your storage account in the bronze lakehouse
      - For example:
        source_path_pattern = 'abfss://<workspace_name>@onelake.dfs.fabric.microsoft.com/{bronze_lakehouse_name}.Lakehouse/Files/FHIRData/**/<resource_name>[^a-zA-Z]*ndjson'

- **Configure and deploy [msft_raw_bronze_ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_raw_bronze_ingestion) Notebook to ingest data into delta tables in the 'msft_bronze' lakehouse**
  - Configure key parameters:
    - max_files_per_trigger: Maximum number of new files to consider for every trigger. The data type of the value is integer
    - source_path_pattern: The pattern to use for monitoring source folders. The data type of the value is variable
      - Default value: The landing zone paths under abfss://{workspace_name}@{one_lake_endpoint}/{bronze_database_name}/Files/landing_zone/**/**/**/<resource_name>[^a-zA-Z]*ndjson
  - Run 'msft_raw_bronze_ingestion' Notebook that calls the  BronzeIngestionService module in Healthcare data solutions library to ingest the FHIR data stored in location defined by 'source_path_pattern' value

- **Configure and deploy [msft_bronze_silver_flatten](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_bronze_silver_flatten) to flatten FHIR resources in the 'msft_bronze' lakehouse and to ingest the resulting data into the healthcare#_msft_silver lakehouse**
  - Run 'msft_bronze_silver_flatten' Notebook that calls the  SilverIngestionService module in Healthcare data solutions library to flatten FHIR resources in the 'msft_bronze' lakehouse and to ingest the resulting data into the 'msft_silver' lakehouse

- **[Deploy and configure OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure) capability in Healthcare data solutions to enables data preparation for standardized analytics through Observational Medical Outcomes Partnership (OMOP) open community standards**
  - [Deploy OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure?toc=%2Findustry%2Fhealthcare%2Ftoc.json&amp%3Bbc=%2Findustry%2Fbreadcrumb%2Ftoc.json#deploy-omop-analytics) to your workspace
    - Open the OMOP analytics capability on the Health Data Solutions home page
    - Run 'Deploy to workspace' on the OMOP Analytics Capabilities page to deploy OMOP's common data model to Farbric using pre-built pipelines to hydrate OMOP using the Healthcare foundations and OMOP analytics capabilities
      - Artifacts deployed:
        - msft_silver_omop Notebook
        - msft_omop_sample_drug_exposure_era Notebook
        - msft_omop_sample_drug_exposure_insights Notebook
  
  - [Configure the OMOP silver notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure?toc=%2Findustry%2Fhealthcare%2Ftoc.json&amp%3Bbc=%2Findustry%2Fbreadcrumb%2Ftoc.json#configure-the-omop-silver-notebook) to transforms resources in the 'msft_silver' lakehouse into OMOP common data model (CDM)
    - Configure key parameters:
      - 'silver_database_name' in the 'msft_config' notebook defines the silver lakehouse identifier. 
      - 'omop_database_name' in the 'msft_config' notebook defines the OMOP lakehouse the transformed data is persisted
  - Run 'msft_silver_omop' notebook job to transform resources in the 'msft_silver' lakehouse into OMOP common data model and persist the transformed data into the OMOP lakehouse





