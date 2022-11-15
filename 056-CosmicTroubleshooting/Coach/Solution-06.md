# Challenge 06 - Securing the Data - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)**

## Notes & Guidance

For this challenge, the students will need to present various ways that they can ensure their Azure Cosmos DB deployment doesn't just serve the application as a backend database but has all the accompanying components to ensure an Enterprise grade deployment. Students should rely on the Reliability and Operational Excellence pillar of Microsoft Azure Well-Architected Framework to evaluate what is needed in the context of this solution. At a minimum:
- Azure Cosmos DB and the application are deployed in the region that corresponds to end users. This is already done but what should they consider for future expansion?
- Implications of conflict resolution in multi-master deployments.
- Should they re-evaluate the default Consistency level and are there any operations that require unique consistency constraints? For example, submitting the order could be at a higher consistency level than the other operations.
- Configuring preferred locations
- Monitoring (already set-up, what should they thing about alerting).
- Do they need to re-think the throughput type?
- How would they handle a failure in a region?
- Should they evaluate caching? Dedicated cache is a feature to consider in this case.

They should also think about security considerations. Some points that should be discussed:
- Deploy their Azure Cosmos DB in a private network instead of having it publicly accessible.
- How are the clients authenticating? Is this optimal? If they opt for key-based authentication, how will they handle key rotation? If they opt for Azure AD authentication, how will they handle access to the database?
- What happens if they want to recover data? What is the backup/restore strategy (at the time of the writing, Continuous mode - which would be preferred - is not yet supported for multi-region deployments).
- Attack monitoring. Have they enabled Audit logging and Activity logs? Have they enabled Threat Protection with Microsoft Defender for Cloud?
- Would the solution benefit from data encryption methodologies? What would be the implication of Always Encrypted and what are the trade-offs?
