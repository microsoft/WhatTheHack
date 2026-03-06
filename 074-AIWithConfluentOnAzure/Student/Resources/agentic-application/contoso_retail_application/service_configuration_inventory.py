from mcp.server import FastMCP

from . import Department
from . import SearchDataAccessObject
from . import NetSales, ProductInventory, Departments


def inventory_service(host: str = "0.0.0.0", port: int = 8080):

    # Declare the MCP service
    product_mcp = FastMCP(name="Inventory Service", host=host, port=port)

    @product_mcp.tool(description="Returns a list of all the departments")
    async def get_departments() -> list[Department]:
        """Retrieve all departments from the database.

        Returns:
            list[Department]: A list of `Department` objects.
        """
        dao = SearchDataAccessObject()
        return dao.get_departments()

    @product_mcp.tool(description="Retrieves the net sales for all the product SKUs")
    async def get_net_sales() -> list[NetSales]:
        """Retrieves the net sales records from the database.

        Returns:
            list[NetSales]: A list of `NetSales` objects sorted by department and SKU.
        """
        dao = SearchDataAccessObject()
        return dao.get_net_sales()

    @product_mcp.tool(description="Retrieves the net sales amount for a specific SKU")
    async def get_net_sales_by_sku(sku_id: str) -> NetSales:
        """Retrieve a single net sales record by SKU.

        Args:
            sku_id (str): The SKU identifier to filter on.

        Returns:
            NetSales | None: A `NetSales` object if found, otherwise None.
        """
        dao = SearchDataAccessObject()
        return dao.get_net_sales_by_sku(sku_id=sku_id)

    @product_mcp.tool(description="Retrieves net sales for all the SKUs for the specified department")
    async def get_net_sales_by_department(department: Departments):
        """Retrieve net sales records filtered by department.

        Args:
            department (Departments): The department to filter by.

        Returns:
            list[NetSales]: A list of `NetSales` objects for the given department.
        """
        dao = SearchDataAccessObject()
        return dao.get_net_sales_by_department(department=department)

    @product_mcp.tool(description="Retrieves the inventory level for all the product SKUs")
    async def get_inventory_levels() -> list[ProductInventory]:
        """Retrieve product inventory levels from the database.

        Returns:
            list[ProductInventory]: A list of `ProductInventory` objects.
        """
        dao = SearchDataAccessObject()
        return dao.get_inventory_levels()

    @product_mcp.tool(description="Retrieves the inventory level for product SKUs in the specified department")
    async def get_inventory_levels_by_department(department: Departments):
        """Retrieve product inventory levels filtered by department.

        Args:
            department (Departments): The department to filter by.

        Returns:
            list[ProductInventory]: A list of `ProductInventory` objects for the given department.
        """
        dao = SearchDataAccessObject()
        return dao.get_inventory_levels_by_department(department=department)

    @product_mcp.tool(description="Retrieves the inventory level for the specific product SKU")
    async def get_inventory_level_by_sku(sku_id: str):
        """Retrieve a single product inventory record by SKU.

        Args:
            sku_id (str): The SKU identifier to filter on.

        Returns:
            ProductInventory | None: A `ProductInventory` object if found, otherwise None.
        """
        dao = SearchDataAccessObject()
        return dao.get_inventory_levels_by_sku(sku_id=sku_id)



    return product_mcp