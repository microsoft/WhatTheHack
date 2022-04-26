# Challenge 5: Business glossary

[< Previous Challenge](./Challenge4.md) - [Home](../readme.md) - [Next Challenge >](./Challenge6.md)

## Description

Business users in Fabrikam would like to add additional descriptive information to assets in your data platform environment. This will help different departments to understand technical jargon associated with the data repositories. Some of these definitions can be reused in multiple assets so it is important for users to easily govern them and have people assigned in case of needed contact.

## Introduction

With the custom classfiication, we have been able to enrich the metadata and help users search for data more effectively. While this has helped, business users have expressed desire to be able to tag assets with business terms which make more sense for them while they try to use the catalog for finding their assets.

In this challenge you will setup a business glossary with terms that have been provided by the business users through a .csv file. Once the glossary has been defined, you will tag assets and attributes using these terms.

Ensure that these terms can be used for searching these tagged assets and can also be used as filter conditions for the search.

## Success Criteria
- Create new term 'Team Unit' and assign yourself as an Term Expert.
- Create new terms 'Account Team Unit', 'Specialist Team Unit' with additional custom field "Microsoft Terminology"
- Create parent-child relationship with ‘Team Unit’ as parent term and 'Account Team Unit’, ‘Specialist Team Unit’ as child terms. 
- Bulk load terms provided in .CSV file (https://stpurviewfasthack.blob.core.windows.net/purviewfasthack/StarterKitTerms.csv)
- Assign terms to assets scanned in previous challenges.
- Confirm that the newly applied tags can be used to filter the search results.

## Learning Resources
- https://docs.microsoft.com/en-us/azure/purview/concept-business-glossary
- https://docs.microsoft.com/en-us/azure/purview/how-to-create-import-export-glossary
