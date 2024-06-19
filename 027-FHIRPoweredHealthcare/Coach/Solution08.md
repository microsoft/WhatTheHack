# Coach's Guide: Challenge 8 - OMOP Analytics

[< Previous Challenge](./Solution07.md) - **[Home](./README.md)**

## Notes & Guidance

In this challenge, you will [deploy Healthcare data solutions](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy) to your Fabric workspace to access the Healthcare data foundations and OMOP analytics capabilities. Configure them to meet Observational Medical Outcomes Partnership (OMOP) standards, use pre-built pipelines to process data exported from your Fast Healthcare Interoperability Resources (FHIR) service, transform it to OMOP, and implement the OMOP Common Data Model (CDM) within the Fabric medallion architecture, which consists of the following three core layers:
- `Bronze` (raw zone): this first layer stores the source data in its original format. The data in this layer is typically append-only and immutable.
- `Silver` (enriched zone): this layer receives data from the Bronze layer and refines it through validation and enrichment processes, improving its accuracy and value for downstream analytics.
- `Gold` (curated zone): this final layer, sourced from the Silver layer, refines data to align with specific downstream business and analytical needs.  It’s the primary source for high-quality, aggregated datasets, ready for in-depth analysis and insight extraction.

**Prerequisites:**

- **[Deploy the Healthcare data solutions in Microsoft Fabric](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#use-fhir-service)** and set up data connection to use FHIR service (deployed in challenge 1)
  - [Set up Azure Language service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy?toc=%2Findustry%2Fhealthcare%2Ftoc.json&bc=%2Findustry%2Fbreadcrumb%2Ftoc.json#set-up-azure-language-service)
    - Create a new Azure Language service to your Resource Group in Azure portal using default settings to build apps with natural language understanding capabilities
  - [Deploy Healthcare data solutions in Microsoft Fabric](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy?toc=%2Findustry%2Fhealthcare%2Ftoc.json&bc=%2Findustry%2Fbreadcrumb%2Ftoc.json#deploy-azure-marketplace-offer) Azure Marketplace offer to enable Lakehouse Analytics for Healthcare
    - Configure key parameters:
      - `Resource group`: Select your resource group
      - `Language service`: Select the language service previously created in your resource group
      - `Fhir Server Uri`: Optional parameter to be provided only if you're ingesting data from the Azure FHIR service. Enter your FHIR server's URI value here
      - `Export Start Time`: Specify your preferred start time to initiate bulk data ingestion from your FHIR service to the lake
    - Deployed Azure resources:
      - `Application Insights Smart Detection` (Action Group)
      - `Failure Anomalies` (Smart detection alert rule)
      - `msft-api-datamanager` (Application Insights)
      - `msft-asp-datamanager` (App Service Plan)
      - `msft-ds-delayDeployment` (Deployment Script)
      - `msft-funct-datamanager-export` (Function App)
      - `msft-kv` (Key Vault)
      - `msft-log datamanager` (Log Analytics workspace)
      - `msftst` (Storage Account)
      - `msftstexport` (Storage Account)
    - Update FHIR server configuration:
      - Update the FHIR service to have a system assigned managed identity
      - Update the FHIR service's export Azure storage account name to point to the Healthcare data solution's storage account 
      - On the Healthcare data solution's storage account, assign the Azure RBAC role Storage blob data contributor to the FHIR service to enable the FHIR service to read and write to the storage account.
      - On the FHIR service, assign the Azure `RBAC` role `FHIR Data Exporter` to the function app to enable the function app to execute the FHIR `$export` API.
      - Update the FHIR Service Uri and Export Start Time app settings on the export function app

- **[Deploy and configure Healthcare data foundations](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure)**
  - Open `Healthcare data foundations` capability on the Healthcare data solutions home page
  - Run `Deploy to workspace` on the Healthcare data foundation capability page to deploy Lakehouse and `Notebook` artifacts to transform FHIR data to OMOP standards.
    - `msft_bronze Lakehouse`
    - `msft_gold_omop Lakehouse`
    - `msft_silver Lakehouse`
    - `msft_config_notebook Notebook`
    - `msft_bronze_silver_flatten Notebook`
    - `msft_raw_bronze_ingestion Notebook`
    - `msft_silver_sample_flatten_extensions_utility Notebook`
  - [Configure the global configuration notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#configure-the-global-configuration-notebook) deployed with Healthcare data foundation running the deployed pipelines or notebooks  
    - Use the `msft_config_notebook` to configure key configuration parameters for all data transformation:
        - Workspace Configuration
          - `workspace_name`: Identifier for the workspace, either its GUID or name.
          - `solution_name`: Identifier for the healthcare workload artifact, formatted as
          - `one_lake_endpoint`: Identifier for the OneLake endpoint.
        - `Lakehouse/Database` Configuration for bronze, silver and OMOP databases
          - `bronze_database_name`: `Bronze Lakehouse` identifier.
          - `silver_database_name`: `Silver Lakehouse` identifier.
          - `omop_database_name`: OMOP or the Gold Lakehouse identifier.
        - Secrets and Keys Configuration for the key vault name and the application insights key.
          - `kv_name`: Specifies the name of the key vault service containing all the necessary secrets and keys for running the Healthcare data solutions pipelines.
          - `Misc Config`: Other extra configuration such as whether to skip the package installation or not.
          - `Workload Config`: Set to `True` to use the artifact workload folder, and `False` to use the Lakehouse for sample data and transformation configuration.
        - Assign required permission to user(s) of data pipeline
          - `Key Vault Secrets User` role on the deployed key vault service
          - `Contributor` role on the Fabric workspace
  
- **[Deploy and configure FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure)** to bring your FHIR data to Microsoft Fabric `OneLake` from a your FHIR service (deployed in challenge 1)
  - [Deploy FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure#deploy-fhir-data-ingestion) to your workspace
    - Open `FHIR data ingestion` capability on the Health Data Solutions home page
    - Run `Deploy to workspace` on the capability page to provision the `mfst_fhir_export_service` notebook
    - [Configure the `FHIR export service`](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure#configure-the-fhir-export-service) on the FHIR data ingestion capability management page
      - Before running the `msft_fhir_export_service` Notebook (above), you must have already [configure the global configuration Notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#configure-the-global-configuration-notebook)
      - Configure the `msft_fhir_export_service` Notebook key parameters as follows:
        - `spark`: Spark session
        - `max_polling_days`: The maximum number of days to poll the FHIR server for export to complete. The default value is set to three days. The values can range from one day to seven days
        - `kv_name`: Name of the key vault service. Configure this value in the global configuration notebook
        - `function_url_secret_name`: Name of the secret in the key vault service that contains the function URL. Configure this value too in the global configuration notebook

- **[Deploy and configure OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure)** capability in Healthcare data solutions to enables data preparation for standardized analytics through OMOP open community standards
  - [Deploy OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure#deploy-omop-analytics) to your workspace
    - Open the `OMOP analytics` capability on the Healthcare Data Solutions home page
    - Run `Deploy to workspace` on the OMOP Analytics Capabilities page to deploy OMOP's Common Data Model to Microsoft Fabric using pre-built pipelines to hydrate OMOP using the Healthcare foundations and OMOP analytics capabilities
      - Artifacts deployed:
        - `msft_silver_omop` Notebook
        - `msft_omop_sample_drug_exposure_era` Notebook
        - `msft_omop_sample_drug_exposure_insights` Notebook

**First, [run FHIR ingestion pipeline using FHIR service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure#use-fhir-service)** to export your FHIR data (deployed in challenge 1) and store the raw JSON in the lake
  - Run the `msft_fhir_export_service` Notebook to export FHIR data to a container named `export-landing-zone` in the Azure Storage account
  - Create a shortcut of this folder in your storage account in the Bronze Lakehouse
    - For example:
        `source_path_pattern = abfss://<workspace_name>@onelake.dfs.fabric.microsoft.com/{bronze_lakehouse_name}.Lakehouse/Files/FHIRData/**/<resource_name>[^a-zA-Z]*ndjson`

**[Configure and run `msft_raw_bronze_ingestion`](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_raw_bronze_ingestion)** Notebook to ingest data into delta tables in the Bronze (`msft_bronze`) Lakehouse
  - Configure key parameters:
    - `max_files_per_trigger`: Maximum number of new files to consider for every trigger. The data type of the value is integer
    - `source_path_pattern`: The pattern to use for monitoring source folders. The data type of the value is variable
      - Default value: The landing zone paths under `abfss://{workspace_name}@{one_lake_endpoint}/{bronze_database_name}/Files/landing_zone/**/**/**/<resource_name>[^a-zA-Z]*ndjson`
  - Run `msft_raw_bronze_ingestion` Notebook that calls the  `BronzeIngestionService` module in Healthcare data solutions library to ingest the FHIR data stored in location defined by `source_path_pattern` value

**[Configure and run `msft_bronze_silver_flatten`](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#healthcare_msft_bronze_silver_flatten)** Notebook to flatten FHIR resources in the Bronze (`msft_bronze`) Lakehouse and to ingest the resulting data into the Silver (`msft_silver`) Lakehouse
  - Run `msft_bronze_silver_flatten` Notebook that calls the  `SilverIngestionService` module in Healthcare data solutions library to flatten FHIR resources in the Bronze (`msft_bronze`) Lakehouse and to ingest the resulting data into the Silver (`msft_silver`) Lakehouse
 
**[Configure and run `msft_silver_omop`](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure?toc=%2Findustry%2Fhealthcare%2Ftoc.json&amp%3Bbc=%2Findustry%2Fbreadcrumb%2Ftoc.json#configure-the-omop-silver-notebook)** Notebook to transforms resources in the Silver (`msft_silver`) Lakehouse into OMOP Common Data Model (CDM)
  - Configure key parameters:
    - `silver_database_name` in the `msft_config` notebook defines the Silver Lakehouse identifier. 
    - `omop_database_name` in the `msft_config` notebook defines the OMOP Gold (`msft_gold_omop`) Lakehouse the transformed data is persisted
  - Run `msft_silver_omop` Notebook job to transform resources in the Silver (`msft_silver`) Lakehouse into OMOP CDM and persist the transformed data into the OMOP Gold (`msft_gold_omop`) Lakehouse 





