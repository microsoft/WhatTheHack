# Challenge 3 - Security & Auditing

[< Previous Challenge](../Challenge02.md) - **[Home](../../README.md)** - [Next Challenge>](../Challenge04.md)

## Introduction 

More than ever, organizations require rigorous security and auditing requirements to meet internal standards and external regulations, such as [GDPR](https://gdpr.eu/) and [HIPAA](https://www.hhs.gov/hipaa/index.html). While [Azure has obtained many compliance certifications](https://docs.microsoft.com/en-us/azure/compliance/), best practices must be followed by application and data engineers to ensure their applications meet their stated requirements. More information is available on the [Azure Trust Center](https://www.microsoft.com/en-us/trust-center/product-overview).

The purpose of this challenge is to introduce features of SQL Server that may help meet these obligations. This is not intended to be exhaustive or imply compliance with any particular certification. 

## Description

AdventureWorks would like to encrypt their database using transparent data encryption (TDE). TDE encrypts the data at rest which assists in mitigating offline malicious activity, preventing a backup from being restored, transaction logs being copied, etc. TDE is transparent to the application.

AdventureWorks would also like to have a vulnerability assessment done on the database, both immediately and on an on-going basis with the results sent as emails, and have Advanced Threat Protection enabled to notify in the event of security events like SQL injection or data exfiltration.

An important step in monitoring and securing a database is classifying and labelling the database. Just like taking inventory of goods, this step servers as the baseline for auditing and additional seurity steps. Using the Data Discovery and Classification tools, classify the database with appropriate types and sensitivites. At a minimum, any personal information should be classified as Personal or Contact Info, any login or password related columns as Credentials, and so on.

With Data Discovery and Classification complete, auditing is a much more effective tool -- here, too, AdventureWorks needs all access to sensitive data audited. This should be configured to audit to both blob storage and Log Analytics.

As an early implementation to improve security, the team would like to implement Dynamic Data Masking on the Person.PersonPhone (if using AdventureWorks full) or SalesLT.Phone (if using AdventureWorksLT) to mask the full phone number in downstream application so that customer service representatives do not see the full phone number, but can confirm the last 4 digits with the caller.






## Success Criteria

1. Secure the AdventureWorks database using a custom 2048-bit key stored in Azure Key Vault with an expiration date of 1 year.
2. Enable vulnerability assessment scanning on the database, notiying the team (or a member of the team) when assessments are done. Perform the first assessment on-demand and review the findings.
3. Using Data Discovery and Classification, label all sensitive fields with the appropriate types and sensitivities; at a minimum, label all personal contact/PII fields, financial, and authentication related fields.
4. Configuring Auditing to write audit logs to both a storage account and to Log Analytics. Verify logs are writing to the storage account by executing a query on a table with sensitive information.
5. Configure Advanced Threat Protection to capture all event types and send an email in the event of a security alert. Test this by authoring an example script (such as a SQL injection attempt and verify your team receives an email notification).
6. Configure Dynamic Data Masking on the Person.PersonPhone or SalesLT.Phone column (for AdventureWorks or AdventureWorksLT, respectively) that masks all but the last 4 digits on the phone number. Demonstrate the functionality works as intended using a test script. What permissions determine whether a user sees masked vs unmasked data? In what ways 

## Learning Resources
* [TDE for Azure SQL Database](https://docs.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview?tabs=azure-portal)
* [Azure SQL Database Security Overview](https://docs.microsoft.com/en-us/azure/azure-sql/database/security-overview)
* [Data Discovery and Classification Overview](https://docs.microsoft.com/en-us/azure/azure-sql/database/data-discovery-and-classification-overview)
* [Azure Defender for SQL](https://docs.microsoft.com/en-us/azure/azure-sql/database/azure-defender-for-sql)
* [Dynamic Data Masking](https://docs.microsoft.com/en-us/sql/relational-databases/security/dynamic-data-masking?view=sql-server-ver15)

## Tips

## Advanced Challenges (Optional)

1. For the Data Discovery and Classification task, perform the steps using PowerShell cmdlets or the Rest API.
2. Create a Power BI dashboard to display audit log information.
3. (AdventureWorks database Only -- not LT) WWI is excited about using Dynamic Data Masking, but your team needs to demonstrate why it is considered "defense in depth," best used with other best practices. Add a Dynamic Data Mask to the HumanResources.EmployeePayHistory Rate column, and then write a query using a MASKED user that illustrates a potential leakage to a user using ad-hoc queries.