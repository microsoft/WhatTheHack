# Challenge 03 - Extracting Order Data Using AI Builder - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

This is the only section you need to include.

Use general non-bulleted text for the beginning of a solution area for this challenge

- Prebuilt Invoice processing Model can extract majority of data on given Order Forms.
  Using the extracted Customer data on the form to find existing customer in the system, if not found, create a new customer record. 
- The outcome of AI Builder Model are texts. We need to convert data to appropriate type when creating a new record in Order and Order Line Item Table.
- In case, AI Builder Model cannot extract data from the form, design a Fall Back approach to log the failed run and send email alert/post on Team to Admin.![image]

Break things apart with more than one bullet list

- Like this
- One
- Right
- Here
