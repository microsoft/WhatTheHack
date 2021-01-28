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

    2.  [Create new service connections](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) in Project Settings for your Azure ML service and Azure Subscription using service
        principal

    3.  Make sure your Azure ML workspace is configured for the project.         
       - **Hint:** Add workspace details in config.json. You can download it from portal too.
       - **Hint:** Alternatively, add workspace details through Azure DevOps pipeline variables.

2.  Write a Python snippet to validate that AdventureWorks data is indeed downloaded and extracted into Data folder. Do a preview of file count in the data folder. Additionally, you could also pick a csv file visualize the data.
    - **Hint:** It is encouraged to leverage the Python Script task using the pipeline task manager in Azure DevOps

## Success criteria

1.  Count the number of CSV files extracted into /Data folder using a Python script in Azure DevOps pipeline. (This can be the same script used in Challenge#1)
    
2.  Visualizing and exploring the data (using a python visualization library like matplotlib or seaborn or dash)

## Learning resources

<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>

[Next challenge – Create a Build Pipeline](03-BuildPipeline.md)

