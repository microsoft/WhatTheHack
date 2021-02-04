# Challenge 3 – Create a Build Pipeline in Azure DevOps

[< Previous Challenge](./02-UnitTesting.md) - **[Home](../README.md)** - [Next Challenge >](./04-ReleasePipeline.md)


## Introduction

The Build pipeline demonstrates the automation of various stages/tasks involved
in building an ML model and creating a container image on top of that model. The
stages generally constitute creating a project environment, preparing the data,
training the model, evaluating the model, registering/versioning the model, and
scoring the model generally by containerizing the model.

There are several ways to create a Build pipeline. The two most common and popular ways
are:

-   using a YAML file that represents the entire pipeline,

-   using an empty job and adding tasks sequentially

We believe that the latter approach is more comprehensive and intuitive, especially to
get started on MLOps, so we recommend that route.  This will be the focus of this hack.

We can setup Continuous Integration (CI) trigger for every Build pipeline. The
CI pipeline gets triggered every time code is checked in. It publishes an
updated Azure Machine Learning pipeline after building the code.

## Description

1.  Make sure you have setup a new project, imported the code, created service connections, and configured Azure ML Workspace for the project.

2.  Create a Build pipeline

    1.  Use the classic editor to create a pipeline without YAML

    2.  Select the repo that was imported in the previous challenge

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
       -**Note:** If you see issues with version 2.0 of Azure CLI, use version 1.0

    4.  Azure CLI task to acquire time series transactions data – AcquireData.py
        is the file used in the Inline Script

    5.  Azure CLI task to train ARIMA model to forecast transactions –
        TrainOnLocal.py is the file used in the Inline Script

    6.  Azure CLI task to evaluate the model performance – EvaluateModel.py is
        the file used in the Inline Script

    7.  Azure CLI task to register the model in Azure ML Workspace for model
        versioning – RegisterModel.py is the file used in the Inline Script

    8.  Azure CLI task to score the model, to forecast future transactions –
        ScoreModel.py is the file used in the Inline Script
        
    9.  At this point, you have the option of choosing an artifact for your Release pipeline (An artifact is the deployable component of your applicaton/model). If you like to use Build Artifact, then you have two following steps to perform in Build pipeline. 
        - Use Copy Files task to copy files from $(Build.SourcesDirectory) to $(Build.ArtifactStagingDirectory)
        - Use Publish Artifact task with $(Build.ArtifactStagingDirectory) as path to publish. 
        Note: Alternatively, you have more Artifact options such as Model Artifact that you could use if you want to go that route.

5.  Run the Build pipeline

6.  Review Build Outputs - confirm that the model and azure container image have been registered in the [Azure ML workspace](https://ml.azure.com/) in respective registries.


## Learning resources

-   https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops
-   <https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>
