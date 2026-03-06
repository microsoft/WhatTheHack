CREATE TABLE departments (
  `department` STRING,
  `description` STRING
) WITH (
  'changelog.mode' = 'append',
  'topic' = 'departments',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'key.format' = 'json-registry',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);

CREATE TABLE product_skus (
  id STRING,
  sku_id STRING,
  name STRING,
  description STRING,
  department STRING
) WITH (
    'changelog.mode' = 'append',
    'topic' = 'product_skus',
    'connector' = 'confluent',
    'kafka.cleanup-policy' = 'delete',
    'kafka.max-message-size' = '2097164 bytes',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '7 d',
    'key.format' = 'json-registry',
    'scan.bounded.mode' = 'unbounded',
    'scan.startup.mode' = 'earliest-offset',
    'value.format' = 'json-registry'
);

CREATE TABLE product_pricing (
  id STRING,
  sku_id STRING,
  unit_price DOUBLE
) WITH (
    'changelog.mode' = 'append',
    'topic' = 'product_pricing',
    'connector' = 'confluent',
    'kafka.cleanup-policy' = 'delete',
    'kafka.max-message-size' = '2097164 bytes',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '7 d',
    'key.format' = 'json-registry',
    'scan.bounded.mode' = 'unbounded',
    'scan.startup.mode' = 'earliest-offset',
    'value.format' = 'json-registry'
);

CREATE TABLE purchases (
  id STRING,
  receipt_id STRING,
  transaction_date STRING,
  customer_id STRING,
  items ARRAY<ROW<
    sku_id STRING,
    units DOUBLE,
    unit_price DOUBLE,
    discounts DOUBLE
  >>
) WITH (
  'changelog.mode' = 'append',
  'topic' = 'purchases',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'key.format' = 'json-registry',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);

CREATE TABLE returns (
  id STRING,
  return_id STRING,
  receipt_id STRING,
  transaction_date STRING,
  customer_id STRING,
  items ARRAY<ROW<
    sku_id STRING,
    units DOUBLE,
    unit_price DOUBLE
  >>
) WITH (
  'changelog.mode' = 'append',
  'topic' = 'returns',
  'connector' = 'confluent',
  'kafka.cleanup-policy' = 'delete',
  'kafka.max-message-size' = '2097164 bytes',
  'kafka.retention.size' = '0 bytes',
  'kafka.retention.time' = '7 d',
  'key.format' = 'json-registry',
  'scan.bounded.mode' = 'unbounded',
  'scan.startup.mode' = 'earliest-offset',
  'value.format' = 'json-registry'
);

CREATE TABLE replenishments (
  id STRING,
  replenishment_id STRING,
  transaction_date STRING,
  sku_id STRING,
  units DOUBLE,
  vendor_id STRING
) WITH (
    'changelog.mode' = 'append',
    'topic' = 'replenishments',
    'connector' = 'confluent',
    'kafka.cleanup-policy' = 'delete',
    'kafka.max-message-size' = '2097164 bytes',
    'kafka.retention.size' = '0 bytes',
    'kafka.retention.time' = '7 d',
    'key.format' = 'json-registry',
    'scan.bounded.mode' = 'unbounded',
    'scan.startup.mode' = 'earliest-offset',
    'value.format' = 'json-registry'
);