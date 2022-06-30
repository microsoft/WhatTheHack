# Challenge 5: Business Glossary

[< Previous Challenge](./Challenge4.md) - [Home](../README.md) - [Next Challenge >](./Challenge6.md)

## Introduction

Business users in Fabrikam would like to add additional descriptive information to assets in your data platform environment. This will help different departments to understand business jargon associated with the data repositories. Some of these definitions can be reused in multiple assets so it is important for users to easily govern them and have people assigned in case of needed contact.

## Description
With the custom classification, we have been able to enrich the metadata and help users search for data more effectively. While this has helped, business users have expressed desire to be able to tag assets with business terms which make more sense for them while they try to use the catalog for finding their assets.

In this challenge you will setup a business glossary with terms that have been provided by the business users through a .CSV file. Once the glossary has been defined, you will tag assets and attributes using these terms. You also have to create new single terms in a parent-child hierarchy as follows:

- Team Unit
    - Account Team Unit
    - Specialist Team Unit

All of these three terms need an additional column called "Microsoft Terminology".  

Ensure that these terms can be used for searching these tagged assets and can also be used as filter conditions for the search.

.CSV file with terms: [https://stpurviewfasthack.blob.core.windows.net/purviewfasthack/StarterKitTerms.csv](https://wthpurview.blob.core.windows.net/wthpurview)

## Success Criteria
- Successfully created glossary elements demonstrating a parent-child term hierarchy.
- Successfully bulk loaded terms into the Glossary.
- Tagged asset(s) with appropriate glossary terms.
- Confirm that the newly applied tags can be used to filter the search results.

## Learning Resources
- [Understand business glossary features in Microsoft Purview](https://docs.microsoft.com/en-us/azure/purview/concept-business-glossary)
- [How to create, import, and export glossary terms](https://docs.microsoft.com/en-us/azure/purview/how-to-create-import-export-glossary)
