---
name: free-events-endpoint
description: Use when creating or updating a free events endpoint
---

# Free Events Endpoint

1. Filter events where `price === 0`
2. Filter events within the next 7 days
3. Exclude invalid or incomplete entries
4. Sort results by date ascending
5. Return `{ count, events }`