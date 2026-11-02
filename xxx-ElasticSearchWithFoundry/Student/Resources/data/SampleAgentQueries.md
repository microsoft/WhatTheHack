# Sample Support Agent Queries

These prompts are grounded in the Precision Labs dataset in this folder. They exercise a support agent's ability to retrieve and combine information from three indexes:

| Index | Content |
|---|---|
| `precision-crm-accounts` | Customer account tier, annual recurring revenue (ARR), churn risk, customer success owner, and renewal date |
| `precision-support-tickets` | Customer issues, ticket status and priority, assigned support agent, resolutions, and customer satisfaction scores |
| `precision-kb-articles` | Setup guides, troubleshooting procedures, API documentation, and product guidance |

## Cross-Index Queries

These prompts combine customer context, ticket history, and documented guidance.

### Account Support Briefing

> Prepare a support briefing for customer CUST-0085 (Northstar Partners). Include their account tier, annual recurring revenue, churn risk, customer success owner, and unresolved tickets. Find relevant knowledge base guidance for their issues, and identify any gaps in the documentation.

### Prioritize At-Risk Customers

> Find Enterprise customers with a churn risk score of at least 0.7 and unresolved integration or performance tickets. Rank customers by annual recurring revenue, show their critical or high-priority tickets, and recommend next steps using relevant knowledge base articles.

### Investigate API Rate Limits

> Investigate TICK-02392. Check the customer's CRM account tier, find the documented API rate limits for that tier, and look for similar resolved tickets. Recommend a response, distinguishing standard limits from any customer-specific exceptions.

### Troubleshoot Missing Snowflake Data

> Review TICK-01708 and its customer account. Compare the ticket description and recorded resolution with the Snowflake incremental sync article. What troubleshooting steps are supported by the evidence, and what should we clarify with the customer?

### Resolve Stalled Exports

> For TICK-01544, summarize the customer's account context and reported export problem. Find the bulk export troubleshooting article and similar resolved tickets. Draft a support reply with recommended steps and any conditions that require escalation.

### Investigate Duplicate Records

> Review TICK-01512. Find the customer's CRM record, related Salesforce duplicate-record tickets, and the relevant knowledge base article. Recommend a resolution path and explain whether the historical fixes apply to this case.

### Diagnose OAuth Failures

> Investigate TICK-00711 using the customer's account context, the OAuth token refresh troubleshooting article, and similar resolved tickets. Separate confirmed facts from possible causes, and list the information needed before recommending a fix.

### Prepare a Customer Success Handoff

> For customers owned by Dana Reyes, find unresolved critical or high-priority tickets. Include each customer's annual recurring revenue and churn risk, summarize the issue, and link relevant knowledge base guidance. Prioritize the handoff by ticket severity, then churn risk.

## Focused Retrieval Queries

Use these simpler prompts to check individual retrieval paths before combining all three indexes.

### Knowledge Base: Okta SSO

> Our Okta SSO login fails with a provisioning error. Which SAML attributes are required, and how should we test the configuration before rolling it out?

### Knowledge Base: Snowflake Incremental Sync

> Our Snowflake incremental sync is missing rows. What cursor-column checks should we perform?

### Support Tickets: Unresolved Integration Issues

> Find unresolved critical and high-priority integration tickets. Show ticket ID, account ID, company, assigned support agent, and a short issue summary.

### CRM and Support Tickets: Low Satisfaction at At-Risk Accounts

> Which customers with churn risk scores of at least 0.7 have resolved tickets with customer satisfaction scores of 1 or 2? Show their customer success owner and summarize the ticket history.

### Support Tickets and Knowledge Base: Conflicting API Key Rotation Guidance

> Compare historical ticket resolutions about API key rotation with the knowledge base article. Do they disagree about the grace period? Cite both sources and flag what needs confirmation before we advise a customer.

### CRM and Knowledge Base: Custom Role Eligibility

> Check the account tier for CUST-0085 and explain whether custom permission roles are supported. Use the role-based access control article to describe the request process.

## Suggested Evidence Instruction

Append this instruction to any prompt for more trustworthy answers:

> Cite ticket IDs, customer IDs, and KB article IDs or titles. Distinguish documented guidance from historical ticket resolutions. If sources conflict or information is missing, say so rather than inventing an answer.



## Dataset Notes

- The example IDs above come from the default seed-42 data. Different generation settings can change the records associated with those IDs.
- Ticket creation dates span January 1, 2025 through August 1, 2026. Use explicit historical dates rather than relative phrases such as "last month."
- Company names can repeat. Use customer IDs to identify accounts reliably.
- Link support tickets to CRM accounts using ticket `account_id` and CRM `customer_id`.
- Treat `open` and `in_progress` tickets as unresolved, and `resolved` and `closed` tickets as resolved.
- CRM `arr` means annual recurring revenue in USD, not array length.
- Ticket subjects, bodies, and resolutions are sampled independently. Ask the agent to reconcile inconsistencies rather than assuming every recorded resolution matches the reported issue.
