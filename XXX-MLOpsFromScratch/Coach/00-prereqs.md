# Challenge 0: Pre-requisites

**[Home](../README.md)** - [Next Challenge >](./01-TimeSeriesForecasting.md)

## Solution 

In this challenge we'll be setting up all the tools we will need to complete our challenges, preferably done a few days before the event.

1.  Azure subscription. If you do not have one, you can sign up for a [free trial](https://azure.microsoft.com/en-us/free/).  

2.  [Azure Machine Learning service workspace](https://ml.azure.com/) - It is a foundational resource in
    the cloud that you use to experiment, train, and deploy machine learning
    models.

3.  Azure DevOps subscription. If you do not have one, you can sign up for a
    [free account](https://azure.microsoft.com/en-us/services/devops/).

    - Install [Azure DevOps Machine Learning
      extension](https://marketplace.visualstudio.com/items?itemName=ms-air-aiagility.vss-services-azureml)

    - Request Admin access to [create Service Connections](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) within Azure DevOps to connect with Azure ML Workspace. If the access is not granted, have admin create those service connections ahead of time. To do that, create new service connections in Project Settings for your Azure ML service and Azure Subscription using service principal. 
    Note: Azure ML Workspace must be created first before creating Service Connections. 
  
4.  Python Installation, version at least \>= 3.6.5. Anaconda is more preferred
    for Data Science tasks.

    - Anaconda - <https://docs.anaconda.com/anaconda/install/windows/>

    - Miniconda - <https://docs.conda.io/en/latest/miniconda.html>

    - <https://www.python.org/downloads/release/python-3611/>

5.  Visual Studio Code or any Python IDE

      - Python extensions

    **Note**: You will need privileges to create projects on the DevOps account.
    Also, you need privileges to create Service Principal in the tenet. This
    translates to **Ensure that the user has 'Owner' or 'User Access
    Administrator' permissions on the Subscription**.

