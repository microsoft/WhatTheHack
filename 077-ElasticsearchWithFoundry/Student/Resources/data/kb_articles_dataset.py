"""Synthetic knowledge base articles for the Precision Labs workshop scenario.

Precision Labs' internal support KB — articles that support agents reference
when resolving tickets. This is the third index in the routing scenario:
the agent must choose between CRM accounts, support tickets, and KB articles
depending on the question asked.

Usage:
    python kb_articles_dataset.py --es-url $ES_URL --api-key $ES_API_KEY
"""
import argparse
import random
from datetime import date, timedelta

INDEX_NAME_DEFAULT = "precision-kb-articles"

MAPPINGS = {
    "_meta": {
        "description": (
            "Precision Labs internal knowledge base. How-to guides, troubleshooting "
            "runbooks, API reference, and onboarding documentation for the operations "
            "intelligence platform. One document per article."
        )
    },
    "properties": {
        "article_id": {
            "type": "keyword",
            "meta": {"description": "Unique KB article identifier."},
        },
        "title": {
            "type": "text",
            "fields": {"keyword": {"type": "keyword"}},
            "meta": {"description": "Article title."},
        },
        "category": {
            "type": "keyword",
            "meta": {"description": "Article category (7 values)."},
        },
        "content": {
            "type": "text",
            "meta": {"description": "Full article text."},
        },
        "tags": {
            "type": "keyword",
            "meta": {"description": "Topic tags for filtering."},
        },
        "last_updated": {
            "type": "date",
            "meta": {"description": "Date article was last reviewed or updated."},
        },
        "view_count": {
            "type": "integer",
            "meta": {"description": "Cumulative page views."},
        },
        "helpful_votes": {
            "type": "integer",
            "meta": {"description": "Number of helpful votes from support agents."},
        },
    },
}

