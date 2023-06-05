# Challenge 02 - Handling Incoming Orders- Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

- Prebuilt Invoice processing Model can extract majority of data on given Order Forms.
- Using the extracted Customer data on the form to find existing customer in the system, if not found, create a new customer record. Easier solution may be to create the account records in the Account table in dataverse
- The outcome of AI Builder Model is text. We need to convert data to appropriate type when creating a new record in Order and Order Line Item Table.
- In case AI Builder Model cannot extract data from the form, design a Fall Back approach to log the failed run and send email alert/post on Teams to Admin.
