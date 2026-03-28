-- Create a flattened view of the replenishments
CREATE TABLE `replenishments_flat` (
  replenishment_id STRING,
  vendor_id STRING,
  transaction_date VARCHAR(2147483647),
  sku_id STRING,
  units DOUBLE
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

-- Insert into the replenishments_flat table
INSERT INTO `replenishments_flat`
SELECT
  r.replenishment_id,
  r.vendor_id,
  r.transaction_date,
  r.sku_id,
  r.units
FROM `replenishments` AS r;