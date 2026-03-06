# Challenge 01 - Build the Flink Data Pipeline - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

Students need to connect to the Apache Flink SQL editor in Confluent Cloud and create Flink tables mapped to existing Kafka topics.

- Students must create Flink tables for all six topics: `product_sku`, `product_pricing`, `product_departments`, `purchases`, `returns`, and `replenishments`
- The merge logic for `net_sales` should:
  - Add purchase amounts to the running total per SKU
  - Subtract return amounts from the running total per SKU
- The merge logic for `net_inventory_count` should:
  - Subtract purchase quantities from inventory per SKU
  - Add replenishment quantities to inventory per SKU
  - For returns: only add back to inventory if the product belongs to the appliance department; ignore returns from all other departments
- Reference Flink SQL solutions are available in the `Coach/Solutions/flink-sql` folder
- Common issues:
  - Students may forget to handle the appliance department return logic
  - Schema mismatches between Kafka topic schemas and Flink table definitions
  - Flink SQL statements must be running continuously; verify they are active in the Confluent Cloud UI
