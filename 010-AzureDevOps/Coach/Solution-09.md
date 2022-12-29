# Challenge 09 - Azure Pipelines: OSS Scanning with Mend Bolt - Coach's Guide 

[< Previous Solution](./Solution-08.md) - **[Home](./README.md)**

## Notes & Guidance

This was updated to mend (previously known as whitesource).  The instruction set should be the same.

- General Guidelines
  - Install the Mend Bolt extension to the azure devops organization.  The article in the challenge will have a link to take you there.
  - Students will need to sign up for a mend account.  To do this, they will need to go to the ***Organization*** settings and go to the mend tab.   Students will need to put their information in to activate the account.
  - Students can now use the mend bolt task in the assistant to add to their workflow.
  - Once the pipeline finishes running there should be a link in the logs to point them to the mend portal with scan results.