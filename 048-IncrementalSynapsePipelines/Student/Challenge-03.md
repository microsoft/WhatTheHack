# Challenge 3 - Setup the Trigger to Automate the Incremental Load

[< Previous Challenge](Challenge-02.md) - **[Home](../README.md)** 

## Introduction

Now that we have created 2 pipelines:
- GetTableList-Trigger-Incremental-Copy
- GetTableList-Trigger-sp

How would we look to automate them?  What factors do we need to account for?

## Description

In this challenge your team will discuss / whiteboard various automating techniques and also factors that need to be accounted for when productionalizing an Incremental Pipeline. 

## Success Criteria

Be able to articulate the options of automating these pipelines and what factors do we need to account for not only with regards to:
- Change Data Capture on the source data. 
- What is the different between a watermark table and checking for the last "x" minutes.  What are the pros and cons of each?
- How would we factor in timing and determine when to update the production tables in the Dedicated SQL Pool? 
- What is the impact for downstream services such as reporting?

## Learning Resources

*The following links may be useful to achieving the success crieria listed above.*

- [Pipeline execution and triggers in Azure Data Factory or Azure Synapse Analytics](https://docs.microsoft.com/en-us/azure/data-factory/concepts-pipeline-execution-triggers)

- [Create a trigger that runs a pipeline on a schedule](https://docs.microsoft.com/en-us/azure/data-factory/how-to-create-schedule-trigger?tabs=data-factory)


## Advanced Challenges (Optional)

*Too comfortable?  Eager to do more?  Try these additional challenges!*

- Create one or more scheduled trigger(s) to automate both pipelines above.
