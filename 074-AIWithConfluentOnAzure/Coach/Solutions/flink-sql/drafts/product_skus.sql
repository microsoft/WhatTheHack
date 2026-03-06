CREATE TABLE product_skus (
  id STRING,
  sku_id STRING,
  name STRING,
  description STRING,
  department STRING
) WITH (
  'changelog.mode' = 'append',
  'scan.startup.mode' = 'earliest-offset'
);