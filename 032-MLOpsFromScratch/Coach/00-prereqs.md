# Challenge 0: Pre-requisites

**[Home](./README.md)** - [Next Challenge >](./01-TimeSeriesForecasting.md)

## Solution 

In this challenge we'll be setting up all the tools we will need to complete our challenges, preferably done a few days before the event. Additionally, we have a [presentation](MLOps%20Lectures.pptx) that can be used to help give a high level introduction to MLOps for the students, at both a general level as well as at an Azure level.  Finally, we have a [data and code](Data_and_Code.zip) set that will need to be uploaded to the Teams channel for the students to download and reference in the upcoming challenges. 

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

5.  Upload [data and code](Data_and_Code.zip) to the Teams Channel for the students to access for upcoming challenges.

6.  Download [presentation](MLOps%20Lectures.pptx) locally to present to the students.

