from typing import TypedDict


class ActivityRequestRegistration(TypedDict):
    experience_name: str
    preferred_time: str
    party_size: int


class GuestAttractionPreferences(TypedDict):
    guest_full_name: str
    guest_email_address: str
    guest_signature: bool
    signature_date: str
    activity_preferences: list[str]
    activity_requests: list[ActivityRequestRegistration]
