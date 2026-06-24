
class StaticDataset:

    @staticmethod
    def get_employee_identifiers() -> list[str]:
        employee_ids: list[str] = [
            "james@contosogroceries.ai",
            "charlotte@contosogroceries.ai",
            "andy@contosogroceries.ai",
            "juan@contosogroceries.ai",
            "jason@contosogroceries.ai",
            "devanshi@contosogroceries.ai"
        ]
        return employee_ids

    @staticmethod
    def get_customer_identifiers() -> list[str]:
        customer_ids: list[str] = [
            "angela@contosocustomers.ai",
            "patrick@contosocustomers.ai",
            "darcy@contosovendors.ai",
            "mikhail@contosogroceries.ai",
            "jacob@contosogroceries.ai"
        ]
        return customer_ids

    @staticmethod
    def get_vendor_identifiers() -> list[str]:
        vendor_ids: list[str] = [
            "seafood@contosovendors.ai",
            "meat@contosovendors.ai",
            "dairy@contosovendors.ai",
            "global@contosovendors.ai"
        ]
        return vendor_ids
