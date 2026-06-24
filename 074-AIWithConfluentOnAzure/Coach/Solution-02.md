# Challenge 02 - Supplier Experience - Coach's Guide 

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

Students interact with the supplier agent to query and replenish inventory.

- The supplier agent should display real-time inventory levels per SKU and per department
- When a student replenishes inventory, the change should be reflected in the `net_inventory_count` table and subsequently in Azure AI Search
- Verify students confirm that the AI agent retrieves updated values from MCP services after replenishment actions
- Common issues:
  - Delays in data propagation from Kafka through Flink to Azure AI Search; allow a few seconds for updates
  - If the agent returns stale data, check that the Flink SQL merge statements are running and the sink connector to Azure AI Search is active
