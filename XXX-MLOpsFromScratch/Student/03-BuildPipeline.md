# Challenge 2 – Create a Build Pipeline in Azure DevOps

## Prerequisites

1.  [Challenge\#1](01-TimeSeriesForecasting.md) (Build a Forecasting Model)
    should be done successfully

## Description

The Build pipeline demonstrates the automation of various stages/tasks involved
in building an ML model and creating a container image on top of that model. The
stages generally constitute creating a project environment, preparing the data,
training the model, evaluating the model, registering/versioning the model, and
scoring the model generally by containerizing the model.

There are several ways to create a Build pipeline. The 2 common and popular ways
are

-   using a YAML file that represents the entire pipeline,

-   using an empty job and adding tasks sequentially

We think that latter approach is more comprehensive and intuitive, especially to
get started on MLOps, so we recommend that.

We can setup Continuous Integration (CI) trigger for every Build pipeline. The
CI pipeline gets triggered every time code is checked in. It publishes an
updated Azure Machine Learning pipeline after building the code.

## Success criteria

1.  An end-to-end Build pipeline created from an empty job (from scratch) using
    the classic editor (without YAML) in Azure DevOps

2.  Forecasting model registered with the Azure ML Model Registry

3.  A container image for your model must be created under Azure ML Images

## Basic Hackflow

1.  If you haven’t already done this in
    [Challenge\#1](01-TimeSeriesForecasting.md), create and setup a new project
    in Azure DevOps

    1.  Import quickstart code from **github repo**

    2.  Create a new service connection for Azure ML service using service
        principal

    3.  Make sure your Azure ML workspace is configured for the project. Verify
        the details in configuration/config.json

2.  Create a Build pipeline

    1.  Use the classic editor to create a pipeline without YAML

    2.  Select the repo that was imported above

    3.  Create an Empty Job

3.  Setup Agent Job

    1.  Set Agent Pool to Azure Pipelines

    2.  Set Agent Specification to ubuntu-16.04

4.  Setup Build pipeline – Add the following tasks

    1.  Python version – 3.6

    2.  Bash task to setup environment using Script Path –
        install_environment.sh is the file used

    3.  Azure CLI task to get Azure ML Workspace connection – Workspace.py is
        the file used in the Inline Script

    4.  Azure CLI task to acquire time series transactions data – AcquireData.py
        is the file used in the Inline Script

    5.  Azure CLI task to train ARIMA model to forecast transactions –
        TrainOnLocal.py is the file used in the Inline Script

    6.  Azure CLI task to evaluate the model performance – EvaluateModel.py is
        the file used in the Inline Script

    7.  Azure CLI task to register the model in Azure ML Workspace for model
        versioning – RegisterModel.py is the file used in the Inline Script

    8.  Azure CLI task to score the model, to forecast future transactions –
        ScoreModel.pys is the file used in the Inline Script

    9.  Use Copy Files task to copy files to: \$(Build.ArtifactStagingDirectory)

    10. Publish Artifact: drop task – publish Build artifact to
        \$(Build.ArtifactStagingDirectory)

5.  Run the Build pipeline

6.  Review Build Artifacts

7.  Review Build Outputs

## Hints

## Learning resources

<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>

[Next challenge – Create a Release Pipeline](03-ReleasePipeline.md)
