# Challenge 1 – Run model locally & and import repo into Azure DevOps

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Introduction

The objective of challenge is to forecast the daily transactions using time series [ARIMA](https://en.wikipedia.org/wiki/Autoregressive_integrated_moving_average) modeling. It includes processing the transactions data from AdventureWorks database, analyzing it, creating and registering an ARIMA model, and finally deploying the model to an ACI instance. This entire lifecycle is done using [Azure ML Python SDK](https://docs.microsoft.com/en-us/python/api/overview/azure/ml/?view=azure-ml-py).

Time series is a series of data points collected or indexed in time order at regular time points. It is a sequence taken at successive equally spaced time points. For example, weather data collected every hour or stock data collected every day or sensor data collected every minute. As a result, we see a trend and seasonality in time-series datasets. It is this temporal nature that makes them different from other conventional datasets and warrants a different type of modeling. We will cover that in this challenge as forecasting is one of the most common and prevalent tasks in Machine Learning.

## Description

- Create and setup a new project in Azure DevOps.
  - Import project files from the `Data_and_Code.zip` file your instructor provides.
  - [Create new service connections](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) in Project Settings for your Azure ML service and Azure Subscription using Azure Resource Manager service principal. This will enable you to connect to external and remote services to execute tasks in a pipeline.
- Clone into VS Code and run the projects files locally to understand the forecasting project and explore the different files available.    
  **NOTE:** This is the data science part. The focus of this hack is **not** on data science, but more on MLOps to help you understand how you can apply DevOps practices and principles to accelerate your ML projects and increase the efficiency, quality, and consistency of your ML workflows.
- Install library requirements to setup your environment.
- Configure your Azure ML Workspace for the project.
  - **HINT:** Add workspace details in `config.json`. You can download it from portal too.
  - **NOTE:** Alternatively, you can configure your Azure ML Workspace by using Azure DevOps pipeline variables.
- Now that you have environment setup, explore and run locally the python files in the folder `service/code/`. What are these files trying to do? What should be the order of execution? 

## Success Criteria

- Understand the contents of the python files under `service/code/`.
- Count the number of CSV files extracted into `Data/` folder LOCALLY using a Python script in VS Code or any popular IDE.
- Creating an ARIMA model locally using VS Code.
- Forecasting project imported into Azure DevOps.

## Learning resources

- [MLOps Home page to discover more](<https://azure.microsoft.com/en-us/services/machine-learning/mlops/>)
- [MLOps documentation: Model management, deployment, and monitoring with Azure Machine Learning](<https://docs.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment>)
- [A blog on MLOps - How to accelerate DevOps with ML Lifecycle Management](<https://azure.microsoft.com/en-us/blog/how-to-accelerate-devops-with-machine-learning-lifecycle-management/>)
