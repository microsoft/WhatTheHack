from typing import TypedDict


class Customer(TypedDict):
    email: str
    firstName: str
    lastName: str


class YachtDetails(TypedDict):
    yachtId: str
    name: str
    description: str
    price: float
    maxCapacity: int


class YachtReservation(TypedDict):
    reservationId: str
    yachtId: str
    emailAddress: str
    numberOfPassengers: int
    reservationDate: str


class YachtReservationFull(YachtReservation):
    id: str
