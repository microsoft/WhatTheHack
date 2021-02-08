# Challenge 4 – Create a Release Pipeline In Azure DevOps

[< Previous Challenge](./03-BuildPipeline.md) - **[Home](../README.md)** - [Next Challenge >](./05-RetrainingAndEvaluation.md)


## Solution

1.  Create a Release pipeline with an empty Job

2.  Add Build Artifact that you created in the [previous
    challenge](03-BuildPipeline.md)

3.  Setup Agent Job

    1.  Set Agent Pool to Azure Pipelines

    2.  Set Agent Specification to ubuntu-16.04

4.  Setup Release pipeline – Add the following tasks

    1.  Python version – 3.6

    2.  Bash task to setup environment using Script Path –
        install_environment.sh is the file used

    3.  Azure CLI task to deploy the scoring image on ACI – `deployOnAci.py` is
        the file used in the Inline Script

    4.  Azure CLI task to test the ACI web service – `WebserviceTest.py` is the
        file used in the Inline Script

5. A “healthy” ACI deployment will be created under Azure ML Endpoints. It contains a Scoring URI/Endpoint. 
