--- Set State TTL
SET 'sql.state-ttl' = '2 d'; 

INSERT INTO `departments_flat` 
SELECT `department` AS `row_key`, `department`, `description` FROM `departments`;


INSERT INTO `purchases_flat`
SELECT
  CAST(CAST(i.sku_id AS STRING) AS VARBINARY(2147483647)) AS key_column,
  p.customer_id,
  i.discounts,
  p.receipt_id,
  i.sku_id,
  p.transaction_date,
  i.unit_price,
  i.units
FROM `purchases` AS p
CROSS JOIN UNNEST(p.items) AS i (discounts, sku_id, unit_price, units);

INSERT INTO `returns_flat`
SELECT
  CAST(CAST(i.sku_id AS STRING) AS VARBINARY(2147483647)) AS key_column,
  r.customer_id,
  r.receipt_id,
  i.sku_id,
  r.transaction_date,
  i.unit_price,
  i.units
FROM `returns` AS r
CROSS JOIN UNNEST(r.items) AS i (sku_id, unit_price, units);

INSERT INTO `replenishments_flat`
SELECT
  CAST(CAST(r.sku_id AS STRING) AS VARBINARY(2147483647)) AS key_column,
  r.replenishment_id,
  r.sku_id,
  r.transaction_date,
  r.units,
  r.vendor_id
FROM `replenishments` AS r;

--- Available Units Computed from Cummulative replenishments, purchases and returns
INSERT INTO `product_inventory_depot`
SELECT
    ps.sku_id AS key_column,
    ps.department,
    ps.description,
    -- Available Units = Cummulative (Replenishments + Returns) - Purchases
    (IFNULL(SUM(rp.units), 0.00) + IFNULL(SUM(rt.units),0.00) - IFNULL(SUM(pc.units),0.00)) AS inventory_level,
    ps.name,
    ps.sku_id,
    pp.unit_price
FROM product_skus AS ps
INNER JOIN product_pricing AS pp
    ON ps.sku_id = pp.sku_id
INNER JOIN departments AS d
    ON ps.department = d.department
LEFT JOIN purchases_flat AS pc
    ON ps.sku_id = pc.sku_id
LEFT JOIN replenishments_flat AS rp
    ON ps.sku_id = rp.sku_id
LEFT JOIN returns_flat AS rt
    -- other departments besides the 'appliance' dept cannot be restocked into available inventory
    ON ps.sku_id = rt.sku_id AND ps.department = 'appliance' 
GROUP BY
    ps.sku_id,
    ps.name,
    pp.unit_price,
    ps.description,
    ps.department;


--- NET_SALES numbers computed from Cummulative Purchases minus Returns
INSERT INTO `net_sales_depot`
SELECT
    ps.sku_id AS key_column,
    ps.department,
    ps.name,
    -- Net Sales = (Purchases - Returns)
    (IFNULL(SUM(pc.units * pc.unit_price),0.00) - IFNULL(SUM(rt.units * rt.unit_price),0.00)) AS net_sales,
  ps.sku_id
FROM product_skus AS ps
INNER JOIN product_pricing AS pp
    ON ps.sku_id = pp.sku_id
INNER JOIN departments AS d
    ON ps.department = d.department
LEFT JOIN purchases_flat AS pc
    ON ps.sku_id = pc.sku_id
LEFT JOIN returns_flat AS rt
    ON ps.sku_id = rt.sku_id
GROUP BY
    ps.sku_id,
    ps.name,
    pp.unit_price,
    ps.description,
    ps.department;