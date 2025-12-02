# Challenge 04 - Quota Monitoring and Enforcement - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance


### LLM Quota Management Configuration Settings

In the **`/ContosoAIAppsBackend/`** folder of the Codespace or Student resources package, students should modify the configuration file (`local.settings.json`) in the following ways:

- Modify the application configuration to enable quota enforcement. This is done by changing the `LLM_QUOTA_ENFORCEMENT` to 1
- Modify the application configuration to specify the llm transaction aggregate window: This is done by changing the `LLM_QUOTA_ENFORCEMENT_WINDOW_SECONDS` to 120
- Modify the application configuration to specify the number of transactions allowed for each school district within the window : This is done by changing the `LLM_QUOTA_ENFORCEMENT_MAX_TRANSACTIONS` to 5
- Modify the application configuration to specify the cool down period when the transaction threshold is reach:  This is done by changing the `LLM_QUOTA_ENFORCEMENT_COOL_DOWN_SECONDS` to 300

### Student Exams to be Re-processed
The students will use the Azure CLI to upload the submission documents located in `data/contoso-education/submissions`:<br>
Example: <br>
`az storage blob upload-batch --account-name contosopeterod1storage -d submissions -s .`

**NOTE:** If the student gets a `429 Too Many Requests` in the Terminal output window, go to OpenAI Studio and edit the deployment for `text-embedding-ada-002` and increase the tokens per minute rate limit to maximum. Do the same thing for `gpt-4`.
