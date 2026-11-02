"""Synthetic support ticket dataset for the Precision Labs workshop scenario.

Precision Labs sells a B2B operations intelligence platform. Customers use it
for analytics dashboards, workflow automation, and data reporting. This index
stores support tickets linked to CRM accounts — the corpus KI teaching target.

The relationship between churn_risk_score and ticket patterns is intentional:
- High-churn accounts have more critical/high-priority tickets and more
  integration/performance issues.
- Stable accounts have mostly billing and feature-request tickets.

This makes "which high-churn accounts are calling in about integration problems?"
a natural and answerable CS agent question.

Usage:
    python support_tickets_dataset.py --es-url $ES_URL --api-key $ES_API_KEY

Requires crm_dataset.py to have run first (loads account IDs).
"""
import argparse
import random
from datetime import date, timedelta

INDEX_NAME_DEFAULT = "precision-support-tickets"

MAPPINGS = {
    "_meta": {
        "description": (
            "Precision Labs customer support tickets. One document per ticket. "
            "Links to precision-crm-accounts via account_id. "
            "Contains full subject, body, category, priority, and resolution data."
        )
    },
    "properties": {
        "ticket_id": {
            "type": "keyword",
            "meta": {"description": "Unique support ticket identifier."},
        },
        "account_id": {
            "type": "keyword",
            "meta": {"description": "CRM account ID of the customer."},
        },
        "company_name": {
            "type": "text",
            "fields": {"keyword": {"type": "keyword"}},
            "meta": {"description": "Customer company name, denormalized."},
        },
        "account_tier": {
            "type": "keyword",
            "meta": {"description": "Enterprise, Mid-Market, or SMB."},
        },
        "subject": {
            "type": "text",
            "meta": {"description": "Short summary of the support issue."},
        },
        "body": {
            "type": "text",
            "meta": {"description": "Full description of the support issue."},
        },
        "category": {
            "type": "keyword",
            "meta": {"description": "Issue category (8 values)."},
        },
        "priority": {
            "type": "keyword",
            "meta": {"description": "Ticket priority: critical, high, medium, low."},
        },
        "status": {
            "type": "keyword",
            "meta": {"description": "Status: open/in_progress/resolved/closed."},
        },
        "created_date": {
            "type": "date",
            "meta": {"description": "Date the ticket was opened."},
        },
        "resolved_date": {
            "type": "date",
            "meta": {"description": "Date resolved; null if still open."},
        },
        "resolution_notes": {
            "type": "text",
            "meta": {"description": "How the ticket was resolved; null if open."},
        },
        "csat_score": {
            "type": "integer",
            "meta": {"description": "Customer satisfaction 1-5; null if unresolved."},
        },
        "assigned_agent": {
            "type": "keyword",
            "meta": {"description": "Support agent handling the ticket."},
        },
    },
}

SUPPORT_AGENTS = [
    "Tariq Al-Rashid", "Mei Lin", "Ravi Patel", "Sofia Andersen",
    "James Okafor", "Elena Kowalski", "Yuki Tanaka", "Aisha Mensah",
]

