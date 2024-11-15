# Challenge 04 - Quota Monitoring and Enforcement - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)** - [Next Solution >](./Solution-05.md)

## Notes & Guidance

The students will use the Azure CLI to upload the submission documents located in `artifacts/contoso-education/submissions`:<br>
Example: <br>
`az storage blob upload-batch --account-name contosopeterod1storage -d submissions -s .`

If the student gets a `429 Too Many Requests` in the Terminal output window, go to OpenAI Studio and edit the deployment for `text-embedding-ada-002` and increase the tokens per minute rate limit to maximum. Do the same thing for `gpt-4`.
