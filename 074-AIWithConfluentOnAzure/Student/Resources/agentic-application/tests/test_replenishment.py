from contoso_retail_application.data_access_objects import ReplenishmentDao

dao = ReplenishmentDao()

result = dao.replenish_sku(vendor_id="israel@a.io", sku_id="101", units=1.00)

print(result)


# This can be run as:
# uv run -m tests.test_replenishment