# (category, priority_weights, subject_templates, body_templates)
# priority_weights: [critical, high, medium, low]
TICKET_TEMPLATES = {
    "integration": {
        "priority_weights": [0.20, 0.40, 0.30, 0.10],
        "subjects": [
            "Salesforce sync failing intermittently",
            "Webhook events not reaching our endpoint",
            "OAuth token refresh loop on SCIM connector",
            "Data pipeline drop after platform update",
            "Zapier integration timing out on large payloads",
            "REST API returning 401 on valid tokens after midnight",
            "Snowflake connector missing rows on incremental sync",
            "HubSpot field mapping not applying to new records",
        ],
        "bodies": [
            (
                "We've been seeing intermittent failures on our Salesforce sync since last Tuesday. "
                "The sync job starts, processes about 60% of records, then exits without error. "
                "Our logs show a connection reset from the Precision Labs side. "
                "This is affecting our nightly revenue reconciliation and we're starting to see stale data in dashboards. "
                "We need this resolved before our board meeting on Friday."
            ),
            (
                "Webhook events from the platform stopped arriving at our endpoint around 14:00 UTC yesterday. "
                "We confirmed our endpoint is healthy and receiving from other sources. "
                "The Precision Labs event log shows events 'delivered' but nothing hits our server. "
                "We have an automated alert system downstream that depends on these — three alerts have already been missed."
            ),
            (
                "Our SCIM connector is in an OAuth token refresh loop. It refreshes, uses the token for one call, "
                "then immediately tries to refresh again instead of using the valid token. "
                "This started after we rotated our client secret last week. "
                "Support documentation says tokens are valid for 3600 seconds — ours appear to expire instantly."
            ),
            (
                "After last night's platform update, our data pipeline is dropping approximately 8% of records on ingest. "
                "No schema changes on our end. We've verified the source data is complete. "
                "The dropped records appear to be those with nested array fields — flat records come through fine. "
                "This is causing material gaps in our analytics reports."
            ),
        ],
    },
    "performance": {
        "priority_weights": [0.15, 0.35, 0.35, 0.15],
        "subjects": [
            "Dashboard load times degraded significantly",
            "Report generation timing out for large date ranges",
            "Bulk export stalling on datasets over 50k rows",
            "API response times 10x normal for /analytics endpoint",
            "Search latency spike since last deployment",
            "Workflow automation delays — jobs queuing for hours",
        ],
        "bodies": [
            (
                "Our main operations dashboard has gone from a 2-second load to 15-20 seconds over the past week. "
                "We haven't changed our filters or added new widgets. "
                "Other teams using the platform aren't reporting issues — this seems isolated to our workspace. "
                "The dashboard is our primary tool for daily stand-ups and the delay is impacting our team."
            ),
            (
                "Any report with a date range exceeding 90 days now times out before completing. "
                "Reports under 90 days run fine. We need quarterly and annual views for our board deck "
                "due next week. This was working three weeks ago — something changed in the platform."
            ),
            (
                "Bulk exports stall indefinitely for datasets above 50,000 rows. "
                "The job shows as 'running' in the UI but never completes and never fails — it just hangs. "
                "We've tried three times over two days. We need this data for a partner handoff tomorrow."
            ),
        ],
    },
    "onboarding": {
        "priority_weights": [0.05, 0.20, 0.50, 0.25],
        "subjects": [
            "Need help setting up SSO for new team members",
            "Onboarding checklist — which integrations to prioritize?",
            "Role permissions not matching our org structure",
            "New hire training resources — what's available?",
            "Custom field setup for our use case",
            "Data import format questions",
        ],
        "bodies": [
            (
                "We're onboarding 12 new analysts next Monday and need to set up SSO through our Okta instance. "
                "The documentation mentions SAML 2.0 support but the steps for Okta specifically aren't clear. "
                "Can someone walk us through the attribute mapping? We want to get this done before they start."
            ),
            (
                "We signed our contract two weeks ago and are ready to start the technical onboarding. "
                "We have Salesforce, Snowflake, and a custom REST API we'd like to connect. "
                "What's the recommended order to set these up? Is there a standard onboarding checklist we should follow?"
            ),
            (
                "We need our data analysts to have read access to dashboards but not be able to edit or share them. "
                "The current role options (Admin, Editor, Viewer) don't map cleanly to our org. "
                "Is there a way to create custom roles or restrict specific dashboard actions per user?"
            ),
        ],
    },
    "billing": {
        "priority_weights": [0.05, 0.15, 0.45, 0.35],
        "subjects": [
            "Invoice discrepancy — overcharged for seat count",
            "Need to update payment method on file",
            "Renewal quote doesn't match agreed pricing",
            "Request for usage report for budget reconciliation",
            "Credit request for service outage last month",
        ],
        "bodies": [
            (
                "Our February invoice shows 45 seats but we only have 38 active users. "
                "We offboarded 7 employees in January and confirmed their accounts were deactivated. "
                "We'd like a credit for the 7 unused seats and an adjustment to our March invoice."
            ),
            (
                "Our credit card on file is expiring at the end of this month. "
                "I don't see a way to update the payment method in the billing settings — "
                "the field appears read-only. Can you help us update it before the next billing cycle?"
            ),
            (
                "The renewal quote we received doesn't reflect the 12% discount agreed during our contract renewal call "
                "with our account executive three weeks ago. The quote shows list price. "
                "Can you reissue with the correct pricing before our finance team closes the quarter?"
            ),
        ],
    },
    "bug": {
        "priority_weights": [0.15, 0.30, 0.40, 0.15],
        "subjects": [
            "Filters reset unexpectedly when navigating between views",
            "Scheduled report emails not being delivered",
            "Data not refreshing after manual trigger",
            "Column sorting broken on custom dashboard",
            "User invites failing with no error message",
            "CSV export encoding incorrect for special characters",
            "Date picker shows wrong timezone in report builder",
        ],
        "bodies": [
            (
                "Any filter we apply on the main analytics view resets to defaults when we navigate to a sub-view "
                "and return. This makes multi-step workflows very tedious — we have to reapply filters "
                "each time. This was not happening a month ago."
            ),
            (
                "Our weekly digest emails stopped being delivered three Mondays ago. "
                "The platform shows them as 'sent' in the notification log but none of our "
                "team members receive them. We've checked spam folders. Other system emails "
                "(invites, password resets) arrive fine."
            ),
            (
                "After clicking 'Refresh Data' on our live dashboard, the timestamp updates "
                "to the current time but the underlying data doesn't change. "
                "Data only refreshes if we do a full browser reload. "
                "We have an ops team member whose job is to trigger refreshes before our 9am standup."
            ),
        ],
    },
    "feature_request": {
        "priority_weights": [0.00, 0.10, 0.35, 0.55],
        "subjects": [
            "Request: bulk user management via CSV import",
            "Request: dark mode for the dashboard UI",
            "Request: webhook event filtering by type",
            "Request: API pagination for large list endpoints",
            "Request: scheduled data snapshots for historical comparison",
            "Request: Slack integration for alert notifications",
            "Request: custom branding on exported reports",
        ],
        "bodies": [
            (
                "We frequently need to onboard or offboard large groups of users at once. "
                "Currently we do this one at a time which is time-consuming. "
                "A CSV import/export for user management would save our IT team significant effort. "
                "Ideally it would support invite, deactivate, and role-change operations."
            ),
            (
                "Several of our team members work late and would appreciate a dark mode option. "
                "It would also be useful for demo presentations in conference rooms with projectors. "
                "This is a nice-to-have but consistently requested internally."
            ),
            (
                "We subscribe to all webhook events but only need a subset. "
                "Filtering at the source (selecting which event types to receive per endpoint) "
                "would reduce noise and processing on our end. "
                "Currently we filter client-side which wastes bandwidth on high-volume accounts."
            ),
        ],
    },
    "api": {
        "priority_weights": [0.10, 0.30, 0.45, 0.15],
        "subjects": [
            "API rate limit documentation unclear — what are our actual limits?",
            "v2 API migration guide — breaking changes?",
            "API key rotation — will existing integrations break?",
            "Pagination not working as documented for /reports endpoint",
            "SDK for Python — is there an official one?",
            "API response for deleted records — how to handle tombstones?",
        ],
        "bodies": [
            (
                "Our documentation shows rate limits of 1000 requests/minute but we're hitting 429s "
                "at around 400 requests/minute. Our account type should be Enterprise tier. "
                "Can you confirm what our actual limits are and whether they can be increased? "
                "We have a nightly batch job that needs to make approximately 1200 calls."
            ),
            (
                "We're planning to migrate to the v2 API and want to understand the breaking changes. "
                "The migration guide mentions 'response envelope changes' but doesn't specify which fields. "
                "We have about 15 internal integrations that consume the API — "
                "we need a complete diff of changed response shapes."
            ),
            (
                "We need to rotate our API key for security compliance reasons. "
                "If we rotate the key in the dashboard, do all existing integrations using the old key "
                "immediately break, or is there a grace period? "
                "We have 6 production integrations to update and need to coordinate the rollover."
            ),
        ],
    },
    "data_quality": {
        "priority_weights": [0.10, 0.25, 0.45, 0.20],
        "subjects": [
            "Duplicate records appearing after sync",
            "Historical data missing for date range after migration",
            "Numeric field rounding inconsistent across reports",
            "Deleted records still appearing in exports",
            "Timestamps off by one hour — DST issue?",
            "Joined data returning null for fields that exist",
        ],
        "bodies": [
            (
                "After our last Salesforce sync, we're seeing duplicate account records in our analytics. "
                "It looks like any account that was modified in Salesforce in the past 7 days has two copies. "
                "This is inflating our customer count metrics and breaking our revenue calculations."
            ),
            (
                "Following our data migration last month, all records from before 2024-06-01 are missing. "
                "The migration report showed 'all records transferred successfully' but the data isn't there. "
                "This is 18 months of historical data we need for trend analysis."
            ),
            (
                "Revenue figures in our executive summary report are rounding to 2 decimal places "
                "but our data export rounds to 0. Both should show full precision. "
                "This is causing reconciliation issues with our finance team."
            ),
        ],
    },
}

