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

The in-person lab proctor will tell you how to launch your Azure lab environment and will provide your lab credentials.

`<PLACEHOLDER: Azure lab launch instructions provided by the lab proctor>`

Gather the following from the lab environment and keep them handy. You will use them in the Codespace terminal:

1. Azure username (Spektra credentials)
2. Azure password
3. Azure subscription ID (if shown by the lab environment)

### Create an Elastic Serverless Trial Environment

1. Go to [Elastic Cloud trial account](https://cloud.elastic.co/registration) and sign up for a free Elastic Cloud trial.
2. When prompted to create a project, choose **Elasticsearch** as the project type and use the default settings.
3. Wait for the project to finish creating, then open it.
4. Gather your **Elasticsearch endpoint URL** and your **Kibana URL**. They are different URLs, and you will need both.

   `<PLACEHOLDER: Screenshot showing where to find the Elasticsearch endpoint and Kibana URL>`

5. Create an **API key** for the deployment script:
   - In the project, go to **Developer Tools / API keys** (or search for "API keys" in the top search bar).
   - Click **Create API key**, give it a name such as `wth-setup`, and keep the default privileges.
   - Copy the **encoded** key value immediately. It is shown only once.
   - Keep it available until you create your local `.env` file in the deployment section below. You will paste it into `ELASTIC_API_KEY`.

   `<PLACEHOLDER: Screenshot showing where to create and copy the Elastic API key>`

> **Warning:** Treat API keys like passwords. Do not paste them in chat, screenshots, or Git.

### Launch Development Environment

You will use [GitHub Codespaces](https://docs.github.com/en/codespaces/overview) as your development environment. A GitHub Codespace is a development environment hosted in the cloud that you access via a browser. All of the developer tools for this hack, including the Azure CLI and Python/Jupyter, are pre-installed.

GitHub Codespaces is available to every personal GitHub.com account, which includes a monthly free usage quota. You can check your balance on the [GitHub billing page](https://github.com/settings/billing/summary).

1. Open the Codespace for this hack: [Elasticsearch with Foundry Codespace](https://aka.ms/wth/elasticfoundry/codespace)
2. Sign in with your **personal** GitHub account.
3. Verify the `Dev container configuration` is set to the one for this hack, then click **Create Codespace**.
4. Wait for Visual Studio Code to load in your browser. The first launch takes approximately 3-5 minutes.

**NOTE:** If you close the Codespace, return to [GitHub Codespaces](https://github.com/codespaces) to find and re-launch it.

### Configure and Load Sample Data

In this section, you will deploy the sample data for this hackathon.

From the **Terminal** in your Codespace, complete the following. Run the commands from the student resource root, the folder containing `.env.sample` and `data/`:

1. Log in to Azure with your lab credentials:

   ```bash
   az login
   ```

   **NOTE:** The Codespace uses a device code. Open the URL shown, enter the code, and sign in with the Azure username and password from your lab environment. If your organization's policy blocks device-code login, open the Codespace in VS Code Desktop and run `CODESPACES=false az login`.

2. Add your Elastic values to the configuration file used by the setup scripts:

   ```bash
   cp .env.sample .env
   chmod 600 .env
   code .env
   ```

   If you already have a `.env` file, skip the copy command so you do not overwrite your settings.

   Replace the values of these three entries with the URLs and **encoded setup API key** you copied from your Elastic project:

   ```dotenv
   ELASTICSEARCH_URL=https://<your-elasticsearch-endpoint>
   KIBANA_URL=https://<your-kibana-endpoint>
   ELASTIC_API_KEY=<your-encoded-setup-api-key>
   ```

   Save the file before continuing. Leave the other entries unchanged for now. Keep `.env` private and never commit it to Git.

3. Run the data loader:

   ```bash
   python3 -m pip install elasticsearch python-dotenv
   bash data/load_data.sh
   ```

   The loader automatically reads the settings from `.env`

   **TODO:** The Codespace will be updated to run `python3 -m pip install elasticsearch python-dotenv`. Then we can remove this step for the students.

   **Warning:** Every run deletes and recreates the three workshop sample indices. Wait for the generators to finish and check that the final document counts are **500 accounts**, **3,000 tickets**, and **150 articles**. 
   
   **NOTE:** If the script fails or prints `ERR`, read the error, check your `.env` settings and project access, and run it again.

### Verify Your Elastic Environment in Kibana

1. Open your **Kibana URL** in a browser and sign in.
2. Confirm the sample indices exist:
   - Open **Index Management** (search for "Index Management" in the top search bar) and select the **Indices** tab.
   - Find `precision-crm-accounts`, `precision-support-tickets`, and `precision-kb-articles`. Click each one and open the **Documents** tab (or use **Discover**) to confirm it contains records.

   `<PLACEHOLDER: Screenshot of the workshop indices in Index Management>`

## Success Criteria

- Verify that you can sign in to the Azure lab environment and that `az account show` in the Codespace shows the lab subscription.
- Verify that your Elastic trial project exists and that you have your Elasticsearch URL, Kibana URL, and API key.
- Verify that your Codespace is running and that your `.env` file contains your Elastic values.
- Verify that `bash data/load_data.sh` completed without errors and printed the expected document counts.
- Demonstrate in Kibana that the three workshop sample indices exist and contain documents.

## Learning Resources

- [GitHub Codespaces Overview](https://docs.github.com/en/codespaces/overview)
- [Elastic Cloud Serverless](https://www.elastic.co/docs/deploy-manage/deploy/elastic-cloud/serverless)
- [Elastic Agent Builder tools](https://www.elastic.co/docs/explore-analyze/ai-features/agent-builder/tools)
- [Elastic API keys](https://www.elastic.co/docs/deploy-manage/api-keys/elasticsearch-api-keys)
- [Sign in with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli)

## Tips

- Your Elasticsearch URL and Kibana URL are different. Use the Kibana URL to browse the web interface.
- The Elastic API key is shown only once. If you lose it, create a new one.
