import json
from typing import Mapping, Any, Self, Literal, Union, List

from pydantic import BaseModel, Field
from .utils import base64_encode

Departments = Literal["appliance", "cleaning", "dairy", "deli", "meat", "pharmacy", "produce", "seafood"]

ApplianceId = Literal[
    "101", "102", "103", "104", "105",
    "106", "107", "108", "109", "110",
    "111", "112", "113", "114", "115",
    "116", "117", "118", "119", "120",
    "121", "122", "123", "124", "125",
]

CleaningId = Literal[
    "201", "202", "203", "204", "205",
    "206", "207", "208", "209", "210",
    "211", "212", "213", "214", "215",
    "216", "217", "218", "219", "220",
    "221", "222", "223", "224", "225",
]

DairyId = Literal[
    "301", "302", "303", "304", "305",
    "306", "307", "308", "309", "310",
    "311", "312", "313", "314", "315",
    "316", "317", "318", "319", "320",
    "321", "322", "323", "324", "325",
]

DeliId = Literal[
    "401", "402", "403", "404", "405",
    "406", "407", "408", "409", "410",
    "411", "412", "413", "414", "415",
    "416", "417", "418", "419", "420",
    "421", "422", "423", "424", "425",
]

MeatId = Literal[
    "501", "502", "503", "504", "505",
    "506", "507", "508", "509", "510",
    "511", "512", "513", "514", "515",
    "516", "517", "518", "519", "520",
    "521", "522", "523", "524", "525",
]

PharmacyId = Literal[
    "601", "602", "603", "604", "605",
    "606", "607", "608", "609", "610",
    "611", "612", "613", "614", "615",
    "616", "617", "618", "619", "620",
    "621", "622", "623", "624", "625",
]

ProduceId = Literal[
    "701", "702", "703", "704", "705",
    "706", "707", "708", "709", "710",
    "711", "712", "713", "714", "715",
    "716", "717", "718", "719", "720",
    "721", "722", "723", "724", "725",
]

SeafoodId = Literal[
    "801", "802", "803", "804", "805",
    "806", "807", "808", "809", "810",
    "811", "812", "813", "814", "815",
    "816", "817", "818", "819", "820",
    "821", "822", "823", "824", "825",
]

SkuId = Union[ApplianceId, CleaningId, DairyId, DeliId, MeatId, PharmacyId, ProduceId, SeafoodId]

class DepartmentInventoryConfig:

    def __init__(self):

        # This is the percentage below which the inventory needs to be replenished
        self.replenishment_threshold: float = 0.30

        # These are maximum inventory levels for each SKU by department
        self.mil_config: dict[str, float] = {
            "appliance": 200.00,
            "cleaning": 200.00,
            "dairy": 200.00,
            "deli": 50.00,
            "meat": 10000.00,
            "pharmacy": 50.00,
            "produce": 10000.00,
            "seafood": 10000.00,
        }

    def get_replenishment_threshold(self):
        return self.replenishment_threshold

    def get_department_maximum_inventory_level(self, department: Departments) -> float:
        return self.mil_config[department]

class ContosoDataModel(BaseModel):
    """Base model that adds a typed `from_dict` constructor for all subclasses."""

    @classmethod
    def from_dict(cls, data: Mapping[str, Any]) -> Self:
        """Converts a python dictionary to a Pydantic object"""
        return cls.model_validate(data)


class ProductInventory(ContosoDataModel):
    sku_id: SkuId = Field(..., description="Unique identifier for the product SKU")
    inventory_level: float = Field(..., description="Available inventory quantity for the SKU")
    unit_price: float = Field(..., description="Unit price of the product")
    name: str = Field(..., description="Name of the product")
    description: str = Field(..., description="Detailed description of the product")
    department: Departments = Field(..., description="Department where the product belongs")

    def get_lookup_id(self) -> str:
        lookup_id = {"sku_id": self.sku_id}
        return base64_encode(json.dumps(lookup_id))


class ReplenishmentItem(ContosoDataModel):
    id: str = Field(..., description="Unique identifier for the replenishment record")
    replenishment_id: str = Field(..., description="Replenishment transaction identifier")
    transaction_date: str = Field(..., description="Date and time when stock was replenished")
    sku_id: SkuId = Field(..., description="SKU identifier being replenished")
    units: float = Field(..., description="Quantity of units replenished")
    vendor_id: str = Field(..., description="Unique identifier of the vendor supplying the replenishment")