RESOLUTION_TEMPLATES = {
    "integration": [
        "Identified authentication token caching issue on our infrastructure. Deployed hotfix. Sync confirmed stable for 48 hours.",
        "Webhook delivery queue had backed up. Cleared queue and deployed fix to prevent recurrence. Customer confirmed receipt.",
        "OAuth configuration issue identified. Updated client credential handling. Customer confirmed working.",
        "Schema validation bug introduced in last deployment. Rolled back and redeployed with fix. Data pipeline confirmed healthy.",
    ],
    "performance": [
        "Identified query optimization opportunity specific to customer's workspace size. Applied index hint. Dashboard loads in under 2 seconds.",
        "Report query timeout threshold increased for Enterprise accounts. Customer confirmed large date ranges now working.",
        "Export job deadlock identified. Fixed in patch 4.2.1. Customer confirmed bulk exports completing.",
    ],
    "onboarding": [
        "Scheduled walkthrough call. Completed SSO setup with customer's IT team. All users onboarded successfully.",
        "Provided integration priority guide. Customer is starting with Salesforce connector per recommendation.",
        "Created custom role configuration per customer's org structure requirements. Validated with customer admin.",
    ],
    "billing": [
        "Confirmed overcounting issue. Applied credit for 7 unused seats. Updated March invoice.",
        "Updated payment method via admin console. Confirmed next billing cycle will use new card.",
        "Verified discount agreement in contract. Reissued quote with correct pricing.",
    ],
    "bug": [
        "Identified state management regression in v4.1.0. Fixed in v4.1.1 hotfix. Customer confirmed filters persist.",
        "Email delivery queue configuration issue identified. Fixed and reprocessed missed emails.",
        "Cache invalidation bug on manual refresh trigger. Fixed in next patch. Customer using browser reload as workaround.",
    ],
    "feature_request": [
        "Logged as product feedback. Added to Q3 roadmap consideration. Will notify when scheduled.",
        "Passed to product team. Dark mode is planned for v5.0 release.",
        "Webhook filtering is on the roadmap for Q2. Customer notified.",
    ],
    "api": [
        "Confirmed Enterprise rate limits and updated documentation. Approved limit increase to 2000 req/min.",
        "Provided complete v1-to-v2 diff document. Scheduled migration support call.",
        "Confirmed 24-hour grace period for key rotation. Customer completed rollover successfully.",
    ],
    "data_quality": [
        "Identified duplicate detection logic gap for recently-modified records. Fixed. Deduplication job run.",
        "Found data migration script date filter bug. Reprocessed pre-2024-06-01 records. Customer confirmed data present.",
        "Rounding inconsistency identified between report renderer and export engine. Fixed to use consistent precision.",
    ],
}


