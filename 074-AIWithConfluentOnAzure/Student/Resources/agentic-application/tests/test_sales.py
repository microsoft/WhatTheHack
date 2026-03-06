from contoso_retail_application import SearchDataAccessObject

sales = SearchDataAccessObject()

results = sales.get_net_sales()

print(results)


# This can be run as:
# uv run -m tests.test_sales