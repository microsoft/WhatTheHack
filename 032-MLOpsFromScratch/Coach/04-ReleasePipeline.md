# Challenge 4 – Create a Release Pipeline In Azure DevOps

[< Previous Challenge](./03-UnitTesting.md) - **[Home](./README.md)** - [Next Challenge >](./05-RetrainingAndEvaluation.md)


## Solution

1.  Create a Release pipeline with an empty Job

2.  Add Build Artifact that you created in the [previous
    challenge](03-BuildPipeline.md)

3.  Setup Agent Job

    1.  Set Agent Pool to Azure Pipelines

    2.  Set Agent Specification to ubuntu-16.04

4.  Setup Release pipeline – Create a new pipeline, edit the pipeline and add the following tasks (similar to what you have in the Build pipeline)

    1.  Python version – 3.6

    2.  Bash task to setup environment using `install_environment.sh` file

    3.  Azure CLI task to deploy the scoring image on ACI using `deployOnAci.py` file

    4.  Azure CLI task to test the ACI web service using `AciWebserviceTest.py` file.

5. A “healthy” ACI deployment will be created under Azure ML Endpoints. It contains a Scoring URI/Endpoint. 
