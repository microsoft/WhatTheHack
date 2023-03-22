# Challenge 03 - Extracting Order Data Using AI Builder - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

- Power Platform is more than just Canvas Apps
- Strongly encourage creating a new solution for their development
- Create an Order table
   - Customer will be a 'Lookup' to Accounts/Contacts, or they could simply create a lookup to Accounts
   - Order code will use an autonumber type column
- Create an Order Line Item table
- Create 1-N relationship; Order to Order line

**NOTE:** If they are using a Dataverse that has Customer Engagement they will already have Order and Order Details tables

- In the flow, they will need a List Row - Dataverse step to lookup Accounts and add in the filter line:
    - accountnumber eq 'CustomerID' (customerID - dynamic value from AI Builder)
- Populating the 'Name' field for Order lines, it's required, tell them any field such as description
- Read email subject for "Order"
- Enhance with notifications
