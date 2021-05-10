# Challenge 4 – Create a Release Pipeline In Azure DevOps

[< Previous Challenge](./03-UnitTesting.md) - **[Home](../README.md)** - [Next Challenge >](./05-RetrainingAndEvaluation.md)


## Introduction

The Release pipeline demonstrates the automation of various stages/tasks
involved in deploying an ML model and operationalizing the model in production.
The stages generally constitute collecting the Build Artifacts, creating a web
service and testing the web service. This web service that gets created in the
Release Pipeline is a REST endpoint (a Scoring URI) used to predict/forecast on
a new dataset. Additionally, it can be plugged into business applications to
leverage the intelligence of the model.

There are several ways to create a Release pipeline. The two most common and popular
ways are: 

-   Using a YAML file that represents the entire pipeline,

-   Using an empty job and adding tasks sequentially

As we had mentioned in the previous challenge, we believe that the latter approach is more comprehensive and intuitive, especially to get started on MLOps, so we recommend that route.

We can setup Continuous Deployment (CID) trigger for every Release pipeline. The
pipeline shows how to operationalize the scoring image and promote it safely
across different environments.

## Description

1.  Create a Release pipeline with an **Empty Job**

2.  Add Build Artifact that you created in the [previous
    challenge](03-BuildPipeline.md)

3.  Setup Agent Job

    1.  Set Agent Pool to `Azure Pipelines`

    2.  Set Agent Specification to `ubuntu-16.04`

4.  Setup Release pipeline – Add the following tasks

    1.  Python version – 3.6

    2.  Add a task to setup environment by using `install_environment.sh` file in `environment_setup/` folder. This will install all the python modules required to deploy the forecasting model.

    3.  Add a task to deploy the scoring image on ACI using `deployOnAci`.py in `service/code/` folder. A “healthy” ACI deployment will be created under Azure ML Endpoints. It contains a REST-based Scoring URI/Endpoint that you can call using Postman or Swagger. 
        -   **NOTE:** ACI is recommended to use testing or pre-production stages. Since bigger inferencing compute is needed in production for low latency and high throughput, it is recommended to use AKS cluster in production.

    4.  Add a task to test the ACI web service using `AciWebserviceTest.py` in `service/code/` folder. This allows you to run the web service on new data (or test data) to forecast demand for new items. 
        -   **NOTE:** If the deployment fails or the web service is "unhealthy", check logs in Azure DevOps or Azure ML Studio for issues and additional information.
 
## Success Criteria

1.  An end-to-end Release pipeline created from an empty job (from scratch)
    using the classic editor (without YAML) in Azure DevOps

2.  A “healthy” ACI deployment is created under Azure ML Endpoints, which can be confirmed to be operational by using a tool like [Postman](https://www.postman.com) or [Swagger](https://swagger.io).

## Learning resources

-   [Key concepts for new Azure Pipelines users](<https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops>)
-   [Release Pipelines general resources](https://docs.microsoft.com/en-us/azure/devops/pipelines/release/?view=azure-devops)
-   [MLOps documentation: Model management, deployment, and monitoring with Azure Machine Learning](<https://docs.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment>)
-   [MLOps Reference Architecture](<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>)



