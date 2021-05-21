# Challenge \#6 - Conditional Access - Are You Who You Say You Are?

[< Previous Challenge](./05-claims-enrichment.md) - **[Home](./README.md)** - [Next Challenge>](./07-admin-graph.md)
## Introduction
This challenge allows your team to create a few Conditional Access policies and then enable them in their User Flows.

This is a pretty straightforward challenge and shouldn't take long to implement. If your team is new Conditional Access, you may want them to review the concepts of Conditional Access and walk them through the B2C portal where CA policies are created.

## Hackflow

1. This challenge should be quick once the team is up to speed on Conditional Access policies.
2. Create a Conditional Access Policy that is enforced on a single application (your app registration), for all users EXCEPT Global Admins (so you don't lock yourself out), and only on Android devices. Make sure that your team sets the Action to Grant and with MFA.
3. Create another policy, but this time for any device but only for Medium and High Risk Users. To enable this, your B2C tenant must be at P2 license level (which is set in the home subscription, on the Overview page). The action for this CA policy is BLOCKED.
4. Modify your SUSI User Flow to enable Conditional Access policy evaluation.
5. Test this out using an Android emulator (Dev Tools in Chrome can do this) and also by using a browser like a Tor Browser to simulate Med/High User Risk.
6. Take a look at the Risky User reports after a few minutes.
