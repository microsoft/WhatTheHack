# Challenge 3 - Performance

[< Previous Challenge](./Challenge02.md) - **[Home](../../README.md)** - [Next Challenge>](./Challenge04.md)

## Introduction 

Although SQL Server is easier than ever to deploy with Azure SQL Database, containers, and VMs, knowing how to properly use the monitoring and evaluation tools, like Query Store, can make a difference between an application that simply "performs ok" to one that "flies."  While SQL Server has evolved with features over the years, it's a good idea to understand how these changes might impact an application.

## Description

The purpose of this challenge is threefold:
1. Explore new features of SQL Server that may improve performance intrinsically
1. Ensure would-be data engineers and DBAs are comfortable evaluating performance 
1. Leverage newer tools like Azure Data Explorer and Notebooks

### Explore new features

To begin, download and open the [Intelligent Query Processing notebook](./assets/SQLWTH_Challenge3_IntelligentQueryProcessing.ipynb) using Azure Data Studio or another tool of your choice that can work with a standard Jupyter Notebook. The Notebook will walk you through the test, comparing performance of an analytical query using compatability mode 130 vs 150.

While it's clear the SQL Server 2019 version performs better, the challenge is to understand why. Leverage Query Store to evaluate the differences in performance and execution plans.  


### Understand key blockers

There's a saying, "If you can't measure it, you can't improve it." Perhaps for code optimizations, it's more accurate to say, "To effectively improve something, you begin by measuring it." Looking at the execution plan is a key way to understand how a query is parsed and executed so that changes can be intentional and evaluated. This part of the challenge involves understanding the indexing and reading the execution plan. While altering a table and its indexes to improve a query may harm another query, the goal is to find the appropriate tradeoffs.

The WWI team powers a dashboard that uses a query similar to the below to track current invoices for a given day. Execute and evaluate its execution plan. 

```sql
SELECT InvoiceId, CustomerId, TotalChillerItems, TotalDryItems, ConfirmedDeliveryTime
FROM Sales.Invoices
WHERE ConfirmedDeliveryTime BETWEEN '2016-01-07 00:00:00.000' AND '2016-01-07 23:59:59.998'
ORDER BY ConfirmedDeliveryTime DESC
```

## Success Criteria

1. Explore new features: Evaluate the difference in performance using the Notebook referenced above, comparing the execution plan differences by using Query Store. What specifically accounts for the difference? Show the execution plans to your coach and explain why they different.
1. Understand key blockers: Evaluate the execution plan using the query above. Where is the time spent in the query and why? How can it be improved? Once evaluated, explain the problem and show the data that illustrates the improvements.

## Learning Resources

* [Azure SQL Fundamentals](https://aka.ms/azuresqlfundamentals)
* [SQL Server Compatability Levels](https://docs.microsoft.com/en-us/sql/t-sql/statements/alter-database-transact-sql-compatibility-level?view=sql-server-ver15)
* [Administering Relational Databases Exam](https://docs.microsoft.com/en-us/learn/certifications/exams/dp-300)

## Tips

* If you are able to evaluate and see what how the plans are different but not sure why, read up on [Intelligent Query Processing](https://docs.microsoft.com/en-us/sql/relational-databases/performance/intelligent-query-processing?view=sql-server-ver15); cross reference your observations with the details in the document
* Look at the [Azure SQL Database tips](https://github.com/microsoft/azure-sql-tips/wiki/Azure-SQL-Database-tips) for examples of checking best practices.
* Want more hands-on material? Check out the [Microsoft Ground-to-Cloud](https://github.com/microsoft/sqlworkshops-sqlg2c/blob/master/README.md) series.

