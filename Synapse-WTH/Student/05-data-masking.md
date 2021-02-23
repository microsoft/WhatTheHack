# Challenge 5: Mask Data for Privacy

[< Previous Challenge](./04-incrementals.md) - **[Home](../README.md)** - [Next Challenge >](./06-new-data.md)

## Introduction
My team says that I don't give them enough privacy...
...at least that's what their sent emails say.

## Description
The powerlifting event data contains participants first and last names.  This falls within the terms of use for the current data set.  However, the federation is planning some data analysis and data sharing initiatives that may require limiting the use of identifiying information.  

As a trial of capabilities, the data privacy team has asked you to implement masking of first and last names.

The suggested masking should correctly show the first two characters of the foirst and last name.  All subseuqent characters should be replaced with an "x".


## Success Criteria
1. Modify your solution so that any user queries against the data store return masked values for First and Last name.  This should apply to all user queries whether via reporting tool or direct SQL queries.
2. Show how you would grant specific users or user groups the abaility to bypass the masking and see the full names.
3. Show how you would turn the masking "on" or "off" altogether.

Bonus
- Show the least privilege approach to allowing someone to manage masking (e.g., enforce or bypass) without granting them full database admin permissions.
- Show how a database admin could identify all the columns in the data store which currently have masking policies applied.

## Learning Resources
Reference articles:
- [Dynamic Data Masking in Azure Synapse](https://docs.microsoft.com/en-us/sql/relational-databases/security/dynamic-data-masking?view=azure-sqldw-latest)

