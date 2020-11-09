# Challenge 2 – Create a Unit Test in Azure DevOps

## Prerequisites

1.  [Challenge\#1](01-TimeSeriesForecasting.md) (Import Forecasting Project into Azure DevOps)
    should be done successfully

## Description

Use this challenge to perform tasks to confirm data has been extracted from
source and saved in the working directory

## Success criteria

1.  Confirming the number of files extracted

2.  Visualizing and exploring the data

## Basic Hackflow

1.  If you haven’t already done this in
    [Challenge\#1](01-TimeSeriesForecasting.md), create and setup a new project
    in Azure DevOps

    1.  Import quickstart code from **github repo**

    2.  Create a new service connection for Azure ML service using service
        principal
        
    3.  Clone project in VS Code

    4.  Make sure your Azure ML workspace is configured for the project. Hint: Either using system variables in Azure DevOps or by adding details in configuration/config.json file 

2.  Write a Python snippet to validate that AdventureWorks data is indeed downloaded and extracted into Data folder. 

## Hints

## Learning resources

<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>

[Next challenge – Create a Build Pipeline](03-BuildPipeline.md)
