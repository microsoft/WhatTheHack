# Challenge 1 – Create and Evaluate Time Series Forecasting Model

## Prerequisites

All prerequisites from the README file.

## Introduction

The objective of challenge is to forecast the daily transactions using time
series ARIMA modelling. It includes processing the transactions data from
Adventure Works database, analyzing it, creating and registering an ARIMA model,
and finally deploying the model to an ACI instance. This entire lifecycle is
done using Azure ML Python SDK.

Time series is a series of data points collected or indexed in time order at
regular time points. It is a sequence taken at successive equally spaced time
points. For example, weather data collected every hour or stock data collected
every day or sensor data collected every minute. As a result, we see a trend and
seasonality in time series datasets. It is this temporal nature that makes them
different from other conventional datasets and warrants a different type of
modelling. We will cover that in this challenge as forecasting is one of the
most common and prevalent tasks in Machine Learning.

## Success Criteria

1.  An ARIMA forecasting model saved in Azure ML Workspace

## Hackflow

1.  Create and setup a new project in Azure DevOps

    1.  Import quickstart code from **github repo**

    2.  Create a new service connection for Azure ML service using service
        principal

2.  Clone in VS Code

3.  Make sure the default terminal/shell is “cmd”. Do “az login” to connect to
    your Azure subscription.

4.  Environment Setup

    1.  Create a conda environment using: *conda create -n forecast_mlops
        python==3.6.5*

    2.  Activate your conda environment: *conda activate forecast_mlops*

    3.  Install library requirements to setup your conda sssenvironment:  
        *pip install -r ./environment_setup/requirements.txt*

5.  Configure your Azure ML Workspace for the project. Add workspace details in
    config.json in Configuration folder

6.  Now that you have environment setup, run and explore the python files in the
    following order to train an ARIMA forecasting model

    1.  Workspace.py to setup connection with your Azure ML service workspace

    2.  AcquireData.py to get daily transactions data from AdventureWorks

    3.  TrainOnLocal.py to train the model local. Explore and run
        transactions_arima.py file to understand how ARIMA model is built

    4.  EvaluateModel.py to evaluate the model

    5.  RegisterModel.py to register the model with Model registry

    6.  ScoreModel.py for scoring/forecasting using the trained model.

    7.  deployOnAci.py to deploy the scoring image on ACI

    8.  WebserviceTest.py to the ACI deployment/endpoint.

## Alternate Hackflow

## Hints

## Learning resources

Next Challenge – Create a Build Pipeline in Azure DevOps
