import os
from datetime import datetime
from typing import Any
from zoneinfo import ZoneInfo

from azure_datastore_utils import SearchClientDao, RedisUtil, CosmosDBUtils

from .models import NetSales, Departments, Department, ProductInventory, ReplenishmentLevel, DepartmentInventoryConfig
from .models import PurchaseCart, SkuId, PurchaseItem, ReturnCart, ReturnItem, Purchase
from .models import ReturnTransaction, ReplenishmentItem


class SearchDataAccessObject:
    """Data Access Object (DAO) for querying Azure Cognitive Search indexes.

    This class provides methods to interact with different indexes
    such as net sales, product inventory, and departments. It uses
    `SearchClientDao` to query Azure Cognitive Search indexes and
    maps the results into domain models (e.g., `NetSales`,
    `Department`, `ProductInventory`).
    """

    def __init__(self):
        """Initialize the DAO with index names for sales, inventory, and departments."""
        self.sales_index = "net_sales"
        self.inventory_index = "product_inventory"
        self.department_index = "departments_flat"

    def get_departments(self):
        """Retrieve all departments from the search index.

        Returns:
            list[Department]: A list of `Department` objects.
        """
        search_client = SearchClientDao(self.department_index)

        search_text = "*"
        sort_order: list[str] = ["department asc"]

        query_results = search_client.query_index(search_text=search_text, order_by=sort_order)

        search_results: list[Department] = []

        for search_item in query_results:
            current_item = Department.from_dict(search_item)
            search_results.append(current_item)

        return search_results

    def get_net_sales(self, max_count: int = 250):
        """Retrieves the net sales records from the data store.

        Args:
            max_count (int, optional): Maximum number of records to return. Defaults to 250.

        Returns:
            list[NetSales]: A list of `NetSales` objects sorted by department and SKU.
        """
        # set up search client
        search_client = SearchClientDao(self.sales_index)

        search_text = "*"
        sort_order: list[str] = ["department asc", "sku_id asc"]

        query_results = search_client.query_index(search_text=search_text, order_by=sort_order, top=max_count)

        search_results: list[NetSales] = []

        for search_item in query_results:
            current_item = NetSales.from_dict(search_item)
            search_results.append(current_item)

        return search_results

    def get_net_sales_by_sku(self, sku_id: str):
        """Retrieve a single net sales record by SKU.

        Args:
            sku_id (str): The SKU identifier to filter on.

        Returns:
            NetSales | None: A `NetSales` object if found, otherwise None.
        """
        # set up search client
        search_client = SearchClientDao(self.sales_index)

        search_text = "*"
        query_filter = f"sku_id eq '{sku_id}'"

        query_results = search_client.query_index(search_text=search_text, query_filter=query_filter,
                                                  include_total_count=True)

        for search_item in query_results:
            current_item = NetSales.from_dict(search_item)
            return current_item

        return None

    def get_net_sales_by_department(self, department: Departments, max_count: int = 250):
        """Retrieve net sales records filtered by department.

        Args:
            department (Departments): The department to filter by.
            max_count (int, optional): Maximum number of records to return. Defaults to 250.

        Returns:
            list[NetSales]: A list of `NetSales` objects for the given department.
        """
        search_client = SearchClientDao(self.sales_index)

        search_text = "*"
        query_filter = f"department eq '{department}'"
        sort_order: list[str] = ["sku_id asc"]

        query_results = search_client.query_index(search_text=search_text, order_by=sort_order,
                                                  query_filter=query_filter, top=max_count)

        search_results: list[NetSales] = []

        for search_item in query_results:
            current_item = NetSales.from_dict(search_item)
            search_results.append(current_item)

        return search_results

    def get_inventory_levels(self, max_count: int = 250):
        """Retrieve product inventory levels from the search index.

        Args:
            max_count (int, optional): Maximum number of records to return. Defaults to 250.

        Returns:
            list[ProductInventory]: A list of `ProductInventory` objects.
        """
        search_client = SearchClientDao(self.inventory_index)

        search_text = "*"
        sort_order: list[str] = ["department asc", "sku_id asc"]

        query_results = search_client.query_index(search_text=search_text, order_by=sort_order, top=max_count)

        search_results: list[ProductInventory] = []

        for search_item in query_results:
            current_item = ProductInventory.from_dict(search_item)
            search_results.append(current_item)

        return search_results

    def get_inventory_levels_by_department(self, department: Departments, max_count: int = 250):
        """Retrieve product inventory levels filtered by department.

        Args:
            department (Departments): The department to filter by.
            max_count (int, optional): Maximum number of records to return. Defaults to 250.

        Returns:
            list[ProductInventory]: A list of `ProductInventory` objects for the given department.
        """
        search_client = SearchClientDao(self.inventory_index)

        search_text = "*"
        query_filter = f"department eq '{department}'"
        sort_order: list[str] = ["sku_id asc"]

        query_results = search_client.query_index(search_text=search_text, order_by=sort_order,
                                                  query_filter=query_filter, top=max_count)

        search_results: list[ProductInventory] = []

        for search_item in query_results:
            current_item = ProductInventory.from_dict(search_item)
            search_results.append(current_item)

        return search_results

    def get_inventory_levels_by_sku(self, sku_id: str):
        """Retrieve a single product inventory record by SKU.

        Args:
            sku_id (str): The SKU identifier to filter on.

        Returns:
            ProductInventory | None: A `ProductInventory` object if found, otherwise None.
        """
        search_client = SearchClientDao(self.inventory_index)

        search_text = "*"
        query_filter = f"sku_id eq '{sku_id}'"

        query_results = search_client.query_index(search_text=search_text, query_filter=query_filter)

        for search_item in query_results:
            current_item = ProductInventory.from_dict(search_item)
            return current_item

        return None

    def get_replenishment_levels(self, max_count: int = 250):
        """Retrieve product replenishment levels for all SKUs.

        Args:
            max_count (int, optional): Maximum number of records to return. Defaults to 250.

        Returns:
            list[ReplenishmentLevel]: A list of `ReplenishmentLevel` objects.
        """

        config_db = DepartmentInventoryConfig()
        items = self.get_inventory_levels(max_count=max_count)

        results: list[ReplenishmentLevel] = []
        for current_sku in items:
            current_sku_level = ReplenishmentLevel.from_product_inventory(current_sku, config_database=config_db)
            results.append(current_sku_level)

        return results

    def get_replenishment_levels_by_department(self, department: Departments, max_count: int = 250):
        """Retrieve product replenishment levels filtered by department.

        Args:
            department (Departments): The department to filter by.
            max_count (int, optional): Maximum number of records to return. Defaults to 250.

        Returns:
            list[ReplenishmentLevel]: A list of `ReplenishmentLevel` objects for the given department.
        """

        config_db = DepartmentInventoryConfig()
        items = self.get_inventory_levels_by_department(department=department, max_count=max_count)

        results: list[ReplenishmentLevel] = []
        for current_sku in items:
            current_sku_level = ReplenishmentLevel.from_product_inventory(current_sku, config_database=config_db)
            results.append(current_sku_level)

        return results

    def get_replenishment_level_by_sku(self, sku_id: str):
        """Retrieve a single product replenishment level by SKU.

        Args:
            sku_id (str): The SKU identifier to filter on.

        Returns:
            ReplenishmentLevel | None: A `ReplenishmentLevel` object if found, otherwise None.
        """

        config_db = DepartmentInventoryConfig()
        item = self.get_inventory_levels_by_sku(sku_id=sku_id)

        if item is not None:
            return ReplenishmentLevel.from_product_inventory(item, config_database=config_db)

        return None