ARTICLES = [
    # ONBOARDING
    {
        "title": "Getting Started: Setting Up Your Precision Labs Workspace",
        "category": "onboarding",
        "tags": ["onboarding", "setup", "workspace", "admin"],
        "content": (
            "Welcome to Precision Labs. This guide walks you through the first steps to configure your workspace "
            "and onboard your team.\n\n"
            "**Step 1 — Invite your admin users first.** Before inviting analysts or viewers, set up at least two "
            "admin accounts. Admin accounts can manage billing, integrations, and user roles. Go to Settings → Team → "
            "Invite Member and select the Admin role.\n\n"
            "**Step 2 — Connect your first data source.** Navigate to Integrations → Connect Source. We recommend "
            "starting with your CRM (Salesforce, HubSpot, or Pipedrive) as your primary source. This gives the "
            "platform foundational account data that enriches all downstream analytics.\n\n"
            "**Step 3 — Configure your workspace timezone.** Go to Settings → Workspace → Timezone. All report "
            "timestamps, scheduled jobs, and alert triggers run against this timezone. Mismatches here are the most "
            "common cause of 'off by one hour' data complaints.\n\n"
            "**Step 4 — Run your first health check.** After connecting a source, go to Integrations → [Source Name] → "
            "Health. A green status confirms the sync is active. If you see yellow or red, check the Troubleshooting "
            "section of this KB for connector-specific guides.\n\n"
            "Your workspace is ready. See 'Inviting Your Team at Scale' for bulk user onboarding."
        ),
    },
    {
        "title": "SSO Setup: Configuring SAML 2.0 with Okta",
        "category": "onboarding",
        "tags": ["sso", "okta", "saml", "authentication", "onboarding"],
        "content": (
            "Precision Labs supports SAML 2.0 SSO with any compliant identity provider. This guide covers Okta specifically.\n\n"
            "**Prerequisites:** Admin access to both your Precision Labs workspace and your Okta admin console. "
            "SSO is available on Mid-Market and Enterprise plans.\n\n"
            "**Step 1 — Get your SAML metadata URL.** In Precision Labs, go to Settings → Security → SSO → Configure. "
            "Copy the 'SP Metadata URL' — you'll paste this into Okta.\n\n"
            "**Step 2 — Create the Okta app.** In Okta Admin, go to Applications → Create App Integration → SAML 2.0. "
            "Set the Single Sign-On URL and Audience URI to the values shown in your Precision Labs SSO config page.\n\n"
            "**Step 3 — Attribute mapping.** Precision Labs requires three SAML attributes: `email` (maps to "
            "`user.email`), `firstName` (maps to `user.firstName`), `lastName` (maps to `user.lastName`). "
            "Without these, SSO logins will fail with a generic 'provisioning error.'\n\n"
            "**Step 4 — Paste Okta's metadata.** Back in Precision Labs SSO config, paste the Okta IdP metadata URL "
            "and click Save. Test with a non-admin account before rolling out to your team.\n\n"
            "**Common issue:** If you see 'InResponseTo mismatch' errors, your Okta app is generating unsigned assertions. "
            "Enable 'Sign SAML Response and Assertion' in your Okta app settings."
        ),
    },
    {
        "title": "Role-Based Access Control: Creating Custom Permission Sets",
        "category": "onboarding",
        "tags": ["rbac", "permissions", "roles", "admin", "security"],
        "content": (
            "Precision Labs ships with three built-in roles: Admin, Editor, and Viewer. For most organizations, "
            "these are sufficient. Enterprise accounts can request custom roles via Support.\n\n"
            "**Built-in roles:**\n"
            "- **Admin:** Full access including billing, integrations, user management, and all data.\n"
            "- **Editor:** Can create and edit dashboards and reports. Cannot manage users or billing.\n"
            "- **Viewer:** Read-only access to shared dashboards and reports. Cannot create or modify anything.\n\n"
            "**Custom roles (Enterprise only):** Custom roles allow you to restrict specific actions within Editor "
            "or Viewer tiers. Common customizations include: disabling CSV export for Viewers, restricting Editors "
            "to specific workspaces, and preventing sharing of dashboards outside the organization.\n\n"
            "To request a custom role, open a support ticket with the category 'onboarding' and describe the exact "
            "permissions needed. Include your account ID. Our team typically configures custom roles within 2 business days.\n\n"
            "**Workspace-scoped roles:** You can assign different roles to a user per workspace. A user can be an "
            "Editor in the Sales workspace and a Viewer in Finance. Manage this under Settings → Team → [User] → "
            "Workspace Access."
        ),
    },
    {
        "title": "Bulk User Onboarding via CSV Import",
        "category": "onboarding",
        "tags": ["onboarding", "users", "csv", "bulk", "admin"],
        "content": (
            "For teams onboarding more than 10 users at once, CSV import is faster than individual invitations.\n\n"
            "**CSV format requirements:**\n"
            "- Required columns: `email`, `first_name`, `last_name`, `role` (Admin/Editor/Viewer)\n"
            "- Optional columns: `workspace` (comma-separated workspace names), `team` (team name)\n"
            "- Maximum rows per import: 500\n"
            "- File encoding: UTF-8\n\n"
            "**How to import:** Go to Settings → Team → Bulk Import. Upload your CSV. The system validates each row "
            "before sending invitations — any row with a formatting error is skipped and listed in the error report. "
            "Correct the errors and re-upload just the failed rows.\n\n"
            "**What happens after import:** Each user receives an email invitation valid for 7 days. "
            "Uninvited users appear as 'Pending' in your team list. Resend invitations from Settings → Team → "
            "filter by Pending → Resend All.\n\n"
            "**SSO note:** If your workspace uses SSO, imported users are provisioned but will authenticate via your "
            "identity provider on first login. No separate password setup is needed."
        ),
    },
    # INTEGRATIONS
    {
        "title": "Salesforce Connector: Setup and Sync Configuration",
        "category": "integrations",
        "tags": ["salesforce", "crm", "integration", "sync", "connector"],
        "content": (
            "The Salesforce connector syncs Accounts, Contacts, Opportunities, and Activities into Precision Labs "
            "on a configurable schedule (minimum: every 15 minutes).\n\n"
            "**Authentication:** We use OAuth 2.0. Click Connect → Salesforce → Authorize and log in with a Salesforce "
            "account that has API access. We recommend a dedicated integration user rather than a personal account — "
            "if the personal account is deactivated, the connector breaks.\n\n"
            "**Object selection:** After authenticating, select which Salesforce objects to sync. Start with Accounts "
            "and Opportunities. Adding Contacts and Activities significantly increases sync time for large orgs.\n\n"
            "**Field mapping:** Precision Labs auto-maps standard Salesforce fields. Custom fields appear in the "
            "'Unmapped Fields' section — drag them to the corresponding Precision Labs field or create a new custom field.\n\n"
            "**Sync frequency:** Go to the connector settings → Schedule. '15 minutes' is the highest frequency; "
            "'Daily' is the lowest. Enterprise accounts can request real-time sync via webhooks — open a support ticket.\n\n"
            "**Troubleshooting sync failures:** The most common causes are (1) Salesforce API limits exceeded "
            "(check your Salesforce org's API usage dashboard), (2) the integration user lost API permission, "
            "and (3) a Salesforce field type changed in a deployment. Check the sync log at Integrations → Salesforce → History."
        ),
    },
    {
        "title": "Snowflake Connector: Incremental Sync Setup",
        "category": "integrations",
        "tags": ["snowflake", "data-warehouse", "integration", "incremental", "connector"],
        "content": (
            "The Snowflake connector pulls data from your Snowflake warehouse into Precision Labs. "
            "We support both full refresh and incremental sync modes.\n\n"
            "**Connection requirements:** A Snowflake user with USAGE on the target database and schema, "
            "SELECT on the target tables, and OPERATE on the warehouse. Create a dedicated service account "
            "rather than using a personal login.\n\n"
            "**Incremental sync:** Incremental sync requires a timestamp or auto-increment column in your source table "
            "to track which rows are new since the last sync. Specify this column in the connector settings → "
            "Sync Mode → Incremental → Cursor Column. Without a cursor column, only full refresh is available.\n\n"
            "**Schema drift handling:** If you add a new column to your Snowflake table, the connector detects it "
            "on the next sync and adds it to Precision Labs automatically. If you remove or rename a column, "
            "the connector will log a warning but continue syncing the remaining columns.\n\n"
            "**Common issue — missing rows:** If incremental sync is dropping rows, verify that your cursor column "
            "has no null values and that it updates on every record modification. Records with a null cursor value "
            "are never included in incremental syncs."
        ),
    },
    {
        "title": "Webhook Setup: Receiving Real-Time Events",
        "category": "integrations",
        "tags": ["webhooks", "events", "real-time", "integration", "api"],
        "content": (
            "Precision Labs can push events to your systems in real time via webhooks. This is useful for "
            "triggering downstream actions when data changes — for example, alerting Slack when a high-risk "
            "account's churn score crosses a threshold.\n\n"
            "**Setting up a webhook:** Go to Settings → Webhooks → Add Endpoint. Enter your endpoint URL and "
            "select the event types you want to receive. We recommend starting with a subset of events — "
            "high-traffic event types (like `record.updated`) can generate thousands of calls per hour.\n\n"
            "**Event filtering:** You can filter events by entity type, field value, or workspace. For example: "
            "only send `account.churn_risk_changed` events where `churn_risk_score > 0.7`. "
            "Filtering at the source reduces noise in your systems.\n\n"
            "**Retry behavior:** If your endpoint returns a non-2xx response, we retry up to 5 times with "
            "exponential backoff (1s, 2s, 4s, 8s, 16s). After 5 failures, the event is marked as failed and "
            "logged. Check Webhooks → [Endpoint] → Event Log for failed deliveries.\n\n"
            "**Endpoint verification:** On setup, we send a `webhook.test` event with a `challenge` field. "
            "Your endpoint must echo the challenge value in its response within 10 seconds to verify ownership."
        ),
    },
    {
        "title": "REST API: Rotating API Keys Without Downtime",
        "category": "integrations",
        "tags": ["api", "api-key", "rotation", "security", "integration"],
        "content": (
            "API key rotation is a security best practice. Precision Labs supports zero-downtime key rotation "
            "via a grace period window.\n\n"
            "**Rotation process:**\n"
            "1. Go to Settings → API Keys → Generate New Key. A new key is created alongside your existing key.\n"
            "2. Update your integrations to use the new key — take as much time as you need.\n"
            "3. When all integrations are updated, go back to API Keys and click Revoke on the old key.\n\n"
            "**Grace period:** Both keys are valid simultaneously until you revoke the old one. "
            "There is no automatic expiry — the old key remains valid until explicitly revoked.\n\n"
            "**Key scopes:** When generating a new key, you can optionally restrict its scope to specific "
            "API endpoints (read-only, specific resources). Scoped keys reduce blast radius if a key is compromised.\n\n"
            "**Best practice:** Generate a new key, update one integration, verify it works, then proceed with others. "
            "Do not revoke the old key until all integrations have been updated and verified."
        ),
    },
    {
        "title": "Zapier Integration: Common Triggers and Actions",
        "category": "integrations",
        "tags": ["zapier", "automation", "integration", "no-code"],
        "content": (
            "Precision Labs has a native Zapier integration for no-code automation. "
            "The integration is available on Mid-Market and Enterprise plans.\n\n"
            "**Available triggers:**\n"
            "- `New Record` — fires when a new record is created in a specified dataset\n"
            "- `Record Updated` — fires when a monitored field changes value\n"
            "- `Alert Triggered` — fires when a threshold alert activates\n"
            "- `Report Ready` — fires when a scheduled report completes\n\n"
            "**Available actions:**\n"
            "- `Create Record` — adds a new record to a Precision Labs dataset\n"
            "- `Update Record` — modifies a field on an existing record (requires record ID)\n"
            "- `Run Report` — triggers an on-demand report\n\n"
            "**Payload size limit:** Zapier actions have a 10MB payload limit. If you're passing large data objects "
            "(e.g., full export contents), consider using the Precision Labs API directly instead of Zapier.\n\n"
            "**Rate limiting:** Zapier polls triggers every 15 minutes on free plans, every 2 minutes on paid plans. "
            "For near-real-time automation, use our native Webhooks instead of Zapier polling triggers."
        ),
    },
    # TROUBLESHOOTING
    {
        "title": "Troubleshooting: Dashboard Not Refreshing After Manual Trigger",
        "category": "troubleshooting",
        "tags": ["dashboard", "refresh", "cache", "troubleshooting", "bug"],
        "content": (
            "If clicking 'Refresh Data' updates the timestamp but not the underlying data, "
            "the issue is almost always a browser or CDN cache problem.\n\n"
            "**Quick fix — hard reload:** Press Ctrl+Shift+R (Windows/Linux) or Cmd+Shift+R (Mac) to bypass "
            "the browser cache entirely. This forces the page to re-fetch all assets and data from the server.\n\n"
            "**If hard reload doesn't fix it:** The dashboard may have a stale cached query result. "
            "Open the dashboard settings (gear icon → Advanced → Cache) and click 'Invalidate Cache.' "
            "This forces the next data fetch to bypass our CDN cache layer.\n\n"
            "**Root cause:** Our CDN caches dashboard query results for 5 minutes to reduce database load. "
            "The 'Refresh Data' button updates the UI timestamp but doesn't always invalidate the CDN cache. "
            "This is a known issue being tracked in our backlog.\n\n"
            "**Workaround for operations teams:** If you need reliable real-time data for standups or monitoring, "
            "use the 'Live View' mode (toggle in the top-right corner of any dashboard). Live View bypasses "
            "caching entirely and queries the database directly, at a slight latency cost."
        ),
    },
    {
        "title": "Troubleshooting: Scheduled Report Emails Not Arriving",
        "category": "troubleshooting",
        "tags": ["email", "reports", "scheduled", "troubleshooting", "notifications"],
        "content": (
            "If scheduled report emails show as 'Sent' in the platform but don't arrive, work through these steps.\n\n"
            "**Step 1 — Check spam/junk folders.** Our emails come from `reports@mail.precisionlabs.io`. "
            "Allowlist this address in your email client or corporate email filter.\n\n"
            "**Step 2 — Verify the recipient list.** Go to Reports → [Report Name] → Schedule → Recipients. "
            "Confirm the email address is spelled correctly. A typo in the address causes silent failures "
            "because the platform counts the send as successful even if the address doesn't exist.\n\n"
            "**Step 3 — Check corporate email filters.** Enterprise IT teams sometimes block external email "
            "senders at the domain level. Ask your IT team to allowlist `mail.precisionlabs.io`. "
            "This is the most common cause of reports arriving for some team members but not others.\n\n"
            "**Step 4 — Test with a personal email.** Temporarily add a personal Gmail or similar to the "
            "recipient list. If the personal address receives the email but corporate addresses don't, "
            "the issue is your corporate email filter.\n\n"
            "**Step 5 — Check the delivery log.** Go to Settings → Notifications → Email Log. "
            "If you see 'Bounced' or 'Filtered' status, the email was rejected by the recipient mail server."
        ),
    },
    {
        "title": "Troubleshooting: Duplicate Records After Salesforce Sync",
        "category": "troubleshooting",
        "tags": ["duplicates", "salesforce", "sync", "data-quality", "troubleshooting"],
        "content": (
            "Duplicate records in Precision Labs after a Salesforce sync are almost always caused by one of three things: "
            "a Salesforce ID mismatch, a sync mode misconfiguration, or a manual import that overlapped with the sync.\n\n"
            "**Check 1 — Salesforce ID mapping.** Open a duplicate record pair in Precision Labs. Both should have the "
            "same `salesforce_id` if they represent the same Salesforce Account. If they have different `salesforce_id` "
            "values, the duplicates originate in Salesforce itself — the deduplication needs to happen there first.\n\n"
            "**Check 2 — Sync mode.** Go to Integrations → Salesforce → Sync Mode. If set to 'Append' instead of "
            "'Upsert', every sync adds new records rather than updating existing ones. Change to 'Upsert' and run "
            "a manual deduplication job (Admin → Data → Deduplication → Run).\n\n"
            "**Check 3 — Recent manual import.** Check Admin → Audit Log for any recent CSV imports to the accounts "
            "dataset. Imports create new records by default — if the same accounts were already synced from Salesforce, "
            "you'll get duplicates. Use the 'Upsert by External ID' option on imports to prevent this.\n\n"
            "**Cleaning up duplicates:** Admin → Data → Deduplication → Preview will show all detected duplicate pairs "
            "before merging. Review before merging — the merge is irreversible."
        ),
    },
    {
        "title": "Troubleshooting: API Returning 429 Rate Limit Errors",
        "category": "troubleshooting",
        "tags": ["api", "rate-limit", "429", "troubleshooting", "performance"],
        "content": (
            "HTTP 429 responses mean your API client is exceeding the rate limit for your account tier.\n\n"
            "**Rate limits by tier:**\n"
            "- SMB: 200 requests/minute per API key\n"
            "- Mid-Market: 600 requests/minute per API key\n"
            "- Enterprise: 1,200 requests/minute per API key (custom limits available on request)\n\n"
            "**Check your current usage:** The `X-RateLimit-Remaining` and `X-RateLimit-Reset` headers in every API "
            "response show your remaining quota and when it resets. Log these to identify which endpoint or time "
            "window is hitting the limit.\n\n"
            "**Common cause — unbounded loops.** Batch jobs that don't paginate correctly often loop over API calls "
            "faster than the rate limit allows. Add an explicit delay between requests: 100ms between calls stays "
            "well under all tier limits.\n\n"
            "**Common cause — multiple API keys sharing a limit.** Rate limits are per API key, not per IP. "
            "If you have multiple services using the same key, they share the limit. Generate separate keys per service.\n\n"
            "**Requesting a limit increase:** Open a support ticket (category: api) with your account ID and the "
            "specific endpoint and request volume you need. Enterprise accounts can typically get same-day increases."
        ),
    },
    {
        "title": "Troubleshooting: OAuth Token Refresh Loop",
        "category": "troubleshooting",
        "tags": ["oauth", "authentication", "token", "connector", "troubleshooting"],
        "content": (
            "An OAuth token refresh loop — where a connector repeatedly requests a new token without successfully "
            "using it — is caused by incorrect credential storage or a misconfigured token expiry.\n\n"
            "**Symptom:** Connector logs show repeated `token_refresh` events in rapid succession. "
            "The connector never completes a sync or API call before refreshing again.\n\n"
            "**Cause 1 — Client secret was rotated in the source system.** If you rotated your OAuth client secret "
            "in Salesforce, HubSpot, or another source, the connector is still using the old secret. "
            "Go to Integrations → [Connector] → Settings → Re-authenticate to provide the new credentials.\n\n"
            "**Cause 2 — Clock skew.** OAuth tokens include an `exp` (expiry) timestamp. If your server clock "
            "differs from our servers by more than 5 minutes, the token appears expired before it can be used. "
            "Verify your server is syncing with NTP.\n\n"
            "**Cause 3 — Token not persisted.** Some connector configurations don't persist the new token between "
            "requests. This is a platform bug for specific connector versions. Check if your connector version "
            "is current — go to Integrations → [Connector] → Version. If below 3.2.0, update it."
        ),
    },
    {
        "title": "Troubleshooting: Bulk Export Stalling on Large Datasets",
        "category": "troubleshooting",
        "tags": ["export", "bulk", "csv", "performance", "troubleshooting"],
        "content": (
            "Bulk exports that stall (show as 'Running' indefinitely) typically hit a memory or timeout limit "
            "on our export infrastructure.\n\n"
            "**Immediate workaround — paginate your export.** Instead of one large export, break it into multiple "
            "exports by date range, region, or another filter. Each export under 25,000 rows completes reliably. "
            "You can then concatenate the CSVs locally.\n\n"
            "**Check your export filters.** Exports with no filters against large datasets (>100k rows) are the "
            "most common cause of stalls. Always add at least a date range filter.\n\n"
            "**Use the async export API.** For programmatic large exports, use the `/v2/exports/async` endpoint "
            "instead of the UI. The async endpoint streams the result to an S3 URL you can download from. "
            "There's no row limit on async exports.\n\n"
            "**Known limit:** The UI export is capped at 100,000 rows. Requests above this limit silently stall "
            "rather than returning an error — this is a known UX bug. For datasets above 100k rows, use the "
            "async API or contact support to trigger a server-side export."
        ),
    },
    # BILLING
    {
        "title": "Understanding Your Invoice: Seat Counts and Billing Cycles",
        "category": "billing",
        "tags": ["billing", "invoice", "seats", "pricing"],
        "content": (
            "Precision Labs bills on a per-seat, per-month basis. Your invoice reflects the peak active seat count "
            "during the billing period.\n\n"
            "**What counts as a seat:** Any user account in an Active state counts as a seat, regardless of how "
            "often they log in. Pending (invited but not accepted) and Deactivated users do not count.\n\n"
            "**Deactivating users:** To stop billing for a user, go to Settings → Team → [User] → Deactivate. "
            "Deactivation takes effect immediately. If deactivated before the billing period ends, you'll receive "
            "a prorated credit on your next invoice.\n\n"
            "**Billing cycle:** Invoices are generated on the 1st of each month covering the prior month. "
            "Payment is due Net 30. Invoices are emailed to the billing contact on file and available under "
            "Settings → Billing → Invoice History.\n\n"
            "**Disputing an invoice:** If your invoice doesn't match your expected seat count, open a billing "
            "support ticket with your account ID and the invoice date. Include a screenshot of your current team "
            "list showing Active users. We review billing disputes within 2 business days."
        ),
    },
    {
        "title": "Updating Payment Method and Billing Contact",
        "category": "billing",
        "tags": ["billing", "payment", "credit-card", "invoice", "admin"],
        "content": (
            "Billing settings are managed under Settings → Billing. Only Admin users can view or modify billing.\n\n"
            "**Updating a credit card:** Go to Settings → Billing → Payment Method → Update. "
            "You'll be redirected to our payment processor (Stripe) to enter the new card. "
            "The old card is automatically removed after the new one is verified.\n\n"
            "**Note:** The payment method field in Settings → Billing may appear read-only if your account is "
            "managed through a reseller or through an annual contract paid by invoice. In those cases, "
            "contact your account executive or open a billing support ticket.\n\n"
            "**Updating the billing contact:** The billing contact receives invoices and payment receipts. "
            "Go to Settings → Billing → Billing Contact → Edit. This can be different from the account admin.\n\n"
            "**Adding a PO number:** Go to Settings → Billing → PO Number. Once set, the PO number appears on "
            "all future invoices. It does not retroactively apply to past invoices."
        ),
    },
    # API
    {
        "title": "API Overview: Authentication and Base URLs",
        "category": "api",
        "tags": ["api", "authentication", "api-key", "rest", "reference"],
        "content": (
            "The Precision Labs REST API allows you to programmatically read and write data, trigger reports, "
            "and manage your workspace.\n\n"
            "**Base URL:** `https://api.precisionlabs.io/v2`\n\n"
            "**Authentication:** All API requests require an `Authorization` header with your API key:\n"
            "`Authorization: Bearer YOUR_API_KEY`\n\n"
            "API keys are generated in Settings → API Keys. Each key can optionally be scoped to specific endpoints.\n\n"
            "**Rate limits:** See the Troubleshooting guide 'API Returning 429 Rate Limit Errors' for limits per tier.\n\n"
            "**Versioning:** The current stable version is v2. Version v1 is deprecated and will be removed 2027-01-01. "
            "Key differences from v1: response bodies now use a consistent `{data: ..., meta: ...}` envelope. "
            "See the v1-to-v2 Migration Guide for a complete field diff.\n\n"
            "**SDKs:** Official SDKs are available for Python (`pip install precision-labs-sdk`) and Node.js "
            "(`npm install @precisionlabs/sdk`). Community SDKs exist for Ruby and Go — see our GitHub org."
        ),
    },
    {
        "title": "API Pagination: Handling Large Result Sets",
        "category": "api",
        "tags": ["api", "pagination", "cursor", "rest", "reference"],
        "content": (
            "All list endpoints in the Precision Labs API are paginated. Requests without pagination parameters "
            "return a maximum of 100 records.\n\n"
            "**Pagination style:** We use cursor-based pagination (not page numbers). Each response includes a "
            "`next_cursor` field in the `meta` object. Pass this value as the `cursor` query parameter in your "
            "next request to get the following page.\n\n"
            "**Example:**\n"
            "`GET /v2/accounts?limit=100` → returns records 1-100 and `next_cursor: 'eyJpZCI6MTAwfQ'`\n"
            "`GET /v2/accounts?limit=100&cursor=eyJpZCI6MTAwfQ` → returns records 101-200\n\n"
            "When `next_cursor` is null or absent from the response, you've reached the last page.\n\n"
            "**Limit parameter:** The maximum `limit` per request is 500. Requests above 500 are silently capped "
            "at 500 — not rejected.\n\n"
            "**Filtering and sorting:** All list endpoints accept `filter[field]=value` and `sort=field` query "
            "parameters. Filtering happens server-side before pagination, so page sizes stay consistent."
        ),
    },
    {
        "title": "API v1 to v2 Migration Guide",
        "category": "api",
        "tags": ["api", "migration", "v2", "breaking-changes", "reference"],
        "content": (
            "The v2 API introduces a consistent response envelope and deprecates several v1 patterns. "
            "v1 will be removed 2027-01-01.\n\n"
            "**Breaking changes in v2:**\n\n"
            "1. **Response envelope.** v1 returned the resource directly as the root JSON object. "
            "v2 wraps it: `{\"data\": {...}, \"meta\": {\"request_id\": \"...\", \"next_cursor\": \"...\"}}`\n\n"
            "2. **Error format.** v1 errors: `{\"error\": \"message\"}`. "
            "v2 errors: `{\"errors\": [{\"code\": \"ERR_CODE\", \"detail\": \"message\", \"field\": \"optional\"}]}`\n\n"
            "3. **Renamed fields.** `created_at` → `created_date`, `updated_at` → `updated_date` (ISO 8601 format).\n\n"
            "4. **Pagination.** v1 used `page` and `per_page`. v2 uses cursor-based pagination with `cursor` and `limit`.\n\n"
            "5. **Deleted resources.** v1 returned 404 for deleted records. v2 returns the resource with "
            "`{\"deleted\": true, \"deleted_date\": \"...\"}` so consumers can detect deletions in polling loops.\n\n"
            "**Non-breaking additions in v2:** bulk operations, webhook management endpoints, async export API."
        ),
    },
    # FEATURES
    {
        "title": "Dashboards: Creating and Sharing Analytics Views",
        "category": "features",
        "tags": ["dashboard", "analytics", "sharing", "reports", "features"],
        "content": (
            "Dashboards are the primary way to visualize and share data in Precision Labs.\n\n"
            "**Creating a dashboard:** Go to Dashboards → New Dashboard. Add widgets by clicking the + button. "
            "Widgets can be charts, tables, KPI tiles, or text blocks. Each widget is backed by a query — "
            "you can edit the underlying query by clicking the widget's settings icon.\n\n"
            "**Sharing:** Click Share on any dashboard. Options:\n"
            "- **Share with workspace:** All workspace members can view (Editors can also duplicate).\n"
            "- **Share by link:** Generates a public link. Recipients don't need a Precision Labs account. "
            "Public links show a snapshot of data at the time of link generation — not live data.\n"
            "- **Embed:** Generates an iframe embed code for adding the dashboard to internal tools or portals.\n\n"
            "**Scheduled email delivery:** Any dashboard can be emailed on a schedule. Go to Dashboard → "
            "Share → Schedule Email. The email contains a PNG snapshot of the dashboard at send time, "
            "plus a link to the live version.\n\n"
            "**Dashboard filters:** Add global filters to the dashboard header so viewers can slice the data "
            "without editing the underlying queries. Filters apply to all widgets simultaneously."
        ),
    },
    {
        "title": "Alerts: Setting Up Threshold and Anomaly Notifications",
        "category": "features",
        "tags": ["alerts", "notifications", "monitoring", "threshold", "features"],
        "content": (
            "Precision Labs alerts notify you when data crosses a threshold or deviates from expected patterns.\n\n"
            "**Threshold alerts:** Go to Alerts → New Alert → Threshold. Select a metric, set the condition "
            "(greater than, less than, equals), and enter the threshold value. "
            "Example: `churn_risk_score > 0.8` for the accounts dataset.\n\n"
            "**Anomaly alerts:** Anomaly detection uses a 30-day rolling baseline to identify unusual spikes "
            "or drops. Go to Alerts → New Alert → Anomaly. Select the metric and sensitivity level "
            "(Low/Medium/High). High sensitivity generates more alerts but may have more false positives.\n\n"
            "**Notification channels:** Alerts can be sent via email, Slack webhook, or to our native webhook "
            "system (which can then trigger Zapier or other automations). Configure channels in Settings → "
            "Notifications.\n\n"
            "**Alert conditions:** Alerts have a 'cooldown' period (default: 1 hour) to prevent notification "
            "storms when a metric repeatedly crosses the threshold. Adjust this in the alert settings.\n\n"
            "**Alert history:** All triggered alerts are logged under Alerts → History regardless of whether "
            "a notification was successfully delivered."
        ),
    },
    {
        "title": "Reports: Scheduled Reports and Custom Date Ranges",
        "category": "features",
        "tags": ["reports", "scheduled", "export", "date-range", "features"],
        "content": (
            "Reports are saved queries that can be run on demand or on a schedule, and exported to CSV or PDF.\n\n"
            "**Creating a report:** Go to Reports → New Report. Select your dataset, add filters, and choose "
            "the columns to include. Click Preview to verify the output, then Save.\n\n"
            "**Date range options:** Reports support relative date ranges (last 7 days, last quarter, YTD) and "
            "absolute date ranges. For quarterly board decks, use absolute ranges to ensure consistent results "
            "regardless of when the report runs.\n\n"
            "**Performance note:** Reports covering more than 90 days against large datasets may take 2-5 minutes "
            "to generate. For reports over 90 days, we recommend scheduling them overnight and using the emailed "
            "result rather than waiting in the UI.\n\n"
            "**Scheduling:** Go to Reports → [Report Name] → Schedule. Set the frequency (daily, weekly, monthly), "
            "time, timezone, and recipient list. The report runs automatically and emails a link to results.\n\n"
            "**Export formats:** CSV exports include all columns including raw IDs. PDF exports include charts and "
            "are formatted for printing. Note: PDF export is only available on Mid-Market and Enterprise plans."
        ),
    },
    # SECURITY
    {
        "title": "Security: Data Encryption and Compliance Overview",
        "category": "security",
        "tags": ["security", "encryption", "compliance", "gdpr", "soc2"],
        "content": (
            "Precision Labs is SOC 2 Type II certified and GDPR compliant. This article summarizes our security posture.\n\n"
            "**Data encryption:** All data is encrypted at rest using AES-256 and in transit using TLS 1.2+. "
            "Encryption keys are managed by AWS KMS with annual rotation.\n\n"
            "**Data residency:** By default, all data is stored in AWS us-east-1. Enterprise accounts can request "
            "EU data residency (eu-west-1) for GDPR compliance. Data residency configuration happens at account "
            "setup — contact your account executive before signing if this is required.\n\n"
            "**GDPR:** Precision Labs acts as a data processor for any personal data you store in the platform. "
            "Our Data Processing Agreement (DPA) is available at precisionlabs.io/legal/dpa. "
            "To execute the DPA, email legal@precisionlabs.io with your company name and account ID.\n\n"
            "**SOC 2 report:** The full SOC 2 Type II report is available under NDA to Enterprise customers. "
            "Open a security support ticket to request it.\n\n"
            "**Penetration testing:** We conduct annual penetration tests via a third-party firm. "
            "Summary results are available on request."
        ),
    },
    {
        "title": "Security: Audit Logs and Access Monitoring",
        "category": "security",
        "tags": ["security", "audit", "logging", "compliance", "admin"],
        "content": (
            "Precision Labs logs all administrative actions to an immutable audit log. "
            "Audit logs are retained for 12 months (Enterprise: 24 months).\n\n"
            "**What is logged:** User logins (success and failure), user provisioning and deprovisioning, "
            "role changes, API key creation and revocation, data exports, integration configuration changes, "
            "and billing changes.\n\n"
            "**Accessing audit logs:** Go to Settings → Security → Audit Log. Filter by user, action type, "
            "or date range. Export to CSV for compliance reporting.\n\n"
            "**API access:** Audit logs are also accessible via the API at `/v2/audit-log`. "
            "This is useful for forwarding events to your SIEM (Splunk, Elastic, etc.).\n\n"
            "**Alerts on audit events:** You can configure alerts for specific audit events — for example, "
            "notify your security team whenever an Admin role is granted or an API key is created. "
            "Go to Settings → Security → Audit Alerts."
        ),
    },
]

