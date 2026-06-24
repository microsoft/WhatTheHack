# Challenge 04 - Employee Experience - Coach's Guide 

[< Previous Solution](./Solution-03.md) - **[Home](./README.md)**

## Notes & Guidance

Students use the employee agent to access comprehensive operational insights across all transactions.

- This challenge requires students to use multiple personas simultaneously (customer, supplier, and employee)
- The employee agent should display inventory levels, cumulative purchase/return/replenishment units, and net sales for any SKU
- Students should trigger events from customer and supplier agents and then verify the employee agent reflects those changes
- All data shown by the employee agent should match what is observed in Azure AI Search and Flink output
- Common issues:
  - Students may have difficulty managing multiple browser tabs or windows for different personas
  - If cumulative values are incorrect, verify the Flink SQL merge logic from Challenge 01 is running correctly
  - Ensure the sink connector is actively pushing updates to Azure AI Search
