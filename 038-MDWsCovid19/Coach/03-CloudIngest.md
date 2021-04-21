# Challenge 3: Coach's Guide

[< Previous Challenge](./02-Provision.md) - **[Home](README.md)** - [Next Challenge >](./04-OnPremIngest.md)

The second challenge is to extract the Cloud COVID-19 data 
from Azure SQL databases and a Cosmos DB collection.
The goal of this challenge is to get the team up and running with a data movement solution.

### Provisioning data movement and orchestration

In this hack, we recommend using Azure Data Factory.

#### Alternative Setups

We strongly advise you to use Azure Data Factory, but there are alternative
options.

- DataBricks
- ADF with Data Flow
- SSIS

#### A note on SSIS

Coaches should encourage teams
to take advantage of this opportunity to dive into modern tooling.

That said, attendees may come in with substantial investments in
SSIS skills and a desire to continue leveraging the existing SSIS packages
in their organization. Coaches can help these attendees understand the idea
of "lifting and shifting" their SSIS packages to run in Azure, and/or
to orchestrate them with Azure Data Factory via the SSIS-IR.
In this way, the skills and legacy packages for data movement and cleansing
can be leveraged, even as the organization moves toward the "bottom up"
mindset of the modern data warehouse.

### Gotchas and Pitfalls

#### Array of objects

Teams must use caution when bringing in data from Cosmos that is in Arrays of objects because it will come in as one big line of data. 


##### Option 1 - each line of output is a single JSON object

Choose the JSON format and the Set of objects pattern when defining the sink,
and do not attempt to import schemas.
This will bring the data over with a JSON object on each line of the file.
The file will not be valid JSON, but each line of the file will be a valid JSON object.

![Specifying a JSON set of objects for the ADLS Gen2 JSON sink](./images/adf-adls-sink-json-objects.jpg)


##### Option 2 - the file is a JSON array; each line starts with leading syntax

Choose the JSON format and the Array of objects pattern when defining the sink,
and do not attempt to import schemas.

![Specifying a JSON array of objects for the ADLS Gen2 JSON sink](./images/adf-adls-sink-json-array.jpg)

When taking this approach the first two lines of the output file will look like the following.
Note that every line begins with **either a leading bracket, or a leading comma.**
These leading characters can be easily ignored in subsequent processing.
Futhermore, the closing bracket is on its own, separate line at the end of the file,
so it will not disrupt processing of the final object.
