# Challenge 3 - Security & Auditing

[< Previous Challenge](../Challenge02/Challenge02.md) - **[Home](../../../README.md)** - [Next Challenge>](../Challenge04/Challenge04.md)

## Introduction 

More than ever, organizations require rigorous security and auditing requirements to meet internal standards and external regulations, such as [GDPR](https://gdpr.eu/) and [HIPAA](https://www.hhs.gov/hipaa/index.html). While [Azure has obtained many compliance certifications](https://docs.microsoft.com/en-us/azure/compliance/), best practices must be followed by application and data engineers to ensure their applications meet their stated requirements. More information is available on the [Azure Trust Center](https://www.microsoft.com/en-us/trust-center/product-overview).

The purpose of this challenge is to introduce features of SQL Server that may help meet these obligations. This is not intended to be exhaustive or imply compliance with any particular certification. 

## Description

AdventureWorks would like to encrypt their database using transparent data encryption (TDE). TDE encrypts the data at rest which assists in mitigating offline malicious activity, preventing a backup from being restored, transaction logs being copied, etc. TDE is transparent to the application.

AdventureWorks would also like to have a vulnerability assessment done on the database, both immediately and on an on-going basis. 




Classification
Auditing



## Success Criteria

1. Secure the AdventureWorks database using a custom 2048-bit key stored in Azure Key Vault with an expiration date of 1 year.
2. Enable vulnerability assessment scanning on the database, notiying the team (or a member of the team) when assessments are done. Perform the first assessment on-demand and review the findings.



## Learning Resources
* [TDE for Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal)
* [Azure SQL Database Security Overview](https://docs.microsoft.com/en-us/azure/azure-sql/database/security-overview)



## Tips


