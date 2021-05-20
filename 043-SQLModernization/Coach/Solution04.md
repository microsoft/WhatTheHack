# Challenge 4: Security and Auditing - Coach's Guide

[< Previous Challenge](./Solution03.md) - **[Home](README.md)** - [Next Challenge>](./Solution05.md)

## Notes & Guidance

The purpose of this challenge is to get attendees hands-on with several security features on SQL Server. This is not meant to be exhaustive and inclusive of all best practices, but rather demonstrate how several features can be used together to provide a "defense in depth" model.

### Vulnerability Assessment & Threat Protection

An example of implementing this is [located in Microsoft SQL Workshop](https://github.com/microsoft/sqlworkshops-azuresqlworkshop/blob/master/azuresqlworkshop/03-Security.md). 

Once configured, you can test SQL Injection by opening a new connection to the database, adding something like "Application Name=testapp" to the Additional Connection Parameters dialog. Then, using that connection, execute a query such as:

```sql
SELECT * FROM sys.databases WHERE database_id like '' or 1 = 1 --' and family = 'test1';
```

The above should trigger an alert that will result in an email like this:

![Alert](./images/sqlinjection.png)

### Data Discovery & Classification

Most of this is straightforward and can be done in the portal, in SSMS, or via SQL and PowerShell. For green teams, using the portal is fine. However, for more advanced teams, encourage writing SQL directly as this can be added to a code repository and included in a data ops pipeline.

### Auditing

Log Analytics may take some time to begin adding auditing events. It's important to write logs to both blob storage and Log Analytics. The files in blob storage can be opened in SSMS and evaluated using the built-in dashboard.

### Dynamic Data Masking

Dynamic data masking is an easy way to add "defense in depth" measures to mask all or parts of a column -- for example, masking all but the last 4 of a social security number of credit card number. A call center agent or website, for example, would only "see" the last 4 digits for verification purposes. 

The example code block contains the TSQL needed to query sample rows, set up a mask, configure a test user, re-query the same rows to check for consistency, and optionally drop the mask if desired. (There is no reason to drop the mask, but providing the code here for how to do it.)

```sql

--example query
SELECT top 10 person.FirstName, person.LastName, phone.PhoneNumber
FROM Person.Person person
INNER JOIN Person.PersonPhone phone 
ON person.BusinessEntityID = phone.BusinessEntityID
WHERE person.LastName LIKE 'S%'
ORDER BY person.LastName ASC

--add mask
ALTER TABLE Person.PersonPhone
ALTER COLUMN PhoneNumber ADD MASKED WITH (FUNCTION = 'partial(0,"x",5)');

--create a user to test
CREATE USER TestUser WITHOUT LOGIN;  
GRANT SELECT ON Person.Person TO TestUser;  
GRANT SELECT ON Person.PersonPhone TO TestUser;  

EXECUTE AS USER = 'TestUser';
SELECT top 10 person.FirstName, person.LastName, phone.PhoneNumber
FROM Person.Person person
INNER JOIN Person.PersonPhone phone 
ON person.BusinessEntityID = phone.BusinessEntityID
WHERE person.LastName LIKE 'S%'
ORDER BY person.LastName ASC
REVERT;

--drop mask if needed
ALTER TABLE Person.PersonPhone
ALTER COLUMN PhoneNumber DROP MASKED;

```

Dynamic data masking doesn't protect the underlying data or encrypt it in any way. The permissions are applied via an UNMASK permission. There are weaknesses to using data masking: for example, if a user has ad-hoc query permissions and the column in question is a "salary" value, the user can use search predicates to filter the results -- for example, WHERE Table.Salary > 100000 and Table.Salary < 1100000. The results may still be masked, but it would be trivial to write a query to self-join the table into salary buckets, for example. Therefore, while a useful features, it is considered a "defense in depth" measure best used in conjunction with other best practices.

For the advanced challenge on Data Masking, consider the following script:

```sql

-- example query
SELECT TOP 20 * from HumanResources.EmployeePayHistory
ORDER BY BusinessEntityID ASC

-- add permission to table
GRANT SELECT ON HumanResources.EmployeePayHistory TO TestUser;  

-- add mask
ALTER TABLE HumanResources.EmployeePayHistory
ALTER COLUMN Rate ADD MASKED WITH (FUNCTION = 'default()');

-- query w mask -- observe the 'RateBucket' 
EXECUTE AS USER = 'TestUser';
SELECT TOP 20 *, 
    CASE 
        WHEN Rate > 100 THEN '>100'
        WHEN Rate > 50 THEN '>50'
        ELSE '<50'
    END AS RateBucket
    FROM HumanResources.EmployeePayHistory
ORDER BY BusinessEntityID ASC
REVERT;

```