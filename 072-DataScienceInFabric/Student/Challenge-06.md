# Challenge 06 - Deploy the model to an AzureML real-time endpoint

[< Previous Challenge](./Challenge-05.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-07.md)

## Introduction
In Challenge 5 you created a PowerBI report showing which patients are at risk. However, part of the requirements of this solution is for an app to be able to obtain real-time predictions based on some input data. To do so, you will export and host in AzureML your previously trained ML Model so that you can serve it through an API endpoint. 

**NOTE**: you will make use of an AzureML workspace for this challenge. You must deploy a workspace if you didn't previously do so with the hack deployment script.

## Description

You have been tasked to deploy the machine learning model which you have trained in Microsoft Fabric to Azure ML learning for real time inference.  In this challenge, you will deploy a Fabric model to Azure Machine Learning, and repurpose the model trained in Fabric for use by applications via scalable Azure compute clusters. The ability to export and repurpose models trained with MLFlow in Fabric opens endless opportunities! This challenge does **not** require the use of a notebook. 

By the end of this challenge, you should be able to understand and know how to use:
- MLFlow exported models, what the different files represent and how you can import them to a new location.
- AzureML real-time endpoints, how to create one with a custom model and how to use it via an API call.

**NOTE**: due to some compatibility issues with MLFlow and Azure Machine Learning, you will need to modify some files locally before uploading your model to Azure Machine Learning. Once you have downloaded your model from Fabric, unzip the folder and open both the `conda.yaml` and `requirements.txt` files. Change the MLFlow version on both files to `2.7.0`. Save and close both files.

## Success Criteria

To complete this challenge, please verify that :
  - ML model is ready and downloaded from Microsoft Fabric.
  - Deployed Successfully on Azure ML real-time endpoints.
  - Deployed model is predicting the heart failure prediction. Test the API call both within the AzureML studio and with Postman.


## Learning Resources
  - [Difference between Data science in Fabric and Azure Machine Learning](https://www.linkedin.com/pulse/comparing-microsoft-fabric-azure-machine-learning-which-kim-berg)
  - [How to deploy MLFlow model to Azure Machine learning](https://learn.microsoft.com/en-us/azure/machine-learning/how-to-deploy-mlflow-models-online-endpoints?view=azureml-api-2&tabs=studio)

## Tips

- Fabric stores everything you create as items in the workspace.
- Make sure you unzip the folder you will download from Fabric
- Once the AzureML endpoint is deployed, explore the example code snippets to understand what you need to send an inference API call
    
