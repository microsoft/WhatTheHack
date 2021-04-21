# Challenge 1: Background

**[Home](../README.md)** - [Next Challenge >](./02-Provision.md)

Caladan is a midsize commonwealth with a total population of 3.2 million with two urban population centers in Duncan and Stillgard.
The Coronavirus has not hit the commonwealth hard yet, but commonwealth leaders are concerned of a next wave as we move into spring.
The government leaders need your help to create a policy plan for mitigation of this next wave.  

The government leaders would like to answer one simple question:
What is the most unrestricitive policies they can implement to keep growth rate of deaths below 1% and the growth rate of new cases below 3% on a 30 day average?
To accomplish this the Commonwealth has hired you and a team of consultants to analyze the global policies implemented by 10 represenatative countries to determine efficacy in keeping down Death and Cases growth rates.

## Your Task

Your team will need to create a solution that extracts, cleans, loads and analyzes this current data.
The solution needs to consider future use and expansion and be automated to run when new data is added and must kept and updated in source control.  

Your job:
1. Create an enterprise Modern Data Pipeline solution that can be used for analysis and reporting by Caldan health and leadership officials
2. Make a recommendation on policies to implement to meet the growth rate thresholds
3. Document the solution business process and architecture
4. Put the solution under source control so others can take over from where you leave off

The data you need is located in three places in your Azure environment:

1. Policy data is located in a Cosmos DB (SQL API)
2. Half of your countries are on a Virtual Machine within your environment to simulate pulling data from an on-premises data source
3. The other half of your data is located in Azure SQL

The credentials for your environment.

- **VM Username**    vmadmin
- **VM Password**   Password.1!!
- **SQL Username**   sqladmin
- **SQL Password**  Password.1!!