class CartManager:
    CART_KEY_PURCHASES = "purchase_cart_"
    CART_KEY_RETURNS = "return_cart_"
    CART_KEY_REPLENISHMENTS = "replenishment_cart_"

    INITIAL_CART_ID_PURCHASES = 600000
    INITIAL_CART_ID_RETURNS = 700000
    INITIAL_CART_ID_REPLENISHMENTS = 800000

    def __init__(self):
        self.redis_client = RedisUtil()

    @staticmethod
    def get_lookup_key(prefix: str, look_up_key: str):
        return f"{prefix}{look_up_key}"

    @staticmethod
    def get_lookup_key_purchases(look_up_key: str):
        return CartManager.get_lookup_key(CartManager.CART_KEY_PURCHASES, look_up_key)

    @staticmethod
    def get_lookup_key_returns(look_up_key: str):
        return CartManager.get_lookup_key(CartManager.CART_KEY_RETURNS, look_up_key)

    @staticmethod
    def get_lookup_key_replenishments(look_up_key: str):
        return CartManager.get_lookup_key(CartManager.CART_KEY_REPLENISHMENTS, look_up_key)

    def __get_cart_id(self, lookup_key: str, initial_value: int):
        id_exists: bool = self.redis_client.exists(lookup_key)
        if not id_exists:
            return self.redis_client.increment(lookup_key, initial_value)
        return self.redis_client.increment(lookup_key, 1)

    def get_cart_id_purchases(self):
        return self.__get_cart_id(CartManager.CART_KEY_PURCHASES, CartManager.INITIAL_CART_ID_PURCHASES)

    def get_cart_id_returns(self):
        return self.__get_cart_id(CartManager.CART_KEY_RETURNS, CartManager.INITIAL_CART_ID_RETURNS)

    def get_cart_id_replenishments(self):
        return self.__get_cart_id(CartManager.CART_KEY_REPLENISHMENTS, CartManager.INITIAL_CART_ID_REPLENISHMENTS)

    def generate_new_cart_purchases(self,  customer_id: str)->PurchaseCart:
        purchase_cart_id:int = self.get_cart_id_purchases()
        return self.create_cart_purchases(cart_identifier=str(purchase_cart_id), customer_id=customer_id)

    def create_cart_purchases(self, cart_identifier: str, customer_id: str) -> PurchaseCart:
        cart = PurchaseCart(cart_id=cart_identifier, customer_id=customer_id, items={})
        cart_entry = cart.model_dump()

        look_up_key = CartManager.get_lookup_key_purchases(cart_identifier)
        self.redis_client.set_json(look_up_key, cart_entry)
        return cart

    def get_cart_purchases(self, cart_identifier: str):
        look_up_key = CartManager.get_lookup_key_purchases(cart_identifier)
        item = self.redis_client.get_json(look_up_key)
        cart = PurchaseCart.from_dict(item)
        return cart

    def add_cart_item_purchases(self, cart_identifier: str, sku_id: SkuId, quantity: float):
        look_up_key = CartManager.get_lookup_key_purchases(cart_identifier)
        item = self.redis_client.get_json(look_up_key)

        purchase_item = PurchaseItem(sku_id=sku_id, units=quantity, unit_price=0.00, discounts=0.00)
        cart = PurchaseCart.from_dict(item)

        cart.add_item(purchase_item)
        self.redis_client.set_json(look_up_key, cart.model_dump())
        return cart

    def remove_cart_item_purchases(self, cart_identifier: str, sku_id: SkuId):
        look_up_key = CartManager.get_lookup_key_purchases(cart_identifier)
        item = self.redis_client.get_json(look_up_key)

        cart = PurchaseCart.from_dict(item)
        cart.remove_item(sku_id=sku_id)
        self.redis_client.set_json(look_up_key, cart.model_dump())
        return cart

    def generate_new_cart_returns(self, receipt_id: str, customer_id: str) -> ReturnCart:
        return_cart_id:int = self.get_cart_id_returns()
        return self.create_cart_returns(cart_identifier=str(return_cart_id), receipt_id=receipt_id, customer_id=customer_id)

    def create_cart_returns(self, cart_identifier: str, receipt_id: str, customer_id: str) -> ReturnCart:
        cart = ReturnCart(cart_id=cart_identifier, receipt_id=receipt_id, customer_id=customer_id, items={})
        cart_entry = cart.model_dump()

        look_up_key = CartManager.get_lookup_key_returns(cart_identifier)
        self.redis_client.set_json(look_up_key, cart_entry)
        return cart

    def add_cart_item_returns(self, cart_identifier: str, sku_id: SkuId, quantity: float):
        look_up_key = CartManager.get_lookup_key_returns(cart_identifier)
        item = self.redis_client.get_json(look_up_key)

        return_item = ReturnItem(sku_id=sku_id, units=quantity, unit_price=0.00)
        cart = ReturnCart.from_dict(item)

        cart.add_item(return_item)
        self.redis_client.set_json(look_up_key, cart.model_dump())
        return cart

    def remove_cart_item_returns(self, cart_identifier: str, sku_id: SkuId):
        look_up_key = CartManager.get_lookup_key_returns(cart_identifier)
        item = self.redis_client.get_json(look_up_key)

        cart = ReturnCart.from_dict(item)
        cart.remove_item(sku_id=sku_id)
        self.redis_client.set_json(look_up_key, cart.model_dump())
        return cart

    def get_cart_returns(self, cart_identifier: str):
        look_up_key = CartManager.get_lookup_key_returns(cart_identifier)
        item = self.redis_client.get_json(look_up_key)
        cart = ReturnCart.from_dict(item)
        return cart


