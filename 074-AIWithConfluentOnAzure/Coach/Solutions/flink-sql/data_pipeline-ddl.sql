

CREATE TABLE `product_inventory_depot` (
  `key` STRING NOT NULL,
  `department` STRING NOT NULL,
  `description` STRING NOT NULL,
  `inventory_level` DOUBLE NOT NULL,
  `name` STRING NOT NULL,
  `sku_id` STRING NOT NULL,
  `unit_price` DOUBLE NOT NULL,
   PRIMARY KEY (`key`) NOT ENFORCED 
)
DISTRIBUTED BY HASH(`key`) INTO 1 BUCKETS
WITH (
  'changelog.mode' = 'upsert',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.compaction.time' = '0 ms',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'key.format' = 'json-registry',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);


CREATE TABLE `net_sales_depot` (
  `key` STRING NOT NULL,
  `department` STRING NOT NULL COMMENT 'Department of the Product',
  `name` STRING NOT NULL COMMENT 'Name of the Product',
  `net_sales` DOUBLE NOT NULL COMMENT 'Net sales amount for the transaction.',
  `sku_id` STRING NOT NULL COMMENT 'Unique identifier for the stock keeping unit (SKU).',
  PRIMARY KEY (`key`) NOT ENFORCED
)
DISTRIBUTED BY HASH(`key`) INTO 1 BUCKETS
WITH (
  'changelog.mode' = 'upsert',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.compaction.time' = '0 ms',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'key.format' = 'json-registry',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);