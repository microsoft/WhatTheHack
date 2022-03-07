# What The Hack – MLOps From Scratch

## Introduction

MLOps empowers data scientists and app developers to help bring ML/AI models to production. It enables you to track, version and re-use every asset in your ML lifecycle, and provides orchestration services to streamline managing this lifecycle. This hack will help you understand how to build a Continuous Integration and Continuous Delivery (CICD) pipeline for an AI application using Azure DevOps and Azure Machine Learning.

The solution involved in the hack is built on a time series dataset from Adventure Works to forecast daily transactions. Hence it is a forecasting task but the CICD process can be easily adapted for any AI scenario.

## Learning Objectives

In this hack you will solve a common challenge for companies to continuously deploy an AI model and maintain it in production. You will see how you can adopt standard engineering practices around DevOps and CICD process on ML lifecycle to get real business value.

You are working with some very talented Data Scientists who have trained an [ARIMA (Auto Regressive Integrated Moving Average)](https://en.wikipedia.org/wiki/Autoregressive_integrated_moving_average) forecasting model on monthly sales data from their successful company, AdventureWorks. However, they are getting complaints from upper management that their model is only able to run locally on a laptop and results are pushed out through a spreadsheet. Additionally, whenever new sales months come in, they need to offline the model and retrain it locally before they can push out the new results.

The CIO of the company would like to push the model training, scoring, and deployment to a more collaborative team within DevOps and allow for the model to be consumed by an endpoint. The CIO would also like to monitor the model on a regular basis and test for data drift and model decay. Additionally, the CIO would like the existing model to remain live in production even while the retraining process is occurring.

Your team may not be a bunch of data scientists at heart, but you understand what is going on from a conceptual level.  You have been given the python scripts that were used for the modeling, now you need to make sense of it and start finding a way to get it into Azure DevOps.

Here are some questions that you might have:

  - What is time series data and time series forecasting?
  - How is that different from conventional ML modeling?
  - How is a forecasting task different from other tasks?
  - How to enable Continuous Integration for our AI project by creating a Build pipeline? 
  - What artifacts do we deploy into the repo and what is our architecture end state?
  - How to enable Continuous Delivery for our AI project by creating a Release pipeline? 
  - How do we automate our ML lifecycle and score our data?
  - What is retraining? 
  - How to evaluate the best model between the current model and previous models?
  - How to convert a model into an endpoint?
  - How to identify Data Drift?

Your team will have individuals of varying skill sets, so it is imperative to decide who will take on the following roles:
1. Data Scientist
2. ML Engineer
3. DevOps Engineer
4. Data/Business Analyst

## Challenges

-  Challenge 0: **[Prerequisities](Student/Challenge-00.md)**
-  Challenge 1: **[Run model locally & and import repo into Azure DevOps](Student/Challenge-01.md)**
-  Challenge 2: **[Create a Build pipeline in Azure DevOps](Student/Challenge-02.md)**
-  Challenge 3: **[Create a Unit Test in Azure DevOps](Student/Challenge-03.md)**
-  Challenge 4: **[Create a Release pipeline in Azure DevOps](Student/Challenge-04.md)**
-  Challenge 5: **[Retraining and Model Evaluation](Student/Challenge-05.md)**

## Contributors

- Shiva Chittamuru
- Ahmed Sherif
- Phil Coachman
- Jason Virtue
- Jordan Bean
