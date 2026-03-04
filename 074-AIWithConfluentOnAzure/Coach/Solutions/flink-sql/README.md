
## Data Pipeline Overview

The goal of the pipeline is to ensure that 
- the data from the source datastores (Cosmos and Blob store) flows into Kafka topics
- the data from the topics are joined and merged into transient tables
- the data from the transient tables to finalized into the summary topics and tables
- the data from the summary tables and pushed out to Azure AI search for the AI agent to use via MCP

### Steps to Follow

You will need to run each DDL statement first to set up the Flink Tables.

Note that each Flink table also maps to a Kafka Topic in Confluent cloud. You can browse these topics as well to see the raw data in the topics.

You will then need to run the DML statements to pull data from various topics/tables and push them to the final tables that will go out to Azure AI Search via the sink connectors.

### Location of SQL Statements

The DDL statements are in this folder. Run them one at a time in the Flink SQL Workspace in Confluent Cloud.

It would be nice to run these from the Confluent CLI.

The DML statements that pull from single or multiple sources/topics into the final topics/tables are also available in this folder

### AI Search Sink Configuration

Make sure that the topics in the AI Search Sink connector matches the corresponding final topic/table.

Make sure that the AI Search index name is also correct. The MCP service depends on this correctness to fetch the correct data.



