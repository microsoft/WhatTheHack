# What The Hack | Bronze-Silver-Gold Using Synapse and Databricks

## Introduction

With many customers moving towards a modern three-tiered Data Lake architecture it is imperative that we understand how to utilize Synapase and Databricks to build out the bronze, silver and gold layers to serve data to Power BI for dashboards and reporting while also ensuring that the bronze and silver layers are being hydrated correctly for ML/AI workloads.

![picture alt](img/WTH.png)

## Learning Objectives

In this hack you will be solving the common big data architecture issue of bringing multiple data sources together, standardizing them in a Delta format, and serving them up to Power BI for dashboards and reporting.  You will get hands on with Azure Synapse and Databricks so that you understand the similarities and differences between them and how they both can collaborate on the same data, including Delta technology.

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Understand the basics of Synapse
	 - Understand the basics of Databricks
	 - Understand Delta Lake Concepts
	 - Understand the basics of Key Vault
	 - Understand Data Lake Best Practices
- Challenge 01: **[Building out the Bronze](Student/Challenge-01.md)**
	 - Standup and configure the Synapse and Databricks Environments
	 - Agree on and begin to implement the three-tiered architecture 
	 - Hydrate the Bronze Data Lake
	 - Ensure no connection details are stored on the Linked Service or in Notebooks
- Challenge 02: **[Standardizing on Silver](Student/Challenge-02.md)**
	 - Move the data from the Bronze Layer to the Silver Layer 
	 - Apply Delta Format to the Silver Layer
	 - Perform consolidation and standardization
- Challenge 03: **[Go for the Gold](Student/Challenge-03.md)**
	 - Take data from the Silver Layer and make it business analyst ready
	 - Understand the basics of data models
- Challenge 04: **[Visualize the Results](Student/Challenge-04.md)**
	 - Create Power BI assets to showcase your results

## Prerequisites

- Your own Azure subscription with Owner access
- Willingness to get your hands dirty and learn from your colleagues
- A wicked cool Teams background.  There will be prizes for each day

## Contributors

- [Jack Bender](https://www.linkedin.com/in/jack-bender/)
- [Farhan Arif](https://www.linkedin.com/in/frhnarif/)
