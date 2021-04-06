# Challenge 1: Gathering Open Powerlifting Data

[< Previous Challenge](./00-prereqs.md) - **[Home](README.md)** - [Next Challenge >](./02-load-data.md)

## Notes and Guidance
- There is a link on the student page to get the data. Link is [here](https://github.com/sstangl/openpowerlifting-static/raw/gh-pages/openpowerlifting-latest.zip) should they need additional guidance 
- The trick is to upload this data to ADLS storage to begin using Azure Synapse Analytics which derives from the hint 'assume that in later challenges you will be loading the data into a relational database'.
- Remind your team that they have security requirements
  - Do not expose uploaded data files to anonymous (Public) internet access
  - Support controlling access to folders and files based on Azure Active Directory identity (RBAC)
- They should utilize ADLS storage for their landing zone
- Share screen/show that the data is in ADLS
- Explaining the use of Azure Key Vaults to store keys instead of sensitive credentials in code (BONUS)
- Explaining the manageability and security of Azure Active Directory RBAC (BONUS)
