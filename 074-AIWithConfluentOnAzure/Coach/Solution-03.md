# Challenge 03 - Customer Experience - Coach's Guide 

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

Students simulate customer purchases and returns and observe real-time inventory and sales updates.

- Students should record inventory levels before and after purchases/returns to validate the pipeline
- After a purchase, inventory should decrease and net sales should increase
- After a return, net sales should decrease; inventory should only increase if the returned product belongs to the appliance department
- The three-second update window is a guideline; slight delays are acceptable but data should converge quickly
- Common issues:
  - Students may not observe updates if the sink connector to Azure AI Search has fallen behind
  - Remind students to check both the `net_sales` and `net_inventory_count` values after each action