class ReturnsDao:

    def __init__(self):
        database_name = os.environ.get("COSMOS_DATABASE_NAME")
        collection = "returns"
        self.client = CosmosDBUtils(database_name=database_name, collection=collection)
        self.search_client = SearchDataAccessObject()
        self.cart_manager = CartManager()

    def is_receipt_previously_processed(self, receipt_id: str) -> bool:

        retrieval_sql = "SELECT * FROM c WHERE c.receipt_id = @receipt_id"
        query_parameters = [{"name": "@receipt_id", "value": receipt_id}]
        items = self.client.query_container(query=retrieval_sql, parameters=query_parameters, enable_cross_partition_query=True)
        for retrieved_item in items:
            if retrieved_item is not None:
                return True
        return False

    def get_active_return_skus(self, cart_id: str):
        active_return = self.get_cart(cart_identifier=cart_id)
        existing_skus: list[SkuId] = []
        for cart_item in active_return.items:
            existing_skus.append(cart_item.sku_id)
        return existing_skus

    def get_existing_return(self, return_id: str, customer_id: str) -> ReturnTransaction | None:
        record_id = return_id
        retrieved_record: dict[str, Any] = self.client.get_single_item(item_id=record_id, partition_key=customer_id)
        if retrieved_record is not None:
            return_record: ReturnTransaction = ReturnTransaction.from_dict(retrieved_record)
            return return_record
        return None

    def generate_new_cart(self, receipt_id: str, customer_id: str):
        return self.cart_manager.generate_new_cart_returns(receipt_id=receipt_id, customer_id=customer_id)

    def create_cart(self, cart_identifier: str, receipt_id: str, customer_id: str):
        return self.cart_manager.create_cart_returns(cart_identifier, receipt_id=receipt_id, customer_id=customer_id)

    def add_item(self, cart_identifier: str, sku_id: SkuId, quantity: float):
        return self.cart_manager.add_cart_item_returns(cart_identifier=cart_identifier, sku_id=sku_id, quantity=quantity)

    def remove_item(self, cart_identifier: str, sku_id: SkuId):
        return self.cart_manager.remove_cart_item_returns(cart_identifier=cart_identifier, sku_id=sku_id)

    def get_cart(self, cart_identifier: str):
        cart = self.cart_manager.get_cart_returns(cart_identifier=cart_identifier)

        current_datetime_original: datetime = datetime.now(ZoneInfo("America/New_York"))
        current_datetime: str = current_datetime_original.isoformat(timespec="seconds").replace("T", " ")

        return_record = ReturnTransaction(id=cart_identifier, return_id=cart_identifier, receipt_id=cart_identifier, transaction_date=current_datetime, customer_id=cart.customer_id, items=[])

        for key, value in cart.items.items():
            sku_id: SkuId = key
            cart_item: ReturnItem = value
            v = self.search_client.get_inventory_levels_by_sku(sku_id=sku_id)
            return_item = ReturnItem(sku_id=sku_id, units=cart_item.units, unit_price=v.unit_price)
            return_record.items.append(return_item)

        return return_record

    def submit_cart(self, cart_identifier: str):
        return_record = self.get_cart(cart_identifier=cart_identifier)
        record = return_record.model_dump()

        self.client.upsert_item(record)
        return return_record