class ReplenishmentLevel(ContosoDataModel):
    sku_id: SkuId = Field(..., description="Unique identifier for the product SKU")
    sku_mil: float = Field(..., description="The Maximum Inventory Level for the SKU")
    inventory_level: float = Field(..., description="Available inventory quantity for the SKU")
    needs_replenishment: bool = Field(..., description="Whether or not the SKU needs to be replenished")
    name: str = Field(..., description="Name of the product")
    description: str = Field(..., description="Detailed description of the product")
    department: str = Field(..., description="Department where the product belongs")

    @staticmethod
    def from_product_inventory(sku: ProductInventory, config_database: DepartmentInventoryConfig):
        sku_mil: float = config_database.get_department_maximum_inventory_level(sku.department)
        needs_to_be_replenished: bool = (sku.inventory_level / sku_mil) < config_database.get_replenishment_threshold()

        replenishment_level = ReplenishmentLevel(sku_id=sku.sku_id, sku_mil=sku_mil,
                                                 inventory_level=sku.inventory_level,
                                                 needs_replenishment=needs_to_be_replenished,
                                                 name=sku.name,
                                                 description=sku.description,
                                                 department=sku.department)
        return replenishment_level


class NetSales(ContosoDataModel):
    sku_id: SkuId = Field(..., description="Unique identifier for the product SKU")
    net_sales: float = Field(..., description="Net sales amount for the SKU")
    name: str = Field(..., description="Name of the product")
    department: str = Field(..., description="Department to which the product belongs")

    def get_lookup_id(self) -> str:
        lookup_id = {"sku_id": self.sku_id}
        return base64_encode(json.dumps(lookup_id))


class Department(ContosoDataModel):
    department: str = Field(..., description="Name of the department")
    description: str = Field(..., description="Description of the department's focus or contents")

    def get_lookup_id(self) -> str:
        lookup_id = {"department": self.department}
        return base64_encode(json.dumps(lookup_id))


class PurchaseItem(ContosoDataModel):
    sku_id: SkuId = Field(..., description="Stock Keeping Unit identifier for the product")
    units: float = Field(..., description="Number of units purchased")
    unit_price: float = Field(..., description="Price per unit at time of transaction")
    discounts: float = Field(..., description="Discount applied on the item")


class Purchase(ContosoDataModel):
    id: str = Field(..., description="Unique transaction identifier")
    receipt_id: str = Field(..., description="Receipt identifier")
    transaction_date: str = Field(..., description="Date and time of the purchase")
    customer_id: str = Field(..., description="Unique customer identifier")
    items: List[PurchaseItem] = Field(..., description="List of purchased items")


class PurchaseCart(ContosoDataModel):
    cart_id: str = Field(..., description="Unique Cart identifier")
    customer_id: str = Field(..., description="Unique customer identifier")
    items: dict[SkuId, PurchaseItem] = Field(..., description="Map of cart items for each SKU")

    def add_item(self, item: PurchaseItem):
        sku_id = item.sku_id
        self.items[sku_id] = item

    def remove_item(self, sku_id: SkuId):
        return self.items.pop(sku_id, None)


class ReturnItem(ContosoDataModel):
    sku_id: SkuId = Field(..., description="Stock Keeping Unit identifier")
    units: float = Field(..., description="Number of units returned")
    unit_price: float = Field(..., description="Original unit price at time of purchase")


class ReturnTransaction(ContosoDataModel):
    id: str = Field(..., description="Unique transaction identifier for the return record")
    return_id: str = Field(..., description="Unique return identifier")
    receipt_id: str = Field(..., description="Reference to original purchase receipt")
    transaction_date: str = Field(..., description="Date and time of the return")
    customer_id: str = Field(..., description="Unique customer identifier")
    items: List[ReturnItem] = Field(..., description="List of returned items")


class ReturnCart(ContosoDataModel):
    cart_id: str = Field(..., description="Unique Cart identifier")
    receipt_id: str = Field(..., description="Reference to original purchase receipt")
    customer_id: str = Field(..., description="Unique customer identifier")
    items: dict[str, ReturnItem] = Field(..., description="Map of cart items for each SKU")

    def add_item(self, item: ReturnItem):
        sku_id = item.sku_id
        self.items[sku_id] = item

    def remove_item(self, sku_id: SkuId):
        return self.items.pop(sku_id, None)
