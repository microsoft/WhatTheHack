from typing import TypedDict


class Yacht(TypedDict):
    yachtId: str
    name: str
    price: float
    maxCapacity: int
    description: str


class YachtSearchResponse(Yacht):
    id: str


class YachtEmbeddingHash(TypedDict):
    yachtId: str
    embedding: list[float]
    hash: str
