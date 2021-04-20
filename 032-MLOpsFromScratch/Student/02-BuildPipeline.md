# Challenge 2 – Create a Build Pipeline in Azure DevOps

[< Previous Challenge](./01-TimeSeriesForecasting.md) - **[Home](../README.md)** - [Next Challenge >](./03-UnitTesting.md)

## Introduction

The Build pipeline demonstrates the automation of various stages/tasks involved
in building an ML model and creating a container image on top of that model. The
stages generally constitute creating a project environment, preparing the data,
training the model, evaluating the model, registering/versioning the model, and
scoring the model generally by containerizing the model.

There are several ways to create a Build pipeline. The two most common and popular ways
are:

-   Using a YAML file that represents the entire pipeline,

-   Using an empty job and adding tasks sequentially

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

    3.  Create an **Empty Job**

3.  Setup Agent Job

    1.  Set Agent Pool to `Azure Pipelines`

    2.  Set Agent Specification to `ubuntu-16.04`

4.  Setup Build pipeline – Add the following tasks by clicking "+"

    1.  Python version – 3.6

    2.  Add a task to setup environment by using `install_environment.sh` file in `environment_setup/` folder. This will install all the python modules required for the project.
        -   **HINT:** Use a command line task that allows you to run the shell script.

    3.  Add a task to get Azure ML Workspace connection using `Workspace.py` in `service/code/` folder. This will establish connection to Azure ML workspace by using your workspace details in `configuration/config.json` file.         
        -   **HINT:** Use a command line task that allows you to run the python script.        
        -   **NOTE:** In case you see issues with the latest versions of any task, try a previous version and see if that resolves the issue. 

    4.  Add a task to acquire time series transactions data using `AcquireData.py` in `service/code/` folder. This will download and extract the data required to train a forecasting model in the next steps.

    5.  Add a task to train ARIMA forecasting model using `TrainOnLocal.py` in `service/code/` folder. This will build a model to forecast demand of items from AdventureWorks database.

    6.  Add a task to evaluate the model performance using `EvaluateModel.py` in `service/code/` folder. This will evaluate how well the model is doing by using evaluation metrics such as R-squared and RMSE(Root mean squared error).

    7.  Add a task to register the model in Azure ML Model Registry for model versioning using `RegisterModel.py` in `service/code/` folder. 
    
    8.  Add a task to score the model, to forecast future transactions using `CreateScoringImage.py` in `service/code/` folder. This will create a scoring file 
        
    9.  Now you are at a point of creating an artifact for your Release pipeline. An artifact is the deployable component of your model or application. Build Artifact is one of the many artifact types. The following two tasks are required to create Build artifact in your Build pipeline. 
        - Use Copy Files task to copy files from `$(Build.SourcesDirectory)` to `$(Build.ArtifactStagingDirectory)`
        - Use Publish Artifact task with `$(Build.ArtifactStagingDirectory)` as path to publish. 
        **NOTE:** Alternatively, you have more Artifact options such as Model Artifact that you could use if you want to go that route.

5.  Run the Build pipeline

6.  Review Build Outputs - confirm that the model and azure container image have been registered in the [Azure ML workspace](https://ml.azure.com/) in respective registries.

## Success criteria

1.  An end-to-end Build pipeline created from an empty job (from scratch) using
    the classic editor (without YAML) in Azure DevOps

2.  Forecasting model registered with the Azure ML Model Registry


## Learning resources

-   [Key concepts for new Azure Pipelines users](<https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops>)
-   [MLOps documentation: Model management, deployment, and monitoring with Azure Machine Learning](<https://docs.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment>)
-   [MLOps Reference Architecture](<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>)



