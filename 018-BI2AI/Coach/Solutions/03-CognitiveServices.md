# Challenge 3 - Working with Cognitive Services

## Prerequisites

1. [Challenge 2 - Working with Data in Power BI](./02-Dataflows.md) should be done successfully.


## Introduction

The purpose of this challenge is to show users how to operationalize cognitive services in Power BI Dataflows.


## Basic Steps to Complete
1. Edit the existing dataflow and import a new entity to include the Bike Reviews data
1. Enter the connection information for the csv/text file from a url
1. Add an AI step to the data flow to detect language using the review text
1. Expand the structured results of the cognitive service to retrieve the language and language iso code
1. Add another AI step to score sentiment using the review text and the language iso code as inputs
1. Add another AI step to extract key phrases using the review text and language iso code as inputs
1. Save, close, and refresh the data dataflow
1. In Power BI Desktop import the new bike reviews entity from the data flow source, and examine the results

## Potential pitfalls

1.  Sometimes dataflows will have a sequencing problem that causes the dataflow to change prior to the AI logic being applied.   If this occurs, you'll need to cancel your save and start over on applying the AI.  Best bet is to save after each AI step to be safe.


[Next challenge (Building Machine Learning in Power BI) >](./04-PowerBIAutoML.md)