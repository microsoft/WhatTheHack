# Challenge 07 - Unified Data Governance - Coach's Guide 

[< Previous Solution](./Solution-06.md) - **[Home](./README.md)**

## Notes & Guidance

**Environment setup:**

**Microsoft purview account:** Create Microsoft purview account in same subscription, region and resource group as other previously deployed resources. Make sure, students don't provision Azure purview account. Teach them about purview rebranding message from Microsoft (azure purview to Microsoft purview, see documentation blog link in Tips section)

Note: If students haven't gone through previous challenges and wanted to execute purview as independent challenge, then they can bring and register their own data sources (Dedicated SQL pool, SQL database, ADLS Gen2 etc..)

Recommended approach is, break down students in groups and have few of them register the ADLS gen2 and few register the SQL database, so as a group they get learning on both type of data sources.

**Create Purview collection in data map:** Purview provisions the root collection by default with the same name as purview account. Student should create child collection (with appropriate naming like WideWorldimporters) and register all of data sources under Parent(root) -\> child collection.

**Registering data sources:**

**ADLS Gen2:** Choose data lake storage account and appropriate collection (root -\> child) for registration. Please Do not enable Data Use management. (Data use management is out of scope for this hack)

**SQL dedicated pool:** Choose Azure dedicated SQL pool (formerly SQL DW) as resource and root -\> child collection for registration.

**SQL database:** For Azure SQL DB connection turn off Lineage Extraction Preview to work correctly.

**Scan data sources:**

**ADLS Gen 2:** Configure managed identify for scanning. Choose managed identity and root \> child collection.

If test connection is failing, then there could be some issues with permission setup.

Scope your scan – select all the containers/folders for scanning.

Scan Rule set: Use system default scan rule set (ADLSGen2)

Set a scan trigger: Use once as frequency and choose save and run.

**SQL Dedicated pool:** Add yourself as the Owner in the IAM of the SQL Dedicated Pool. Scanning SQL dedicated pool supports various authentication mechanisms but choose SQL Authentication to simplify lab setup. Setup azure key vault to store SQL database credentials. Select root -\> child collection.

Setup azure key vault: Setup access policies (grant secret permissions to Purview account). Store SQL dedicated pool password as secret.

Microsoft purview credential setup: Step 1) Associate azure key vault in purview account, add azure key vault in Microsoft purview credential using Manage key vault connections. Step 2) Create new credential using SQL authentication, SQL dedicated pool username and use azure key vault connection to supply the password.

If SQL test connection is failing, then there could be some issues with key vault setup, credential or dedicated pool is paused and not running etc...

Scope your scan – select all fact, dimension and integration schemas including all tables for scanning.

Scan Rule set: Use system default scan rule set (AzureSqlDataWarehouse)

Set a scan trigger: Use once as frequency and choose save and run.

**Creating custom classification:** Create a custom classification and classification rule.

Setting up classification rule: Select type as "Regular expression". Upload the provided csv file to create patterns. Select a data pattern and column pattern (WWI Employee ID). Also test classification rule with the provided csv file. Have students discuss the significance of Minimum match threshold percentage.

Re-Configure the SQL dedicated pool scan: Earlier SQL dedicated pool has been scanned using system default classification, but have student re-scan using this custom created classification using scanning feature. Once the re-scanning is done, student can verify the custom classification applied at table/column level using catalog search and advanced filter classification feature.

While re-scanning, create scan rule set before re-scanning to make use of custom classification rule.

**ADF integration with Purview:**

Step 1: Go to ADF and turn on managed identity.

Step 2: Go to purview account and add ADF workspace in data curator role. If managed identity is not "ON" on ADF side, then ADF workspace will not appear in purview account as principal.
