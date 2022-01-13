# Challenge 3 – Create a Unit Test Locally and in Azure DevOps

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

Use this challenge to perform tasks to confirm data has been extracted from source and saved in the working directory.

## Description

- Write a Python snippet to validate that AdventureWorks data is indeed downloaded and extracted into `Data/` folder. Do a preview of file count in the data folder. Additionally, you could also pick a csv file visualize the data.

## Success criteria

- Count the number of CSV files extracted into `Data/` folder using a `Python script` in Azure DevOps pipeline. (This can be the same script used in [Challenge-01](./Challenge-01)).    
- Visualizing and exploring the data (using a python visualization library like `matplotlib` or `seaborn` or `plotly`).

## Tips
  
- Use the `Python Script` task in your `Build` pipeline to run the unit test.

## Learning resources

- [MLOps Home page to discover more](<https://azure.microsoft.com/en-us/services/machine-learning/mlops/>)
- [MLOps documentation: Model management, deployment, and monitoring with Azure Machine Learning](<https://docs.microsoft.com/en-us/azure/machine-learning/concept-model-management-and-deployment>)
- [A blog on MLOps - How to accelerate DevOps with ML Lifecycle Management](<https://azure.microsoft.com/en-us/blog/how-to-accelerate-devops-with-machine-learning-lifecycle-management/>)
- [MLOps Reference Architecture](<https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/ai/mlops-python>)
