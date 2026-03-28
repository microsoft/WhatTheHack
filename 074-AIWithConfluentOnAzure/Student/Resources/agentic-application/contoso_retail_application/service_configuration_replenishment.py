from mcp.server import FastMCP

from contoso_retail_application import SearchDataAccessObject, Departments
from contoso_retail_application.data_access_objects import ReplenishmentDao
from contoso_retail_application.models import SkuId, ReplenishmentItem


def replenishment_service(host: str = "0.0.0.0", port: int = 8081):

    # Declare the MCP service
    replenishment_mcp = FastMCP(name="Replenishment Service", host=host, port=port)

    @replenishment_mcp.tool(description="Returns the replenishment levels for all SKUs")
    async def get_replenishment_levels():
        """Retrieve product replenishment levels for all SKUs.

        Returns:
            list[ReplenishmentLevel]: A list of `ReplenishmentLevel` objects.
        """
        dao = SearchDataAccessObject()
        return dao.get_replenishment_levels()

    @replenishment_mcp.tool(description="Returns the replenishment levels for all SKUs for the specified department")
    async def get_replenishment_levels_by_department(department: Departments):
        """Retrieve product replenishment levels filtered by department.

        Args:
            department (Departments): The department to filter by.

        Returns:
            list[ReplenishmentLevel]: A list of `ReplenishmentLevel` objects for the given department.
        """
        dao = SearchDataAccessObject()
        return dao.get_replenishment_levels_by_department(department=department)

    @replenishment_mcp.tool(description="Returns the replenishment level for the specified SKU identifier")
    async def get_replenishment_level_by_sku(sku_id: str):
        """Retrieve a single product replenishment level by SKU.

        Args:
            sku_id (str): The SKU identifier to filter on.

        Returns:
            ReplenishmentLevel | None: A `ReplenishmentLevel` object if found, otherwise None.
        """
        dao = SearchDataAccessObject()
        return dao.get_replenishment_level_by_sku(sku_id=sku_id)

    @replenishment_mcp.tool(description="Replenish the specified SKU identifier")
    async def replenish_sku(vendor_id: str, sku_id: SkuId, units: float) -> ReplenishmentItem:
        """Replenishes the SKU.

        Args:
            vendor_id (str): The vendor identifier.
            sku_id (SkuId): The SKU identifier to filter on.
            units (float): The number of units of the SKU to replenish.

        Returns:
            ReplenishmentItem | None: A `ReplenishmentItem` object if successful, otherwise None.
        """
        dao = ReplenishmentDao()
        return dao.replenish_sku(vendor_id=vendor_id, sku_id=sku_id, units=units)

    @replenishment_mcp.tool(description="Replenish all the SKUs for the specified department")
    async def replenish_department(vendor_id: str, department_id: Departments) ->list[ReplenishmentItem]:
        """Replenishes all the SKUs for the department.

        Args:
            vendor_id (str): The vendor identifier.
            department_id (Departments): The department to replenish

        Returns:
            list[ReplenishmentItem]: The items that have been replenished.
        """
        dao = ReplenishmentDao()
        return dao.replenish_department(vendor_id=vendor_id, department_id=department_id)


    return replenishment_mcp