# Pad to 150 articles by generating variations on existing templates
TITLE_VARIATIONS = [
    "Advanced {topic}: Tips for Power Users",
    "{topic}: Frequently Asked Questions",
    "{topic}: Common Errors and How to Fix Them",
    "{topic}: Best Practices",
    "{topic}: Step-by-Step Setup Guide",
    "How to Optimize Your {topic} Configuration",
    "Migrating to {topic}: What You Need to Know",
    "{topic}: What's New in the Latest Release",
]

TOPICS = [
    ("Salesforce integration", "integrations", ["salesforce", "crm", "integration"]),
    ("Snowflake connector", "integrations", ["snowflake", "data-warehouse", "integration"]),
    ("dashboard performance", "troubleshooting", ["dashboard", "performance", "optimization"]),
    ("user management", "onboarding", ["users", "admin", "onboarding"]),
    ("API authentication", "api", ["api", "authentication", "security"]),
    ("report scheduling", "features", ["reports", "scheduled", "email"]),
    ("webhook configuration", "integrations", ["webhooks", "events", "integration"]),
    ("data export", "features", ["export", "csv", "data"]),
    ("billing and invoices", "billing", ["billing", "invoice", "pricing"]),
    ("alert configuration", "features", ["alerts", "notifications", "monitoring"]),
    ("SSO and authentication", "security", ["sso", "saml", "authentication"]),
    ("data quality monitoring", "features", ["data-quality", "monitoring", "validation"]),
    ("API rate limits", "api", ["api", "rate-limit", "performance"]),
    ("custom dashboards", "features", ["dashboard", "customization", "analytics"]),
    ("integration health monitoring", "integrations", ["monitoring", "health", "integration"]),
    ("bulk data operations", "features", ["bulk", "import", "export"]),
    ("workspace settings", "onboarding", ["workspace", "admin", "configuration"]),
    ("team permissions", "onboarding", ["permissions", "rbac", "team"]),
    ("HubSpot connector", "integrations", ["hubspot", "crm", "integration"]),
    ("Postgres connector", "integrations", ["postgres", "database", "integration"]),
    ("Google Sheets integration", "integrations", ["google-sheets", "spreadsheet", "integration"]),
    ("CSV data import", "features", ["csv", "import", "data"]),
    ("account activity tracking", "features", ["activity", "audit", "monitoring"]),
    ("mobile access", "features", ["mobile", "app", "access"]),
    ("data retention policies", "security", ["retention", "compliance", "data"]),
    ("two-factor authentication", "security", ["2fa", "mfa", "security"]),
    ("IP allowlisting", "security", ["ip", "security", "network"]),
    ("custom report templates", "features", ["reports", "templates", "customization"]),
    ("API error handling", "api", ["api", "errors", "troubleshooting"]),
    ("connector version management", "integrations", ["version", "update", "connector"]),
]


