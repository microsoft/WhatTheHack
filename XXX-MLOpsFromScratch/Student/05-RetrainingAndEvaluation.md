# Challenge 5 – Retraining and Model Evaluation

## Prerequisites

1.  [Challenge\#4 (Create a Release Pipeline)](04-ReleasePipeline.md) should be
    done successfully

## Introduction

When the new data deviates from the original trained data that the model was
trained model, the model performance deteriorates. This concept, known as model
drift, can be mitigated by retraining the model when new data becomes available,
to reflect the current reality.

In Azure DevOps, you can retrain the model on a schedule or when new data
becomes available. The machine learning pipeline orchestrates the process of
retraining the model in an asynchronous manner. A simple evaluation test
compares the new model with the existing model. Only when the new model is
better does it get promoted. Otherwise, the model is not registered with the
Azure ML Model Registry.

## Description

1.  To retrain your model, update the training code with new data

    1.  Pull up the training code in transactions_arima.py in scripts/training
        folder. The initial model was trained on 2013 transactions data.

    2.  Along with 2013 data, also read 2014 transactions data that was created
        in service/code/AcquireData.py

    3.  Concatenate these two datasets/dataframes and build an ARIMA trained
        model on this bigger dataset

2.  Rerun the Build pipeline to reflect the changes in training

3.  Rerun the Release pipeline. If the new model has better evaluation metrics
    than the previous model, then a new webservice is created for your retrained
    model.

4.  Review artifacts and outputs from Build and Release pipelines

## Success criteria

1.  A retrained model (with better performance) is created and registered with
    Azure ML Model Registry

2.  A container image for your retrained model is created under Azure ML Images

3.  A “healthy” ACI deployment for your retrained model is created under Azure
    ML Endpoints

## Learning resources

<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>

[Next challenge (Optional) – Monitor Data Drift for your Model](06-MonitorDataDrift.md)
