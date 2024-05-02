from typing import TypedDict


class TemperaturePreferences(TypedDict):
    meal_item: str
    quantity: int
    min_temperature: float
    max_temperature: float


class MealPreferences(TypedDict):
    guest_full_name: str
    guest_phone_number: str
    guest_email_address: str
    guest_signature: bool
    signature_date: str
    meal_preferences: list[str]
    allergens: list[str]
    temperature_preferences: list[TemperaturePreferences]