def _make_variation_article(rng, idx, title_template, topic_name, category, tags):
    title = title_template.format(topic=topic_name)
    content = (
        f"This guide covers {title.lower()}. "
        f"Whether you're setting up {topic_name} for the first time or troubleshooting an existing configuration, "
        f"this article covers the key steps and common issues.\n\n"
        f"**Prerequisites:** You'll need Admin access to your Precision Labs workspace. "
        f"For integration-related topics, you'll also need appropriate credentials for the source system.\n\n"
        f"**Getting help:** If you encounter an issue not covered here, open a support ticket with category "
        f"'{category}' and include your account ID and a description of the error. "
        f"Our support team typically responds within 4 business hours for Mid-Market and Enterprise accounts.\n\n"
        f"**Related articles:** Search the KB for '{topic_name}' to find related guides. "
        f"You can also check our community forum at community.precisionlabs.io for user-contributed solutions."
    )
    return {
        "title": title,
        "category": category,
        "tags": tags,
        "content": content,
    }


def generate_articles(n=150, seed=42):
    rng = random.Random(seed)
    articles = list(ARTICLES)

    # Generate additional articles up to n
    idx = len(articles)
    while len(articles) < n:
        topic_name, category, tags = rng.choice(TOPICS)
        title_template = rng.choice(TITLE_VARIATIONS)
        art = _make_variation_article(rng, idx, title_template, topic_name, category, tags)
        # Avoid exact duplicate titles
        existing_titles = {a["title"] for a in articles}
        if art["title"] not in existing_titles:
            articles.append(art)
            idx += 1

    result = []
    start = date(2024, 1, 1)
    end = date(2026, 8, 1)
    for i, art in enumerate(articles[:n], start=1):
        result.append({
            "article_id": f"KB-{i:04d}",
            "title": art["title"],
            "category": art["category"],
            "tags": art["tags"],
            "content": art["content"],
            "last_updated": _random_date(rng, start, end).isoformat(),
            "view_count": rng.randint(50, 5000),
            "helpful_votes": rng.randint(5, 500),
        })
    return result


def _random_date(rng, start, end):
    delta = (end - start).days
    return start + timedelta(days=rng.randint(0, delta))


def index_articles(es_url, api_key, index_name=INDEX_NAME_DEFAULT, n=150, seed=42):
    from elasticsearch import Elasticsearch, helpers

    client = Elasticsearch(hosts=[es_url], api_key=api_key)
    client.indices.delete(index=index_name, ignore_unavailable=True)
    client.indices.create(index=index_name, mappings=MAPPINGS)

    articles = generate_articles(n=n, seed=seed)
    actions = (
        {"_index": index_name, "_id": a["article_id"], "_source": a}
        for a in articles
    )
    helpers.bulk(client, actions)
    client.indices.refresh(index=index_name)
    count = client.count(index=index_name)["count"]
    print(f"Indexed {count} articles into '{index_name}'.")
    return count


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--es-url", required=True)
    parser.add_argument("--api-key", required=True)
    parser.add_argument("--index", default=INDEX_NAME_DEFAULT)
    parser.add_argument("--count", type=int, default=150)
    args = parser.parse_args()
    index_articles(args.es_url, args.api_key, index_name=args.index, n=args.count)
