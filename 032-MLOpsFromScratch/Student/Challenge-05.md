# Challenge 5 – Retraining and Model Evaluation

[< Previous Challenge](./Challenge-04.md) - **[Home](../README.md)**

## Introduction

When the new data deviates from the original trained data that the model was trained, the model performance deteriorates. This concept, known as model drift, can be mitigated by retraining the model when new data becomes available, to reflect the current reality.

In Azure DevOps, you can retrain the model on a schedule or when new data becomes available. The machine learning pipeline orchestrates the process of retraining the model in an asynchronous manner. A simple evaluation test compares the new model with the existing model. Only when the new model is better does it get promoted. Otherwise, the model is not registered with the Azure ML Model Registry.

## Description

- To retrain your model, update the training code with new data.
    - Pull up the training code in `transactions_arima.py` in `scripts/training/` folder. The initial model was trained on 2013 transactions data.
    - Along with 2013 data, also read 2014 transactions data that was created in `service/code/AcquireData.py`.
    - Concatenate these two datasets/dataframes and build an ARIMA trained model on this bigger dataset.
- Re-run the `Build` pipeline to reflect the changes in training.
- Re-run the `Release` pipeline. If the new model has better evaluation metrics than the previous model, then a new web service is created for your retrained model.
- Review artifacts and outputs from `Build` and `Release` pipelines.

## Success criteria

- A retrained model (if necessary with better performance) is created and registered within the Azure ML Model Registry.
- A container image for your retrained model is created under Azure ML Images.
- A “healthy” ACI deployment for your retrained model is created under Azure ML Endpoints.

## Learning resources

- [MLOps documentation: Model management, deployment, and monitoring with Azure Machine Learning](<https://docs.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment>)
- [MLOps Reference Architecture](<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>)

## Congratulations

You have finished the challenges for this Hack. We are updating the content continuously. In the upcoming phase 2 of this hack content we will be extending this solution to encompass AKS Data Drift in Challenge 5 as well as incorporate other ML platforms, such as ONNX and mlflow. Stay tuned!