def _random_date(rng, start_date, end_date):
    delta = (end_date - start_date).days
    return start_date + timedelta(days=rng.randint(0, delta))


def generate_tickets(crm_records, total_tickets=3000, seed=42):
    """Generate support tickets linked to CRM account records."""
    rng = random.Random(seed)

    # Distribute tickets across accounts, weighted by churn risk and tier
    # High-churn Enterprise accounts get more tickets
    weights = []
    for r in crm_records:
        churn = r.get("churn_risk_score", 0.5)
        tier_mult = {"Enterprise": 2.5, "Mid-Market": 1.5, "SMB": 0.8}.get(r.get("account_tier", "SMB"), 1.0)
        weights.append(max(0.1, (0.3 + churn * 0.7) * tier_mult))

    total_weight = sum(weights)
    ticket_counts = [max(0, round(w / total_weight * total_tickets)) for w in weights]
    # Adjust for rounding drift
    diff = total_tickets - sum(ticket_counts)
    for i in range(abs(diff)):
        if diff > 0:
            ticket_counts[rng.randint(0, len(ticket_counts) - 1)] += 1
        elif diff < 0:
            idx = rng.randint(0, len(ticket_counts) - 1)
            if ticket_counts[idx] > 0:
                ticket_counts[idx] -= 1

    categories = list(TICKET_TEMPLATES.keys())
    # High-churn accounts skew toward integration/performance/bug categories
    start = date(2025, 1, 1)
    end = date(2026, 8, 1)

    tickets = []
    ticket_num = 1

    for acct, count in zip(crm_records, ticket_counts):
        churn = acct.get("churn_risk_score", 0.5)
        acct_id = acct["customer_id"]
        company = acct["company_name"]
        tier = acct["account_tier"]

        # Category weights per account — high churn = more technical/operational issues
        if churn >= 0.7:
            cat_weights = [0.22, 0.18, 0.08, 0.10, 0.18, 0.06, 0.12, 0.06]
        elif churn >= 0.4:
            cat_weights = [0.15, 0.12, 0.12, 0.12, 0.15, 0.12, 0.12, 0.10]
        else:
            cat_weights = [0.08, 0.06, 0.14, 0.16, 0.12, 0.20, 0.12, 0.12]
        # categories order: integration, performance, onboarding, billing, bug, feature_request, api, data_quality

        for _ in range(count):
            cat = rng.choices(categories, weights=cat_weights)[0]
            tmpl = TICKET_TEMPLATES[cat]
            priority = rng.choices(
                ["critical", "high", "medium", "low"],
                weights=tmpl["priority_weights"]
            )[0]

            subject = rng.choice(tmpl["subjects"])
            body = rng.choice(tmpl["bodies"])
            created = _random_date(rng, start, end)

            # Resolution
            is_resolved = rng.random() < 0.78
            resolved_date = None
            resolution_notes = None
            csat_score = None
            status = "open"

            if is_resolved:
                days_to_resolve = {
                    "critical": rng.randint(1, 3),
                    "high": rng.randint(2, 7),
                    "medium": rng.randint(3, 14),
                    "low": rng.randint(5, 30),
                }[priority]
                resolved_dt = created + timedelta(days=days_to_resolve)
                if resolved_dt > end:
                    resolved_dt = end
                resolved_date = resolved_dt.isoformat()
                resolution_notes = rng.choice(RESOLUTION_TEMPLATES.get(cat, ["Issue resolved."]))
                # High-churn accounts give lower CSAT
                if churn >= 0.7:
                    csat_score = rng.choices([1, 2, 3, 4, 5], weights=[0.15, 0.25, 0.30, 0.20, 0.10])[0]
                else:
                    csat_score = rng.choices([1, 2, 3, 4, 5], weights=[0.05, 0.10, 0.20, 0.35, 0.30])[0]
                status = rng.choice(["resolved", "closed"])
            else:
                status = rng.choice(["open", "in_progress"])

            tickets.append({
                "ticket_id": f"TICK-{ticket_num:05d}",
                "account_id": acct_id,
                "company_name": company,
                "account_tier": tier,
                "subject": subject,
                "body": body,
                "category": cat,
                "priority": priority,
                "status": status,
                "created_date": created.isoformat(),
                "resolved_date": resolved_date,
                "resolution_notes": resolution_notes,
                "csat_score": csat_score,
                "assigned_agent": rng.choice(SUPPORT_AGENTS),
            })
            ticket_num += 1

    rng.shuffle(tickets)
    return tickets


def index_tickets(es_url, api_key, index_name=INDEX_NAME_DEFAULT, total_tickets=3000, seed=42):
    from elasticsearch import Elasticsearch, helpers
    from crm_dataset import generate_records

    client = Elasticsearch(hosts=[es_url], api_key=api_key)
    client.indices.delete(index=index_name, ignore_unavailable=True)
    client.indices.create(index=index_name, mappings=MAPPINGS)

    crm_records = generate_records(n=500, seed=42)
    tickets = generate_tickets(crm_records, total_tickets=total_tickets, seed=seed)

    actions = (
        {"_index": index_name, "_id": t["ticket_id"], "_source": t}
        for t in tickets
    )
    helpers.bulk(client, actions)
    client.indices.refresh(index=index_name)
    count = client.count(index=index_name)["count"]
    print(f"Indexed {count} tickets into '{index_name}'.")
    return count


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--es-url", required=True)
    parser.add_argument("--api-key", required=True)
    parser.add_argument("--index", default=INDEX_NAME_DEFAULT)
    parser.add_argument("--count", type=int, default=3000)
    args = parser.parse_args()
    index_tickets(args.es_url, args.api_key, index_name=args.index, total_tickets=args.count)