class PurchasesDao:

    def __init__(self):
        database_name = os.environ.get("COSMOS_DATABASE_NAME")
        collection = "purchases"
        self.client = CosmosDBUtils(database_name=database_name, collection=collection)
        self.search_client = SearchDataAccessObject()
        self.cart_manager = CartManager()

    def get_existing_purchase_sku_quentity(self, receipt_id: str, customer_id: str, sku_id: SkuId) -> float:
        existing_purchase = self.get_existing_purchase(receipt_id=receipt_id, customer_id=customer_id)
        if existing_purchase is None:
            return 0.00
        for purchase_item in existing_purchase.items:
            if purchase_item.sku_id == sku_id:
                return purchase_item.units
        return 0.00

    def get_existing_purchase_skus(self, receipt_id: str, customer_id: str):
        existing_purchase = self.get_existing_purchase(receipt_id=receipt_id, customer_id=customer_id)
        existing_skus: list[SkuId] = []

        if existing_purchase is None:
            return existing_skus

        for purchase_item in existing_purchase.items:
            existing_skus.append(purchase_item.sku_id)
        return existing_skus

    def get_existing_purchase(self, receipt_id: str, customer_id: str) -> Purchase | None:
        record_id = receipt_id
        retrieved_record: dict[str, Any] = self.client.get_single_item(item_id=record_id, partition_key=customer_id)
        if retrieved_record is not None:
            purchase: Purchase = Purchase.from_dict(retrieved_record)
            return purchase
        return None

    def generate_new_cart(self, customer_id: str):
        return self.cart_manager.generate_new_cart_purchases(customer_id=customer_id)

    def create_cart(self, cart_identifier: str, customer_id: str):
        return self.cart_manager.create_cart_purchases(cart_identifier, customer_id=customer_id)

    def add_item(self, cart_identifier: str, sku_id: SkuId, quantity: float):
        self.cart_manager.add_cart_item_purchases(cart_identifier=cart_identifier, sku_id=sku_id, quantity=quantity)

    def remove_item(self, cart_identifier: str, sku_id: SkuId):
        self.cart_manager.remove_cart_item_purchases(cart_identifier=cart_identifier, sku_id=sku_id)

    def get_cart(self, cart_identifier: str):
        cart = self.cart_manager.get_cart_purchases(cart_identifier=cart_identifier)

        current_datetime_original: datetime = datetime.now(ZoneInfo("America/New_York"))
        current_datetime: str = current_datetime_original.isoformat(timespec="seconds").replace("T", " ")

        purchase = Purchase(id=cart_identifier, receipt_id=cart_identifier,
                            transaction_date=current_datetime, customer_id=cart.customer_id, items=[])
        for key, value in cart.items.items():
            sku_id: SkuId = key
            cart_item: PurchaseItem = value
            v = self.search_client.get_inventory_levels_by_sku(sku_id=sku_id)
            purchase_item = PurchaseItem(sku_id=sku_id, units=cart_item.units, unit_price=v.unit_price, discounts=0)
            purchase.items.append(purchase_item)

        return purchase

    def submit_cart(self, cart_identifier: str):
        purchase: Purchase = self.get_cart(cart_identifier=cart_identifier)
        record = purchase.model_dump()

        self.client.upsert_item(record)
        return purchase


