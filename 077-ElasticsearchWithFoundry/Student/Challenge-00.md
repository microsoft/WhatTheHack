# Challenge 00 - Ready, Set, Connect

**[Home](../README.md)** - [Next Challenge >](./Challenge-01.md)

## Introduction

Precision Labs' Support Copilot is built and hosted in Microsoft Foundry, and needs to find trustworthy answers in three data sets: CRM accounts, support tickets, and KB articles. In this challenge you will prepare the three environments used for the rest of the hack: an Azure lab subscription (Microsoft Foundry), an Elastic Serverless trial (data and MCP tools), and a GitHub Codespace (your developer environment).

## Prerequisites

- Access to the Azure lab environment provided for this event.
- A [GitHub account](https://github.com/signup) (use your personal account, not an enterprise managed account).
- An email address to create an [Elastic Cloud trial account](https://cloud.elastic.co/registration).

## Description

### Launch the Azure Lab Environment

Today's hack event is providing you with a temporary Azure Lab environment powered by CloudLabs. To use CloudLabs you must register for the event at the following link:

[Register for Azure Lab Environment from Microsoft powered by CloudLabs](https://aka.ms/Elastic_WTH)

Once registered, you will receive a confirmation email from: `microsoftevents@cloudlabs.ai`

> **NOTE:** If you do not see the email in your inbox, please be sure to check your Spam or Junk folders.

When you receive the confirmation email:
- Click the **"Attend Event"** link in it. 
- Click **"Launch Lab"** in the browser window that opens.
- The lab will take 3-5 minutes to provision
- Once the lab has been provisioned, click the **"Environment"** tab and you should see a set of Azure login credentials.

Gather the following from the lab environment and keep them handy. You will use them in the Codespace terminal:

1. Azure username (example: `odl_user_xxxxx@aiw-ds.cloudlabs.ai`)
2. Azure password

Keep these credentials handy as you will need them to log into the [Microsoft Foundry portal](https://ai.azure.com).

### Create an Elastic Serverless Trial Environment

The following steps guide you to create an Elastic Serverless trial via the Microsoft Marketplace in the Azure portal.

1. Go to [Elasticsearch (7-day free trial)](https://ela.st/azure-marketplace) in the Microsoft Marketplace.
2. Click the **Get it now** button.
3. You will be prompted to log in to the Azure portal. Use the Azure username (`odl_userxxxxx@aiw-ds.cloudlabs.ai`) and password you were provided from the lab environment.
4. On the **Basics** tab:
   - Choose **"Create new"** for **Resource Group** and give it a name (example: `rg-elastic-hack-john`).
   - For **Resource Name**, use `elastic-wth`
   - For **Hosting Type**, choose **Serverless**. 
   - Use the default **Region** (`(US) East US`).
> **WARNING:** Do NOT choose **"Cloud Hosted"** for the **Hosting Type** as it will not support the features required for this hack. 

5. Click **Review + Create**. Your Elasticsearch trial deployment will start.
6. When the deployment is complete, click the **Go to resource** button. This will open the **Elastic Cloud Resource** pane in the Azure portal where you can view your deployment.
7. In the **Elastic Cloud Resource** pane, click the **View in Elastic** link (on the lower right side of the window). This will launch the Elastic Kibana portal.
8. **Kibana** will prompt you to log in. Click the **SSO** link and log in using your Azure credentials (`odl_userxxxxx@aiw-us.cloudlabs.ai`).
9. In **Kibana**, gather your **Elasticsearch endpoint URL** and your **Kibana URL**. They are different URLs, and you will need both.
1. Create an **API key** for the deployment script:
   - In the project, go to **Developer Tools / API keys** (or search for "API keys" in the top search bar).
   - Click **Create API key**, give it a name such as `wth-setup`, and keep the default privileges.
   - Copy the **encoded** key value immediately. It is shown only once.
   - Keep it available until you create your local `.env` file in the deployment section below. You will paste it into `ELASTIC_API_KEY`.

> **Warning:** Treat API keys like passwords. Do not paste them in chat, screenshots, or Git.

If you are not able to provision Elastic via the Microsoft Marketplace, expand and follow the instructions below to create a trial directly on Elastic's website:

<details markdown=1>
<summary markdown="span"><strong>Click to expand/collapse Create Elastic Serverless Non-Marketplace Trial</strong></summary>

#### Create Elastic Serverless Non-Marketplace Trial

1. Go to [Elastic Cloud trial account](https://cloud.elastic.co/registration) and sign up for a free Elastic Cloud trial using a personal email address.
2. Check your inbox for a verification email to launch the new trial.
3. When prompted to create a project, choose **Elasticsearch** as the project type. 

> **WARNING**: Choosing a different project type may impact how this lab works!

4. Give your project a name (example: `elastic-wth`)
5. Choose **Azure** for your Cloud provider and **Virginia (eastus)** or **Washington (westus2)** for your Region.
6. Wait for the project to finish creating, then open it.
7. Gather your **Elasticsearch endpoint URL** and your **Kibana URL**. They are different URLs, and you will need both.
8. Create an **API key** for the deployment script:
   - In the project, go to **Developer Tools / API keys** (or search for "API keys" in the top search bar).
   - Click **Create API key**, give it a name such as `wth-setup`, and keep the default privileges.
   - Copy the **encoded** key value immediately. It is shown only once.
   - Keep it available until you create your local `.env` file in the deployment section below. You will paste it into `ELASTIC_API_KEY`.

> **Warning:** Treat API keys like passwords. Do not paste them in chat, screenshots, or Git.

</details>

### Launch Development Environment

You will use [GitHub Codespaces](https://docs.github.com/en/codespaces/overview) as your development environment. A GitHub Codespace is a development environment hosted in the cloud that you access via a browser. The Azure CLI and Python are pre-installed, and the Codespace installs the sample data loader's Python packages during creation.

GitHub Codespaces is available to every personal GitHub.com account, which includes a monthly free usage quota. You can check your balance on the [GitHub billing page](https://github.com/settings/billing/summary).

1. Open the Codespace for this hack: [Elasticsearch with Foundry Codespace](https://aka.ms/wth/elasticfoundry/codespace)
2. Sign in with your **personal** GitHub account.
3. Verify the `Dev container configuration` is set to the one for this hack, then click **Create Codespace**.
4. Wait for Visual Studio Code to load in your browser. The first launch takes approximately 3-5 minutes. The Codespace automatically installs the `elasticsearch` and `python-dotenv` Python packages during creation.

**NOTE:** If you close the Codespace, return to [GitHub Codespaces](https://github.com/codespaces) to find and re-launch it.

### Configure and Load Sample Data

In this section, you will deploy the sample data for this hackathon.

From the **Terminal** in your Codespace, complete the following:

1. Add your Elastic values to the configuration file used by the setup scripts. Copy the `.env.sample` file to `.env`:

   ```bash
   cp .env.sample .env
   chmod 600 .env
   code .env
   ```

   Replace the values of these three entries with the URLs and **encoded setup API key** you copied from your Elastic project:

   ```dotenv
   ELASTICSEARCH_URL=https://<your-elasticsearch-endpoint>
   KIBANA_URL=https://<your-kibana-endpoint>
   ELASTIC_API_KEY=<your-encoded-setup-api-key>
   ```

   Save the file before continuing. 
   
   > **WARNING:** Keep `.env` private and never commit it to Git.

3. Run the data loader:

   ```bash
   bash data/load_data.sh
   ```

   The loader automatically reads the settings from `.env`.


   > **Warning:** Every run deletes and recreates the three workshop sample indices. Wait for the generators to finish and check that the final document counts are **500 accounts**, **3,000 tickets**, and **150 articles**. 
   
   > **NOTE:** If the script fails or prints `ERR`, read the error, check your `.env` settings and project access, and run it again.

### Verify Your Elastic Environment in Kibana

1. Open your **Kibana URL** in a browser and sign in.
2. Confirm the sample indices exist:
   - Open **Index Management** (search for "Index Management" in the top search bar) and select the **Indices** tab.
   - Find `precision-crm-accounts`, `precision-support-tickets`, and `precision-kb-articles`. Click each one and open the **Documents** tab (or use **Discover**) to confirm it contains records.

## Success Criteria

- Verify that your Elastic trial project exists and that you have your Elasticsearch URL, Kibana URL, and API key.
- Verify that your Codespace is running and that your `.env` file contains your Elastic values.
- Verify that `bash data/load_data.sh` completed without errors and printed the expected document counts.
- Demonstrate in Kibana that the three workshop sample indices exist and contain documents.

## Learning Resources

- [GitHub Codespaces Overview](https://docs.github.com/en/codespaces/overview)
- [Elastic Cloud Serverless](https://www.elastic.co/docs/deploy-manage/deploy/elastic-cloud/serverless)
- [Elastic Agent Builder tools](https://www.elastic.co/docs/explore-analyze/ai-features/agent-builder/tools)
- [Elastic API keys](https://www.elastic.co/docs/deploy-manage/api-keys/elasticsearch-api-keys)

## Tips

- Your Elasticsearch URL and Kibana URL are different. Use the Kibana URL to browse the web interface.
- The Elastic API key is shown only once. If you lose it, create a new one.
