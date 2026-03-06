-- Create a flattened view of the purchases

CREATE TABLE `purchases_flat` (
  customer_id STRING,
  receipt_id STRING,
  transaction_date VARCHAR(2147483647),
  sku_id STRING,
  units DOUBLE NOT NULL,
  unit_price DOUBLE,
  discounts DOUBLE
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

-- Insert into the purchases_flat table

INSERT INTO `purchases_flat`
SELECT
  p.customer_id,
  p.receipt_id,
  p.transaction_date,
  i.sku_id,
  i.units,
  i.unit_price,
  i.discounts
FROM purchases AS p
CROSS JOIN UNNEST(p.items) AS i (sku_id, units, unit_price, discounts);