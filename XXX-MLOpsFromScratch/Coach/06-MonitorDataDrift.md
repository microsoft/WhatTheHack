# Challenge 6 (Optional) – Monitor Data Drift for your Model

## Prerequisites

1.  [Challenge\#5 (Retraining and Model
    Evaluation)](05-RetrainingAndEvaluation.md) should be done successfully

## Introduction

As new data comes in over time, our trained models become obsolete which warrants retraining of our models over time. Data drift helps in understanding how training data changes over time. By collecting model data from deployed models, we can look for differences between training and serving datasets, and track how statistical properties in data change over time. We can also set alerts on data drifts for early warnings to potential issues. This information helps in scheduling and automating our retraining process.

## Description

1.  To retrain your model, update the training code with new data

    1.  Pull up the training code in transactions_arima.py in scripts/training
        folder. The initial model was trained on 2013 transactions data
        
## Success criteria

1.  A retrained model (with better performance) is created and registered with
    Azure ML Model Registry

2.  A container image for your retrained model is created under Az

## Learning resources

<https://docs.microsoft.com/en-us/azure/machine-learning/how-to-monitor-datasets>

or

<https://docs.microsoft.com/en-us/azure/machine-learning/how-to-use-mlflow-azure-databricks>
