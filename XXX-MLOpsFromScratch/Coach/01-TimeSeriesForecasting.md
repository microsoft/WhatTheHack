# Challenge 1 – Start Project and Import Repo into Azure DevOps

[< Previous Challenge](./00-prereqs.md) - **[Home](../README.md)** - [Next Challenge >](./02-UnitTesting.md)

## Introduction

The objective of challenge is to forecast the daily transactions using time
series
[ARIMA](https://en.wikipedia.org/wiki/Autoregressive_integrated_moving_average)
modeling. It includes processing the transactions data from AdventureWorks
database, analyzing it, creating and registering an ARIMA model, and finally
deploying the model to an ACI instance. This entire lifecycle is done using
[Azure ML Python SDK](https://docs.microsoft.com/en-us/python/api/overview/azure/ml/?view=azure-ml-py).

Time series is a series of data points collected or indexed in time order at
regular time points. It is a sequence taken at successive equally spaced time
points. For example, weather data collected every hour or stock data collected
every day or sensor data collected every minute. As a result, we see a trend and
seasonality in time-series datasets. It is this temporal nature that makes them
different from other conventional datasets and warrants a different type of
modeling. We will cover that in this challenge as forecasting is one of the
most common and prevalent tasks in Machine Learning.

## Description

1.  Create and setup a new project in Azure DevOps

    1.  Import quickstart code from "EnterRepoURLHere"

    2.  [Create new service connections](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) in Project Settings for your Azure ML service and Azure Subscription using service
        principal
        
2.  Clone into VS Code and run the projects files locally to understand the forecasting project and explore the different files available.

3.  Install library requirements to setup your environment inside VS Code Terminal or equivalent Shell application:  
    _pip install -r ./environment_setup/requirements.txt_

3.  Configure your Azure ML Workspace for the project.

    - **Hint:** Add workspace details through Azure DevOps pipeline variables.
    - **Hint:** Add workspace details in config.json. You can download it from portal too.

4.  Now that you have environment setup, explore and run locally the python files in the
    following order to train an ARIMA forecasting model

    1.  Workspace.py to setup connection with your Azure ML service workspace.

    2.  AcquireData.py to get daily transactions data from AdventureWorks.

    3.  TrainOnLocal.py to train the model. Explore and run
        transactions_arima.py file to understand how ARIMA model was built.

    4.  EvaluateModel.py to evaluate the model.

    5.  RegisterModel.py to register the model with Model registry.

    6.  ScoreModel.py for scoring/forecasting using the trained model.

    7.  deployOnAci.py to deploy the scoring image on ACI.

    8.  WebserviceTest.py to the ACI deployment/endpoint.
    

## Learning resources

-   https://azure.microsoft.com/en-us/services/machine-learning/mlops/
-   https://azure.microsoft.com/en-us/blog/how-to-accelerate-devops-with-machine-learning-lifecycle-management/
