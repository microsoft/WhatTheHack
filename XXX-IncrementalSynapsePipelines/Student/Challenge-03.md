# Challenge #3 - Setup the trigger to automate the incremental load

[< Previous Challenge](Challenge-02.md) - **[Home](../README.md)** 

## UNDER CONSTRUCTION

## Pre-requisites

*Complete the [Previous Challenge](Challenge-02.md).*

## Description

Now that we have created 2 pipelines:
- GetTableList-Trigger-Incremental-Copy
- GetTableList-Trigger-sp

How would we look to automate them?  What factors do we need to account for?

## Success Criteria

Be able to discuss the options of automating these pipelines and what factors do we need to account for not only with regards to the (1) Change Data Capture on the Azure SQL side, but (2) how would we factor in timing and account for changes in the Dedicated SQL Pool production tables. 

What is the impact to this for downstream services such as Power BI?

## Learning Resources

*The following links may be useful to achieving the success crieria listed above.*

- [Pipeline execution and triggers in Azure Data Factory or Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/data-factory/concepts-pipeline-execution-triggers)

- [Create a trigger that runs a pipeline on a schedule](https://docs.microsoft.com/en-us/azure/data-factory/how-to-create-schedule-trigger?tabs=data-factory)


## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

- Create one or more scheduled trigger(s) to automate both pipelines above.