class ReplenishmentDao:

    def __init__(self):
        database_name = os.environ.get("COSMOS_DATABASE_NAME")
        collection = "replenishments"
        self.client = CosmosDBUtils(database_name=database_name, collection=collection)
        self.search_client = SearchDataAccessObject()
        self.cart_manager = CartManager()

    def replenish_sku(self, vendor_id: str, sku_id: SkuId, units: float) -> ReplenishmentItem:
        current_datetime_original: datetime = datetime.now(ZoneInfo("America/New_York"))
        current_datetime: str = current_datetime_original.isoformat(timespec="seconds").replace("T", " ")

        cart_id: int = self.cart_manager.get_cart_id_replenishments()
        cart_identifier: str = str(cart_id)

        replenishment_item = ReplenishmentItem(id=cart_identifier, replenishment_id=cart_identifier,
                                               transaction_date=current_datetime, sku_id=sku_id,
                                               units=units, vendor_id=vendor_id)
        record = replenishment_item.model_dump()

        self.client.upsert_item(record)
        return replenishment_item

    def replenish_department(self, department_id: Departments, vendor_id: str):

        replenishment_results: list[ReplenishmentItem] = []
        dept_replenishment_levels: list[ReplenishmentLevel] = self.search_client.get_replenishment_levels_by_department(
            department=department_id)

        for sku_replenishment_level in dept_replenishment_levels:
            # This is the current SKU
            current_sku_id: SkuId = sku_replenishment_level.sku_id
            # This is the Maximum Inventory Level for the SKU
            maximum_inventory_level: float = sku_replenishment_level.sku_mil
            # The current inventory level for the SKU
            current_inventory_level: float = sku_replenishment_level.inventory_level
            # How many units we need for replenishment
            replenishment_units: float = maximum_inventory_level - current_inventory_level

            if sku_replenishment_level.needs_replenishment:
                repl_item = self.replenish_sku(vendor_id=vendor_id, sku_id=current_sku_id, units=replenishment_units)
                replenishment_results.append(repl_item)

        return replenishment_results
