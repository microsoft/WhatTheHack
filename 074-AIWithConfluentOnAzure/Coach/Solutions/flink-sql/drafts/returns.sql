-- Create a flattened view of the returns
CREATE TABLE `returns_flat` (
  customer_id STRING,
  receipt_id STRING,
  transaction_date VARCHAR(2147483647),
  sku_id STRING,
  units DOUBLE,
  unit_price DOUBLE
) WITH (
  'changelog.mode' = 'append',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.compaction.time' = '0 ms',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);

-- Insert into the returns_flat table
INSERT INTO `returns_flat`
SELECT
  r.customer_id,
  r.receipt_id,
  r.transaction_date,
  i.sku_id,
  i.units,
  i.unit_price
FROM `returns` AS r
CROSS JOIN UNNEST(r.items) AS i (sku_id, units, unit_price);