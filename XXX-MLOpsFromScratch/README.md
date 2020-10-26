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

-   What is time series data and time series forecasting?

    -   How is that different from conventional ML modelling?

    -   How is forecasting task different from other tasks?

-   How to enable Continuous Integration for our AI project by creating a Build
    pipeline? What artifacts do we deploy into the repo and what is our
    architecture end state?

-   How to enable Continuous Delivery for our AI project by creating a Release
    pipeline? How do we automate our ML lifecycle and score our data?

-   What is retraining? How to evaluate the best model between the current model
    and previous models?

-   How to create a Power BI Report that leverages REST API to score this model
    in Production?

## Challenges

1.  [Challenge 1 = Build forecasting AI Model using Notebooks or VS
    Code](Student/01-TimeSeriesForecasting.md)

2.  [Challenge 2 = Create a Build pipeline in Azure
    DevOps](Student/02-BuildPipeline.md)

3.  [Challenge 3 = Create a Release pipeline in Azure
    DevOps](Student/03-ReleasePipeline.md)

4.  [Challenge 4 = Retraining and Model
    Evaluation](Student/04-RetrainingAndEvaluation.md)

5.  Challenge 5 (Optional) = Monitor Data Drift for your Model

## Prerequisites

-   Azure subscription. If you do not have one, you can sign up for a [free
    trial](https://azure.microsoft.com/en-us/free/).

-   Azure DevOps subscription. If you do not have one, you can sign up for a
    [free account](https://azure.microsoft.com/en-us/services/devops/).

    -   Install [Azure DevOps Machine Learning
        extension](https://marketplace.visualstudio.com/items?itemName=ms-air-aiagility.vss-services-azureml)

-   Azure Machine Learning service workspace. It is a foundational resource in
    the cloud that you use to experiment, train, and deploy machine learning
    models.

-   Python Installation, version at least \>= 3.6.5. Anaconda is more preferred
    for Data Science tasks.

    -   Anaconda - <https://docs.anaconda.com/anaconda/install/windows/>

    -   Miniconda - <https://docs.conda.io/en/latest/miniconda.html>

    -   <https://www.python.org/downloads/release/python-3611/>

-   Visual Studio Code

    -   Python extensions

>   **Note**: You will need privileges to create projects on the DevOps account.
>   Also, you need privileges to create Service Principal in the tenet. This
>   translates to **Ensure that the user has 'Owner' or 'User Access
>   Administrator' permissions on the Subscription**.

## Repository Contents

## Contributors

-   Shiva Chittamuru

-   Ahmed Sherif

-   Phil Coachman

-   Chris Kahrs

-   Jason Virtue

-   Anthony Franklin
