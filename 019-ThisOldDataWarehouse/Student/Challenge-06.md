# Challenge 6: Enterprise Security

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction

World Wide Importers (WWI) leadership is happy with the progress of the migration thus far but wants to ensure that info security guard rails are implemented appropriately. Additionally, they want to further understand the art of possible when it comes to enterprise data security involving the new Azure Synapse Analytics Platform. This will be done in the form of a stakeholder update at the end of the exercise.

## Description

The objective of this lab is to baseline the implementation of enterprise grade security controls and services for Azure Synapse Dedicated SQL Pools.

Categories of security enablement are as follows:

- SQL Auditing
- Monitoring and alerting
- Vulnerability Assessment/Advanced Threat Protection
- Row/Column Level Security (i.e. Data Masking)
- Managed Identity
- Data Encryption

The intent is to not only to enable security features but also to understand what each layer of security provides to communicate this to WWI leadership.

**SQL Auditing**

- SQL Auditing is enabled to ensure all existing and future created SQL Pools inherit activation. Logs need to be stored in a place that can be easily queried. Demonstrate as follows:
  - Identify where last query originated from (i.e. SSMS) the last query to come from SSMS
  - Identify the last user to query [Fact].[Sales]
  - Count the number of failed logins for each user with a failed login

**Monitoring and alerting**

- Create an Alert that will send a text message and an email to you if a user has failed to login more than 5 times.

**Vulnerability Assessment/Advanced Threat Protection**

- Enable Microsoft Defender incorporating both Vulnerability Assessment and Advanced Threat Protection. Simulate advanced threat protection by generating sample alerts (If setup properly you should receive an email from Microsoft Defender).

**Row/Column Level Security**

You will need to create SQL users for scenario testing as follows:

- Use Master Database on Dedicated SQL Pool (Provide complex passwords accordingly) \
 CREATE LOGIN WWIConsultantNJ WITH PASSWORD = ' '; \
 CREATE LOGIN WWIConsultantAL WITH PASSWORD = ' '; \
 CREATE LOGIN sqlauditadmin WITH PASSWORD = ' '; 
- Use Synapse Dedicated SQL Pool \
 CREATE USER WWIConsultantNJ FOR LOGIN WWIConsultantNJ ; \
 CREATE USER WWIConsultantAL FOR LOGIN WWIConsultantAL ; \
 CREATE USER sqlauditadmin FOR LOGIN sqlauditadmin ; \
 EXEC sp\_addrolemember 'db\_owner', 'sqlauditadmin'; 

- Secure [Fact].[Sale] to exclude SQL user "WWIConsultantNJ" and user "WWIConsultantAL" from viewing column "Profit".
- Secure [Fact].[Sale] which will allow SQL user "WWIConsultantNJ" to only see rows including city of North Beach Haven, NJ and "WWIConsultantAL" to only see rows including city of Robertsdale, AL but still allowing "sqlauditadmin" to see all the data.
- Secure [Fact].[Sale] where SQL User "WWIConsultantNJ" and "WWIConsultantAL" can see all tax related columns but data is masked or zeroed out (Tax Rate, Tax Amount, Total Excluding Tax,Total Including Tax).

**Managed Identity**

- An ADF job that will Copy [Fact].[Sale] to [Fact].[SaleCopy] using ADF Managed Identity for authentication/authorization.

**Data Encryption**

- Clearly understand how to properly set up customer managed TDE (Transparent Data Encryption) in a fashion where key is protected, monitored and versioned. This will be discussed in further detail as a group.


## Success Criteria

**SQL Auditing**

- Validate that SQL audit logs are being generated properly and stored in a destination that has the ability to execute complex queries.
- Describe the benefits of leveraging SQL Auditing.

**Monitoring and Alerting**

- Validate alert creation and that alert will send a text and email upon triggering.

**Advanced Threat Protection/Vulnerability Assessment**

- Verify all critical items identified in Vulnerability Assessment have been resolved.
- Verify sample alerts from Advanced Protection were sent appropriately.
- Describe the benefit of both services.

**Row/Column Level Security**

- Validate row/column level security changes by leveraging previously created test users to ensure security changes are effective.

**Managed Identity**

- Validate that an ADF job can properly access the database using Managed Identity only.
- Describe the security benefits of leveraging Managed Identity.

**Data Encryption**

- Describe the value of using TDE and advantages customer key provides vs. built-in.

## Learning resources

- [SQL Auditing](https://docs.microsoft.com/en-us/azure/azure-sql/database/auditing-overview?view=azuresql)
- [Advanced Logging](https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-create-new-alert-rule?tabs=metric)
- [Vulnerability Assessment](https://learn.microsoft.com/en-us/azure/azure-sql/database/sql-vulnerability-assessment?view=azuresql&tabs=azure-powershell)
- [Advanced Threat Protection](https://docs.microsoft.com/en-us/azure/azure-sql/database/threat-detection-overview?view=azuresql)
- [Row Level Security](https://docs.microsoft.com/en-us/sql/relational-databases/security/row-level-security?view=sql-server-ver16)
- [Column Level Security](https://docs.microsoft.com/en-us/azure/synapse-analytics/sql-data-warehouse/column-level-security)
- [Dynamic Data Masking](https://docs.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-overview?view=azuresql)
- [Transparent Data Encryption](https://docs.microsoft.com/en-us/azure/azure-sql/database/transparent-data-encryption-tde-overview?view=azuresql&tabs=azure-portal)
- [Azure Synapse Analytics security white paper - Azure Synapse Analytics | Microsoft Learn](https://learn.microsoft.com/en-us/azure/synapse-analytics/guidance/security-white-paper-introduction)

## Tips

- In general, leverage Log Analytics Workspace when possible, for logging
- Use the `SQLAuditing.ksql` in the `/Challenge6/` folder of the student `Resources.zip` package.  This script will assist with audit queries.
- When configuring Alert for failed logins use Log Analytics Workspace "Custom Log Search" as a condition with a "Workspace" lens
- Vulnerability Assessment requires a storage account configured for activation
- Any users not accounted for in the row function will no longer be able to see the data which includes administrators
- Simulating data after each exercise or activation may be required to fulfill success criteria. i.e., Failed Logins

## Additional Challenges

- Setup Synapse with a [Private Virtual Network](https://techcommunity.microsoft.com/t5/azure-architecture-blog/understanding-azure-synapse-private-endpoints/ba-p/2281463)
- Setup Synapse with [Managed Virtual Network](https://docs.microsoft.com/en-us/azure/synapse-analytics/security/synapse-workspace-managed-vnet)

