
-- Flat table definitions for purchases, returns, and replenishments
CREATE TABLE `purchases_flat` (
  `key` VARBINARY(2147483647),
  `customer_id` VARCHAR(2147483647) NOT NULL COMMENT 'Unique identifier for the customer making the purchase.',
  `discounts` DOUBLE NOT NULL COMMENT 'Total discounts applied to the item.',
  `receipt_id` VARCHAR(2147483647) NOT NULL COMMENT 'Identifier associated with the transaction receipt.',
  `sku_id` VARCHAR(2147483647) NOT NULL COMMENT 'SKU identifier for the purchased item.',
  `transaction_date` VARCHAR(2147483647) NOT NULL COMMENT 'Date and time of the transaction in ''YYYY-MM-DD HH:MM:SS'' format.',
  `unit_price` DOUBLE NOT NULL COMMENT 'Price per unit of the item.',
  `units` DOUBLE NOT NULL COMMENT 'Number of units purchased.'
)
DISTRIBUTED BY HASH(`key`) INTO 1 BUCKETS
WITH (
  'changelog.mode' = 'append',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.compaction.time' = '0 ms',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'key.format' = 'raw',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);

CREATE TABLE `returns_flat` (
  `key` VARBINARY(2147483647),
  `customer_id` VARCHAR(2147483647) NOT NULL COMMENT 'Unique identifier for the customer making the return.',
  `receipt_id` VARCHAR(2147483647) NOT NULL COMMENT 'Identifier associated with the transaction receipt.',
  `sku_id` VARCHAR(2147483647) NOT NULL COMMENT 'SKU identifier for the returned item.',
  `transaction_date` VARCHAR(2147483647) NOT NULL COMMENT 'Date and time of the transaction in ''YYYY-MM-DD HH:MM:SS'' format.',
  `unit_price` DOUBLE NOT NULL COMMENT 'Price per unit of the item.',
  `units` DOUBLE NOT NULL COMMENT 'Number of units returns.'
)
DISTRIBUTED BY HASH(`key`) INTO 1 BUCKETS
WITH (
  'changelog.mode' = 'append',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.compaction.time' = '0 ms',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'key.format' = 'raw',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);

CREATE TABLE `replenishments_flat` (
  `key` VARBINARY(2147483647),
  `replenishment_id` VARCHAR(2147483647) NOT NULL COMMENT 'Identifier associated with the transaction receipt.',
  `sku_id` VARCHAR(2147483647) NOT NULL COMMENT 'SKU identifier for the returned item.',
  `transaction_date` VARCHAR(2147483647) NOT NULL COMMENT 'Date and time of the transaction in ''YYYY-MM-DD HH:MM:SS'' format.',
  `units` DOUBLE NOT NULL COMMENT 'Number of units returns.',
  `vendor_id` VARCHAR(2147483647) NOT NULL COMMENT 'Unique identifier for the customer making the return.'
)
DISTRIBUTED BY HASH(`key`) INTO 1 BUCKETS
WITH (
  'changelog.mode' = 'append',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.compaction.time' = '0 ms',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'key.format' = 'raw',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);

INSERT INTO `replenishments_flat`
SELECT
  r.sku_id AS `key`,
  r.replenishment_id,
  r.sku_id,
  r.transaction_date,
  r.units,
  r.vendor_id
FROM `replenishments` AS r;

INSERT INTO `purchases_flat`
SELECT
  i.sku_id, AS `key`,
  p.customer_id,
  i.discounts,
  p.receipt_id,
  i.sku_id,
  p.transaction_date,
  i.unit_price,
  i.units
FROM `purchases` AS p
CROSS JOIN UNNEST(p.items) AS i (sku_id, units, unit_price, discounts);

INSERT INTO `returns_flat`
SELECT
  i.sku_id, AS `key`,
  r.customer_id,
  r.receipt_id,
  i.sku_id,
  r.transaction_date,
  i.unit_price,
  i.units
FROM `returns` AS r
CROSS JOIN UNNEST(r.items) AS i (sku_id, units, unit_price);

