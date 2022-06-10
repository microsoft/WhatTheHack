# Challenge 4: Create custom classifications - Coach Guide 

[< Previous Solution](./Solution3.md) - [Home](./README.md) - [Next Solution >](./Solution5.md)


## Introduction

Duration: 20 - 30 minutes. 

Pre-requisites: This challenge needs an Azure VM running SQL Server with the WideWorldImporters database restored (see previous challenge).
Instruct the attendees to use the WebsiteURL, PostalAddressLine1 columns from the [Sales].[Customers] table (also mentioned in the challenge) 
There may be multiple solutions for custom classification. The below example works very well.

- For WebsiteURL: (www|http:|https:)+[^\s]+[\w] 
- For PostalAddressLine1: ((PO Box).{0,}) 

If for some reason, some attendees do not have the WideWorldImporters database, you may want to ask them to use the CSV below. They will need to upload it to their Storage/ADLS account, create the custom classification and run a scan against the storage/ADLS account instead.

https://stpurviewfasthack.blob.core.windows.net/purviewfasthack/Sales.Customers.csv  

You may want to discuss approaches of how manual classifications can be done if it has not been covered already.
