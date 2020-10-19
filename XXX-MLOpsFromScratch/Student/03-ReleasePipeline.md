Challenge 3 – Create a Release Pipeline In Azure DevOps
=======================================================

Prerequisites
-------------

1.  Challenge 2 – Create a Build Pipeline should be done successfully.

2.  Build artifact ready to be used in the Release pipeline.

Introduction
------------

The Release pipeline demonstrates the automation of various stages/tasks
involved in deploying an ML model and operationalizing the model in production.
The stages generally constitute collecting the Build Artifacts, creating a web
service and testing the web service. This web service that gets created in the
Release Pipleline is a REST endpoint (a Scoring URI) used to predict/forecast on
a new dataset. Additionally, it can be plugged into business applications to
leverage the intelligence of the model.

There are several ways to create a Release pipeline. The 2 common and popular
ways are

-   using a YAML file that represents the entire pipeline,

-   using an empty job and adding tasks sequentially

We think that latter approach is more comprehensive and intuitive, especially to
get started on MLOps, so we recommend that.

We can setup Continuous Deployment (CID) trigger for every Release pipeline. The
pipeline shows how to operationalize the scoring image and promote it safely
across different environments. 

Success Criteria
----------------

1.  An end-to-end Release pipeline created from an empty job (from scratch)
    using the classic editor (without YAML) in Azure DevOps

2.  A “healthy” ACI deployment is created under Azure ML Endpoints

Basic Hackflow
--------------

1.  Create a Release pipeline with an empty Job

2.  Add Build Artifact that you created in the previous challenge

3.  Setup Agent Job

    1.  Set Agent Pool to Azure Pipelines

    2.  Set Agent Specification to ubuntu-16.04

4.  Setup Release pipeline – Add the following tasks

    1.  Python version – 3.6

    2.  Bash task to setup environment using Script Path –
        install_environment.sh is the file used

    3.  Azure CLI task to deploy the scoring image on ACI – deployOnAci.py is
        the file used in the Inline Script

    4.  Azure CLI task to test the ACI web service – WebserviceTest.py is the
        file used in the Inline Script

Hints
-----

Learning resources
------------------

-   <https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>

Next challenge – Retraining and Model Evaluation
