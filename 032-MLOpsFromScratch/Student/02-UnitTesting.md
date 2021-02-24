# Challenge 2 – Create a Unit Test in Azure DevOps

[< Previous Challenge](./01-TimeSeriesForecasting.md) - **[Home](../README.md)** - [Next Challenge >](./03-BuildPipeline.md)

## Introduction

Use this challenge to perform tasks to confirm data has been extracted from
source and saved in the working directory

## Description

1.  Make sure you have created a new project in Azure DevOps, created new service connections and have Azure ML workspace configured for the project using config.json file.

2.  Write a Python snippet to validate that AdventureWorks data is indeed downloaded and extracted into `Data_and_Code/Data/` folder. Do a preview of file count in the data folder. Additionally, you could also pick a csv file visualize the data.
    - **HINT:** It is encouraged to leverage the Python Script task using the pipeline task manager in Azure DevOps

## Success criteria

1.  Count the number of CSV files extracted into `Data_and_Code/Data/` folder using a Python script in Azure DevOps pipeline. (This can be the same script used in Challenge#1)
    
2.  Visualizing and exploring the data (using a python visualization library like `matplotlib` or `seaborn` or `plotly`)

## Learning resources

-   <https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>
-   https://azure.microsoft.com/en-us/services/machine-learning/mlops/
-   https://azure.microsoft.com/en-us/blog/how-to-accelerate-devops-with-machine-learning-lifecycle-management/



