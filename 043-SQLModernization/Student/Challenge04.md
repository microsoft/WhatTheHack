# Challenge 4 - Security & Auditing

[< Previous Challenge](./Challenge03.md) - **[Home](../README.md)** - [Next Challenge>](./Challenge05.md)

## Introduction

More than ever, organizations require rigorous security and auditing requirements to meet internal standards and external regulations, such as [GDPR](https://gdpr.eu/) and [HIPAA](https://www.hhs.gov/hipaa/index.html). While [Azure has obtained many compliance certifications](https://docs.microsoft.com/en-us/azure/compliance/), best practices must be followed by application and data engineers to ensure their applications meet their stated requirements. More information is available on the [Azure Trust Center](https://www.microsoft.com/en-us/trust-center/product-overview).

The purpose of this challenge is to introduce features of SQL Server that may help meet these obligations. This is not intended to be exhaustive or imply compliance with any particular certification. 

## Description

AdventureWorks would like to encrypt their database using transparent data encryption (TDE). TDE encrypts the data at rest which assists in mitigating offline malicious activity, preventing a backup from being restored, transaction logs being copied, etc. TDE is transparent to the application. TDE should be configured with a custom 2048-bit key stored in Azure Key Vault, with a 1 year expiration date.

AdventureWorks would also like to have a vulnerability assessment done on the database, both immediately and on an on-going basis with the results sent as emails; Advanced Threat Protection should be enabled to notify in the event of security events like SQL injection or data exfiltration.

An important step in monitoring and securing a database is classifying and labelling the database. Just like taking inventory of goods, this step servers as the baseline for auditing and additional security steps. Using the Data Discovery and Classification tools, classify the database with appropriate types and sensitivities. At a minimum, any personal information should be classified as Personal or Contact Info, any login or password related columns as Credentials, and so on.

With Data Discovery and Classification complete, auditing is a much more effective tool -- here, too, AdventureWorks needs all access to sensitive data audited. This should be configured to audit to both blob storage and Log Analytics.

As an early implementation to improve security, the team would like to implement Dynamic Data Masking on the Person.PersonPhone (if using AdventureWorks full) or SalesLT.Phone (if using AdventureWorksLT) to mask the full phone number in downstream application so that customer service representatives do not see the full phone number but can confirm the last 4 digits with the caller.

## Success Criteria

* Secure the AdventureWorks database using a custom 2048-bit key stored in Azure Key Vault.
* Enable vulnerability assessment scanning on the database.
* Using Data Discovery and Classification, label all sensitive fields with the appropriate types and sensitivities.
* Configuring Auditing to write audit logs to both a storage account and to Log Analytics.
* Configure Advanced Threat Protection to capture all event types and send an email in the event of a security alert.
* Configure Dynamic Data Masking on the Person.PersonPhone or SalesLT.Phone column (for AdventureWorks or AdventureWorksLT, respectively) that masks all but the last 4 digits on the phone number. 

## Advanced Challenges (Optional)

* For the Data Discovery and Classification task, perform the steps using PowerShell cmdlets or the Rest API.
* Create a Power BI dashboard to display audit log information.
* (AdventureWorks database Only -- not LT) Add a Dynamic Data Mask to the HumanResources.EmployeePayHistory Rate column, and then write a query using a MASKED user that illustrates a potential leakage to a user using ad-hoc queries.

## Learning Resources
* [Azure SQL Fundamentals](https://aka.ms/azuresqlfundamentals)
* [TDE for Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal)
* [Azure SQL Database Security Overview](https://docs.microsoft.com/en-us/azure/azure-sql/database/security-overview)
* [Data Discovery and Classification Overview](https://docs.microsoft.com/en-us/azure/azure-sql/database/data-discovery-and-classification-overview)
* [Azure Defender for SQL](https://docs.microsoft.com/en-us/azure/azure-sql/database/azure-defender-for-sql)
* [Dynamic Data Masking](https://docs.microsoft.com/en-us/sql/relational-databases/security/dynamic-data-masking?view=sql-server-ver15)