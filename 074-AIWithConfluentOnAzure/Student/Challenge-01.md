# Challenge 01 - Build the Flink Data Pipeline (Merge Streaming Data)

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

Welcome to the command center of a modern online grocery store. Every second, customers are buying, returning, and restocking items. Our goal is to build a real-time streaming pipeline that tracks every penny earned and every item in stock as it happens.

Using Apache Flink on Confluent Cloud, you'll merge multiple data streams (purchases, returns, pricing, departments, and replenishments) into two critical business metrics:

* `net_sales` - Real-time revenue tracking
* `net_inventory_count` - Live inventory levels

Every event streaming into Kafka will instantly update your business metrics in real-time.

## Description

During this challenge, you will:

- Connect to the Apache Flink SQL editor in Confluent Cloud
- Create Flink tables mapped to existing Kafka topics: `product_sku`, `product_pricing`, `product_departments`, `purchases`, `returns`, and `replenishments`
- Write Flink SQL merge logic that continuously updates the `net_sales` table and the `net_inventory_count` table

### Required Merging Logic

* Net Sales

  * Purchases add to the net sales total for each SKU.
  * Returns subtract from the net sales total for each SKU.

* Net Inventory Count

  * Purchases subtract from the inventory count.
  * Replenishments add to the inventory count.
  * Returns:

    * If the product belongs to the appliance department, returns add back to inventory.
    * Returns from all other departments are ignored (treated as perishable or damaged).


After your SQL statements are running, every new message streaming into Kafka should update:

* Net sales for the SKU
* Net inventory count for the SKU

in real time.

## Success Criteria

To complete this challenge successfully, you should be able to:

- Verify all Kafka topics listed above are mapped to Flink tables
- Verify Flink SQL merge statements for `net_sales` and `net_inventory_count` are created and running
- Verify sales and inventory values update continuously as new messages stream in
- Demonstrate logic behaves correctly:
  - Purchases increase net sales and decrease inventory
  - Replenishments increase inventory
  - Returns decrease net sales
  - Only appliance returns increase inventory count; all others are ignored

## Learning Resources

- [Apache Flink SQL documentation](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/overview/)
- [Confluent Cloud Flink quickstart](https://docs.confluent.io/cloud/current/flink/get-started/index.html)
- [Flink SQL merge and upsert concepts](https://nightlies.apache.org/flink/flink-docs-stable/docs/dev/table/sql/queries/insert/)

