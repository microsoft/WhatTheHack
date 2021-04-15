# Challenge 5: Coach's Guide

[< Previous Challenge](./04-OnPremIngest.md) - **[Home](README.md)** - [Next Challenge >](./06-Calculate.md)

In this challenge, the team will find that they need to combine the data;
it is up to them to preprocess it to be consistent for downstream consumers.

The goal is to transform the heterogenous data into homogenous datasets; i.e.,

- Downstream consumers have a "one-stop shop" for the data,
no matter how many source systems are fed into the lake today (or tomorrow)
- Downstream consumers can trust that data types within the datasets are consistent
- Each record in this new dataset has a marker for which source system the raw data had come from
- The raw data is left as-is

The team could end up with a new folder in their data lake called something like `conformed`.

We recommend 6 datasets which line up with facts and dimensions:
   
    - Cases
    - Deaths
    - Recoveries
    
    - Policies
    - Geography
    - Date

### Version Control Rules:

- Developers cannot push changes directly to the main branch.  
    - In Github the repository will need to be public to accomplish this.
- Changes are reviewed with at least one explicit approval from another developer before being incorporated into the main branch.

Branch Protection steps:
    Settings>Branches>Add rule>
- Require Pull request reviews before merging.
- Require review from code owners.
- Include administrators to enforce for administrators 
