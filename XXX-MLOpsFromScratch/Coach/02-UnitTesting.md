# Challenge 2 – Create a Unit Test in Azure DevOps

## Prerequisites

1.  [Challenge\#1](01-TimeSeriesForecasting.md) (Import Forecasting Project into Azure DevOps)
    should be done successfully

## Introduction

Use this challenge to perform tasks to confirm data has been extracted from
source and saved in the working directory

## Description

1.  If you haven’t already done this in
    [Challenge\#1](01-TimeSeriesForecasting.md), create and setup a new project
    in Azure DevOps

    1.  Import quickstart code from [Insert Github Repo Here]

    2.  Create new service connections in Project Settings for your Azure ML service and Azure Subscription using service
        principal

    3.  Make sure your Azure ML workspace is configured for the project.  
       - **Hint:** Add workspace details through Azure DevOps pipeline variables.
       - **Hint:** Add workspace details in config.json. You can download it from portal too.

2.  Write a Python snippet to validate that AdventureWorks data is indeed downloaded and extracted into Data folder. Do a preview of file count in the data folder. Additionally, you could also pick a csv file visualize the data.

## Success criteria

1.  Confirming the number of files extracted

2.  Visualizing and exploring the data

## Learning resources

<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>

[Next challenge – Create a Build Pipeline](03-BuildPipeline.md)

