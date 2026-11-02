"""Synthetic CRM dataset for the Precision Labs workshop scenario.

Precision Labs is a B2B operations intelligence platform. This index stores
their customer account records — one document per account.

Deterministic (no LLM, no randomness needed at import time — caller controls the seed).
Default: 500 accounts. The `arr` field is a key teaching point: it means Annual Recurring
Revenue here, not "array" or "array length" — an agent that only reads field NAMES
(not the mapping's meta.description) has no way to know that, and will misinterpret it.

Usage:
    python crm_dataset.py --es-url $ES_URL --api-key $ES_API_KEY [--index precision-crm-accounts]
"""
import argparse
import random

INDEX_NAME_DEFAULT = "precision-crm-accounts"

MAPPINGS = {
    "_meta": {
        "description": (
            "Precision Labs CRM — customer account records for sales and CS reporting. "
            "One document per account. BM25-only index — no embeddings."
        )
    },
    # Field-level `meta.description` values are capped at 50 chars by Elasticsearch
    # (mapper_parsing_exception above that) — keep every description under the limit.
    "properties": {
        "customer_id": {
            "type": "keyword",
            "meta": {"description": "Internal account identifier."},
        },
        "company_name": {
            "type": "text",
            "fields": {"keyword": {"type": "keyword"}},
            "meta": {"description": "Customer company name."},
        },
        "industry": {
            "type": "keyword",
            "meta": {"description": "Customer's industry vertical."},
        },
        "region": {
            "type": "keyword",
            "meta": {"description": "Sales region: NA/EMEA/APAC/LATAM."},
        },
        "account_tier": {
            "type": "keyword",
            "meta": {"description": "Enterprise, Mid-Market, or SMB."},
        },
        "arr": {
            "type": "double",
            "meta": {
                # The whole teaching point: NOT array length. Kept under 50 chars.
                "description": "Annual Recurring Revenue in USD ($).",
            },
        },
        "employee_count": {
            "type": "integer",
            "meta": {"description": "Approx. employee headcount."},
        },
        "churn_risk_score": {
            "type": "float",
            "meta": {"description": "Predicted churn risk, 0.0-1.0."},
        },
        "account_owner": {
            "type": "keyword",
            "meta": {"description": "Assigned customer success manager."},
        },
        "renewal_date": {
            "type": "date",
            "meta": {"description": "Next contract renewal date."},
        },
    },
}

INDUSTRIES = ["SaaS", "FinTech", "Healthcare", "Retail", "Manufacturing", "Logistics", "EdTech", "Media"]
REGIONS = ["NA", "EMEA", "APAC", "LATAM"]
TIERS = ["Enterprise", "Mid-Market", "SMB"]
OWNERS = ["Dana Reyes", "Priya Nair", "Marcus Webb", "Lena Fischer", "Omar Haddad", "Ji-Woo Kang"]
COMPANY_PREFIXES = ["Nimbus", "Vertex", "Cascade", "Ironclad", "Bluepeak", "Solace", "Anchorpoint",
                    "Redwood", "Meridian", "Fathom", "Northstar", "Wavelength", "Cobalt", "Aurora",
                    "Granite", "Latticework", "Hearthstone", "Coppervale", "Driftwood", "Sablefield"]
COMPANY_SUFFIXES = ["Labs", "Systems", "Technologies", "Group", "Partners", "Analytics", "Networks", "Co"]


def generate_records(n=500, seed=42):
    rng = random.Random(seed)
    records = []
    for i in range(1, n + 1):
        tier = rng.choice(TIERS)
        arr_range = {
            "Enterprise": (250_000, 2_000_000),
            "Mid-Market": (40_000, 250_000),
            "SMB": (10_000, 40_000),
        }[tier]
        company = f"{rng.choice(COMPANY_PREFIXES)} {rng.choice(COMPANY_SUFFIXES)}"
        records.append({
            "customer_id": f"CUST-{i:04d}",
            "company_name": company,
            "industry": rng.choice(INDUSTRIES),
            "region": rng.choice(REGIONS),
            "account_tier": tier,
            "arr": round(rng.uniform(*arr_range), 2),
            "employee_count": rng.randint(15, 12000),
            "churn_risk_score": round(rng.uniform(0.0, 1.0), 2),
            "account_owner": rng.choice(OWNERS),
            "renewal_date": f"2026-{rng.randint(1,12):02d}-{rng.randint(1,28):02d}",
        })
    return records


def index_records(es_url, api_key, index_name=INDEX_NAME_DEFAULT, n=500, seed=42):
    from elasticsearch import Elasticsearch, helpers

    client = Elasticsearch(hosts=[es_url], api_key=api_key)
    client.indices.delete(index=index_name, ignore_unavailable=True)
    client.indices.create(index=index_name, mappings=MAPPINGS)

    records = generate_records(n=n, seed=seed)
    actions = (
        {"_index": index_name, "_id": r["customer_id"], "_source": r}
        for r in records
    )
    helpers.bulk(client, actions)
    client.indices.refresh(index=index_name)
    count = client.count(index=index_name)["count"]
    print(f"Indexed {count} documents into '{index_name}'.")
    return count


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--es-url", required=True)
    parser.add_argument("--api-key", required=True)
    parser.add_argument("--index", default=INDEX_NAME_DEFAULT)
    parser.add_argument("--count", type=int, default=500)
    args = parser.parse_args()
    index_records(args.es_url, args.api_key, index_name=args.index, n=args.count)
