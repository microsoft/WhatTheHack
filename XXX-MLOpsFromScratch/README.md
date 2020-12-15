# What The Hack – MLOps

## Introduction

MLOps empowers data scientists and app developers to help bring ML/AI models to
production. It enables you to track, version and re-use every asset in your ML
lifecycle, and provides orchestration services to streamline managing this
lifecycle. This hack will help you understand how to build a Continuous
Integration and Continuous Delivery (CICD) pipeline for an AI application using
Azure DevOps and Azure Machine Learning.

The solution involved in the hack is built on a time series dataset from
Adventure Works to forecast daily transactions. Hence it is a forecasting task
but the CICD process can be easily adapted for any AI scenario.

## Learning Objectives

In this hack you will solve a common challenge for companies to continuously
deploy an AI model and maintain it in production. You will see how you can adopt
standard engineering practices around DevOps and CICD process on ML lifecycle to
get real business value.

You are working with some very talented Data Scientists who have trained an ARIMA forecasting model on monthly sales data from their successful company, AdventureWorks. However, they are getting complaints from upper management that their model is only able to run locally on a laptop and results are pushed out through a spreadsheet. Additionally, whenever new sales months come in, they need to offline the model and retrain it locally before they can push out the new results.

The CIO of the company would like to push the model training, scoring, and deployment to a more collaborative team within DevOps and allow for the model to be consumed by an endpoint. The CIO would also like to monitor the model on a regular basis and test for data drift and model decay. Additionally, the CIO would like the existing model to remain live in production even while the retraining process is occurring.

Your team may not be a bunch of data scientists at heart, but you understand what is going on from a conceptual level.  You have been given the python scripts that were used for the modeling, now you need to make sense of it and start finding a way to get it into Azure DevOps.

Here are some questions that you might have:

- What is time series data and time series forecasting?

  - How is that different from conventional ML modeling?

  - How is a forecasting task different from other tasks?

- How to enable Continuous Integration for our AI project by creating a Build
  pipeline? What artifacts do we deploy into the repo and what is our
  architecture end state?

- How to enable Continuous Delivery for our AI project by creating a Release
  pipeline? How do we automate our ML lifecycle and score our data?

- What is retraining? How to evaluate the best model between the current model
  and previous models?

- How to convert a model into an endpoint?

- How to identify Data Drift?

Your team will have individuals of varying skill sets, so it is imperative to decide who will take on the following roles:
(1) Data Scientist
(2) ML Engineer
(3) DevOps Engineer
(4) Data/Business Analyst

## Challenges

1.  [Challenge 1 = Incorporate your locally trained machine learning code into Azure DevOps](Student/01-TimeSeriesForecasting.md)

2.  [Challenge 2 = Create a Unit Test in Azure
    DevOps](Student/02-UnitTesting.md)

3.  [Challenge 3 = Create a Build pipeline in Azure
    DevOps](Student/03-BuildPipeline.md)

4.  [Challenge 4 = Create a Release pipeline in Azure
    DevOps](Student/04-ReleasePipeline.md)

5.  [Challenge 5 = Retraining and Model
    Evaluation](Student/05-RetrainingAndEvaluation.md)

6.  [Challenge 6 = Model Monitoring and Data Drift](Student/06-MonitorDataDrift.md)

## Prerequisites

- Azure subscription. If you do not have one, you can sign up for a [free
  trial](https://azure.microsoft.com/en-us/free/).

- Azure DevOps subscription. If you do not have one, you can sign up for a
  [free account](https://azure.microsoft.com/en-us/services/devops/).

  - Install [Azure DevOps Machine Learning
    extension](https://marketplace.visualstudio.com/items?itemName=ms-air-aiagility.vss-services-azureml)

- Azure Machine Learning service workspace. It is a foundational resource in
  the cloud that you use to experiment, train, and deploy machine learning
  models.

- Python Installation, version at least \>= 3.6.5. Anaconda is more preferred
  for Data Science tasks (This is only required if you wish to test scripts on a local machine or a notebook on Azure).

  - Anaconda - <https://docs.anaconda.com/anaconda/install/windows/>

  - Miniconda - <https://docs.conda.io/en/latest/miniconda.html>

  - <https://www.python.org/downloads/release/python-3611/>

- Visual Studio Code

  - Python extensions

> **Note**: You will need privileges to create projects on the DevOps account.
> Also, you need privileges to create Service Principal in the tenet. This
> translates to **Ensure that the user has 'Owner' or 'User Access
> Administrator' permissions on the Subscription**.

## Repository Contents

## Contributors

- Shiva Chittamuru

- Ahmed Sherif

- Phil Coachman

- Jason Virtue
