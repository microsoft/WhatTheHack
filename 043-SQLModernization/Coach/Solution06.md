# Challenge 6: Data Governance - Coach's Guide

[< Previous Challenge](./Solution05.md) - **[Home](README.md)** 

**[Create an Azure Purview Account](#create-an-azure-purview-account)**
1. [Create an Azure Purview Account](#1-create-an-azure-purview-account)
2. [Grant Access to Azure Purview's Data Plane](#2-grant-access-to-azure-purviews-data-plane)
3. [Open Purview Studio](#3-open-purview-studio)

**[Register & Scan](#register--scan)**
1. [Create an Azure SQL Database](#1-create-an-azure-sql-database)
2. [Create an Azure Key Vault](#2-create-an-azure-key-vault)
3. [Add Credentials to Azure Purview](#3-add-credentials-to-azure-purview)
4. [Register a Source](#4-register-a-source)
5. [Scan a Source with Azure Key Vault Credentials](#5-scan-a-source-with-azure-key-vault-credentials)
6. [View Assets](#6-view-assets)

**[Search & Enrich](#search--enrich)**
1. [Search Catalog](#1-search-catalog)
2. [Update an Asset](#2-update-an-asset)

## Notes & Guidance

This challenge focuses on registering and scanning data source(s) using Azure Purview to automatically catalog and classify data assets that exist within the fictional data estate. The challenge involves step by step approach on provisioning an Azure Purview account instance, user management via role-based access controls, onboarding data sources, and enrichment via Azure Purview Studio.

### Environment Setup

The challenge environment setup requires that participants have pre-provisioned at least one supported Azure Purview data source with sample data. A quick and effective option includes Azure SQL Database ([serverless tier](https://docs.microsoft.com/en-us/azure/azure-sql/database/serverless-tier-overview)) with **Sample** data which will include the AdventureWorksLT sample database.

![Sample DB](./images/azpurviewsampledb.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

### Create an Azure Purview Account
  **Note:** Before proceeding, ensure your Azure subscription has the following resource providers registered: **Microsoft.Purview**, **Microsoft.Storage**, and **Microsoft.EventHub**.

#### 1. Create an Azure Purview Account

1. Sign in to the [Azure portal](https://portal.azure.com) with your Azure account and from the **Home** screen, click **Create a resource**.

    ![Create a Resource](./images/azpurview01.01-create-resource.png)  

2. Search the Marketplace for "Azure Purview" and click **Create**.

    ![Create Purview Resource](./images/azpurview01.02-create-purview.png)

3. Provide the necessary inputs on the **Basics** tab.  

    **NOTE**: The table below provides example values for illustrative purposes only, ensure to specify values that make sense for your deployment.

    | Parameter  | Example Value |
    | --- | --- |
    | Subscription | `Azure Internal Access` |
    | Resource group | `purviewlab` |
    | Purview account name | `purview-69426` |
    | Location | `Brazil South` |

    ![Purview Account Basics](./images/azpurview01.03-create-basic.png)

4. Provide the necessary inputs on the **Configuration** tab.

    | Parameter  | Example Value | Note |
    | --- | --- | --- |
    | Platform size | `4 capacity units` | Sufficient for non-production scenarios. |

    :bulb: **Did you know?**
    
    **Capacity Units** determine the size of the platform and is a **provisioned** (fixed) set of resources that is needed to keep the Azure Purview platform up and running. 1 Capacity Unit is able to support approximately 1 API call per second. Capacity Units are required regardless of whether you plan to invoke the Azure Purview API endpoints directly (i.e. ISV scenario) or indirectly via Purview Studio (GUI).
    
    **vCore Hours** on the other hand is the unit used to measure **serverless** compute that is needed to run a scan. You only pay per vCore Hour of scanning that you consume (rounded up to the nearest minute).
    
    For more information, check out the [Azure Purview Pricing](https://azure.microsoft.com/en-us/pricing/details/azure-purview/) page.

    ![Configure Purview Account](./images/azpurview01.04-create-configuration.png)

5. On the **Review + Create** tab, once the message in the ribbon returns "Validation passed", verify your selections and click **Create**.

    ![Create Purview Account](./images/azpurview01.05-create-create.png)

6. Wait several minutes while your deployment is in progress. Once complete, click **Go to resource**.

    ![Go to resource](./images/azpurview01.06-goto-resource.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

#### 2. Grant Access to Azure Purview's Data Plane

1. Navigate to your Azure Purview account and select **Access Control (IAM)** from the left navigation menu.

    ![Access Control](./images/azpurview01.08-purview-access.png)

2. Click **Add role assignments**.

    ![Add Role Assignment](./images/azpurview01.09-access-add.png)

3. Populate the role assignment prompt as per the table below, select the targeted Azure AD identities, click **Save**.

    | Property  | Value |
    | --- | --- |
    | Role | `Purview Data Curator` |
    | Assign access to | `User, group, or service principal` |
    | Select | `<Azure AD Identities>` |

    ![Purview Data Curator](./images/azpurview01.10-role-assignment.png)

    :bulb: **Did you know?**
    
    Azure Purview has a set of predefined Data Plane roles that can be used to control who can access what.

    | Role  | Catalog | Sources/Scans | Description | 
    | --- | --- | --- | --- |
    | Purview Data Reader | `Read` |  | Access to Purview Studio (read only). |
    | Purview Data Curator | `Read/Write` |  | Access to Purview Studio (read & write). |
    | Purview Data Source Administrator |  | `Read/Write` | No access to Purview Studio. Manage data sources and data scans. |

4. Navigate to the **Role assignments** tab and confirm the **Purview Data Curator** role been has been assigned. Tip: Filter **Scope** to `This resource` to limit the results.

    ![Role Assignments](./images/azpurview01.11-access-confirm.png)

5. Repeat the previous steps by adding a second role to the same set of Azure AD identities, this time with the **Purview Data Source Administrator** role.

    ![Purview Data Source Administrator](./images/azpurview01.12-role-assignment2.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

#### 3. Open Purview Studio

1. To open the out of the box user experience, navigate to the Azure Purview account instance and click **Open Purview Studio**.

    ![Open Purview Studio](./images/azpurview01.07-open-studio.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

### Register & Scan

#### 1. Create an Azure SQL Database

1. Sign in to the [Azure portal](https://portal.azure.com) with your Azure account and from the **Home** screen, click **Create a resource**.

    ![Azure Purview](./images/azpurview01.01-create-resource.png)  

2.  Search for `Azure SQL` and click **Create**.

    ![](./images/azpurview02.31-create-sql.png)

3. Select **Single database** and click **Create**.

    ![](./images/azpurview02.32-singledb-create.png)

4. Under the **Basics** tab, select a **Resource group** (e.g. `resourcegroup-1`), provide a **Database name** (e.g. `sqldb-team01`) and under **Server** click **Create new**.
 
    ![](./images/azpurview02.33-sqlsvr-create.png)

5. Provide the necessary inputs and click **OK**.

    **NOTE**: The table below provides example values for illustrative purposes only, ensure to specify values that make sense for your deployment.

    | Property  | Example Value |
    | --- | --- |
    | Server name | `sqlsvr-team01` |
    | Server admin login | `team01` |
    | Password | `<your-sql-admin-password>` |
    | Confirm password | `<your-sql-admin-password>` |
    | Location | `East US 2` |

    **NOTE**: The **admin login** and **password** will be required later in the module. Make note of these two values.

    ![](./images/azpurview02.34-sqlsvr-new.png)

6. Click **Configure database**.

    ![](./images/azpurview02.35-sqldb-configure.png)

7. Select **Serverless** and click **Apply**.

    ![](./images/azpurview02.36-sqldb-serverless.png)

8. Navigate to the **Additional settings** tab, select **Sample**, click **Review + create**.

    ![Additional Settings](./images/azpurview02.37-sqldb-sample.png)

9. Click **Create**.

    ![](./images/azpurview02.38-sqldb-create.png)

10. Once the deployment is complete, click **Go to resource**.

    ![](./images/azpurview02.39-sqldb-complete.png)

11. Navigate to the **Server**.

    ![](./images/azpurview02.40-sqldb-server.png)

12. Click **Firewalls and virtual networks**, set **Allow Azure services and resources to access this server** to **Yes**, click **Save**.

    ![](./images/azpurview02.41-sqlsvr-firewall.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

#### 2. Create an Azure Key Vault

1. From the **Home** screen of the Azure Portal, click **Create a resource**.

    ![Azure Purview](./images/azpurview01.01-create-resource.png)  

2. Search for `Key Vault` and click **Create**.

    ![](./images/azpurview02.45-create-vault.png)

3. Under the **Basics** tab, select a **Resource group** (e.g. `resourcegroup-1`), provide a **Key vault name** (e.g. `vault-team01`), select a Region (e.g. `East US 2`). 

    ![](./images/azpurview02.46-vault-basics.png)

4. Navigate to the **Access policy** tab and click **Add Access Policy**.

    ![](./images/azpurview02.47-policy-add.png)

5. Under **Select principal**, click **None selected**.

    ![](./images/azpurview02.48-policy-select.png)

6. Search for the name of your Azure Purview account (e.g. `purview-team01`), select the item, click **Select**.

    ![](./images/azpurview02.49-policy-principal.png)

7. Under **Secret permissions**, select **Get** and **List**.

    ![](./images/azpurview02.50-secret-permissions.png)

8. Review your selections and click **Add**.

    ![](./images/azpurview02.51-policy-add.png)

9. Click **Review + create**.

    ![](./images/azpurview02.52-vault-review.png)

10. Click **Create**.

    ![](./images/azpurview02.53-vault-create.png)

11. Once your deployment is complete, click **Go to resource**.

    ![](./images/azpurview02.54-vault-goto.png)

12. Navigate to **Secrets** and click **Generate/Import**.

    ![](./images/azpurview02.55-vault-secrets.png)

13. Under **Name** type `sql-secret`. Under **Value** provide the same password that was specified for the SQL Server admin account created earlier in step 7.5. Click **Create**.

    ![](./images/azpurview02.56-vault-sqlsecret.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

#### 3. Add Credentials to Azure Purview

1. To make the secret accessible to Azure Purview, we must establish a connection to Azure Key Vault. Open **Purview Studio**, navigate to **Management Center** > **Credentials**, click **Manage Key Vault connections**.

    ![](./images/azpurview02.57-management-vault.png)

2. Click **New**.

    ![](./images/azpurview02.58-vault-new.png)

3. Use the drop-down menus to select the appropriate **Subscription** and **Key Vault name**. Click **Create**.

    ![](./images/azpurview02.59-vault-create.png)

4. Since we have already granted the Purview managed identity access to our Azure Key Vault, click **Confirm**.

    ![](./images/azpurview02.60-vault-access.png)

5. Click **Close**.

    ![](./images/azpurview02.61-vault-close.png)

6. Under **Credentials** click **New**.

    ![](./images/azpurview02.62-credentials-new.png)

7. Provide the necessary details and click **Create**.

    * Overwrite the **Name** to `credential-SQL`
    * Set the **Authentication method** to `SQL authentication`
    * Set the **User name** to the SQL Server admin login specified earlier (e.g. `team01`)
    * Select the **Key Vault connection**
    * Set the **Secret name** to `sql-secret`

    ![](./images/azpurview02.63-credentials-create.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

#### 4. Register a Source

1. Open Purview Studio, navigate to **Sources** and click **Register**.

    ![](./images/azpurview02.42-sources-register.png)

2. Navigate to the **Azure** tab, select **Azure SQL Database**, click **Continue**.

    ![](./images/azpurview02.43-register-sqldb.png)

3. Select the **Azure subscritpion**, **Server name**, and **Collection**. Click **Register**.

    ![](./images/azpurview02.44-register-azuresql.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

#### 5. Scan a Source with Azure Key Vault Credentials

1. Open Purview Studio, navigate to **Sources**, and within the Azure SQL Database source tile, click the **New Scan** button.

    ![](./images/azpurview02.64-sources-scansql.png)

2. Select the **Database** and **Credential** from the drop-down menus. Click **Test connection**. Click **Continue**.

    ![](./images/azpurview02.65-sqlscan-credentials.png)

3. Click **Continue**.

    ![](./images/azpurview02.66-sqlscan-scope.png)

4. Click **Continue**.

    ![](./images/azpurview02.67-sqlscan-scanruleset.png)

5. Set the trigger to **Once**, click **Continue**.

    ![](./images/azpurview02.68-sqlscan-schedule.png)

6. Click **Save and Run**.

    ![](./images/azpurview02.69-sqlscan-run.png)

7. To monitor the progress of the scan, click **View Details**.

    ![](./images/azpurview02.70-sqlscan-details.png)

8. Click **Refresh** to periodically update the status of the scan. **NOTE**: It will take approximately 5 minutes to complete.

    ![](./images/azpurview02.71-sqlscan-refresh.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

#### 6. View Assets

1. To view the assets that have materialised as an outcome of running the scans, perform a wildcard search by typing the asterisk character (`*`) into the search bar and hitting the Enter key to submit the query and return the search results.

    ![](./images/azpurview02.72-search-wildcard.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

### Search & Enrich

#### 1. Search Catalog

1. Open Purview Studio and from the **Home** screen, type the asterisk character (**\***) into the search bar and hit **Enter**.

    ![Search Wildcard](./images/azpurview03.01-search-wildcard.png)

2. Filter the search results by **Classification** (e.g. Country/Region) and click a hyperlinked asset name to view the details.

    ![Filter by Classification](./images/azpurview03.02-search-filter.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>

#### 2. Update an Asset

1. Click **Edit** to modify the asset details.

    ![Edit Asset](./images/azpurview03.03-asset-edit.png)

2. Update the **Description** by copying and pasting the sample text below.

    This dataset was curated from the Bing search logs (desktop users only) over the period of Jan 1st, 2020 – (Current Month - 1). Only searches that were issued many times by multiple users were included. The dataset includes queries from all over the world that had an intent related to the Coronavirus or Covid-19. In some cases this intent is explicit in the query itself (e.g., “Coronavirus updates Seattle”), in other cases it is implicit , e.g. “Shelter in place”.

    ![Update Description](./images/azpurview03.04-asset-description.png)

3. Assign a **Classification** (e.g. World Cities) using the drop-down menu.

    ![Update Classification](./images/azpurview03.05-asset-classification.png)

4. Navigate to the **Schema** tab and update the **column descriptions** using the sample text below.

    | Column Name  | Description |
    | --- | --- |
    | Date | `Date on which the query was issued.` |
    | Query | `The actual search query issued by user(s).` |
    | IsImplicitIntent | `True if query did not mention covid or coronavirus or sarsncov2 (e.g, “Shelter in place”). False otherwise.` |
    | State | `State from where the query was issued.` |
    | Country | `Country from where the query was issued.` |
    | PopularityScore | `Value between 1 and 100 inclusive. 1 indicates least popular query on the day/State/Country with Coronavirus intent, and 100 indicates the most popular query for the same geography on the same day.` |

    :bulb: **Did you know?**
    
    **Classifications** and **Glossary Terms** can be assigned at the asset level (e.g. a Table within a Database) as well as at the schema level (e.g. a Column within a Table Schema).

    ![Update Schema](./images/azpurview03.06-asset-schema.png)

5. Navigate to the **Contacts** tab and set someone within your organization to be an **Expert** and an **Owner**. Click **Save**.

    :bulb: **Did you know?**
    
    Assets can be related to two different types of contacts. **Experts** are often business process or subject matter experts. Where as **Owners** are often senior executives or business area owners that define governance or business processes over certain data areas.

    ![Update Contacts](./images/azpurview03.07-asset-contacts.png)

6. To see other assets within the same path, navigate to the **Related** tab.

    ![Related Assets](./images/azpurview03.08-asset-related.png)

<div align="right"><a href="#challenge-6-data-governance---coachs-guide">↥ back to top</a></div>