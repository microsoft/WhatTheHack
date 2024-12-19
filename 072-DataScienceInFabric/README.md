# What The Hack - Data Science In Microsoft Fabric

## Introduction

This Fabric Data Science guides you through the process of building an end-to-end ML deployment on Fabric.

Contoso hospital has historical, anonymous heart condition data already present in their ADLS Gen 2 as part of their record-keeping solution. They want to leverage this data to create a new app that can help clinicians assess the heart failure risk of their patients, depending on a variety of factors. As an analyst at Contoso, you have been asked to use Microsoft Fabric to train a prediction model and deploy it on Realtime endpoints so that they can build an app on it which will be used by the doctors to predict the patient heart health.

## Learning Objectives

In this hack you will be learning how to best leverage Fabric for Data Science. This is not intended to be an in-depth tutorial around Machine Learning models.

1. Use shortcuts and the OneLake
2. Work with data using Fabric Notebooks
3. Leverage tools such as Data Wrangler to simplify your tasks
4. Understand the different options to apply a trained ML model in Fabric and how to export it
5. Expose the insights from your predictions using PowerBI

## Challenges

- Challenge 00: **[Prerequisites - Ready, Set, GO!](Student/Challenge-00.md)**
	 - Configure your Fabric workspace and gather your data
- Challenge 01: **[Bring your data to the OneLake](Student/Challenge-01.md)**
	 - Creating a shortcut to the available data
- Challenge 02: **[Data preparation with Data Wrangler](Student/Challenge-02.md)**
	 - Clean and transform the data into a useful format while leveraging Data Wrangler
- Challenge 03: **[Train and register the model](Student/Challenge-03.md)**
	 - Train a machine learning model with ML Flow 
- Challenge 04: **[Generate batch predictions](Student/Challenge-04.md)**
	 - Score a static dataset with the model
- Challenge 05: **[Visualize predictions with a Power BI report](Student/Challenge-05.md)**
	 - Build a PowerBI report with the scored data
- Challenge 06: **[(Optional) Deploy the model to an AzureML real-time endpoint](Student/Challenge-06.md)**
	 - Deploy the model you trained to AzureML and generate predictions via the API
## Prerequisites

- Microsoft Fabric capacity/trial capacity. If running the hack on an individual basis, an F4 capacity would be adequate, and an F8 capacity would have generous compute power margin.
- PowerBI Pro or Premium per user subscription/trial (unless using Fabric trial capacity)
- Access to an Azure subscription to:
  -  Deploy a storage account to store the dataset (alternatively you can upload the dataset directly to Fabric)
  - Deploy an AzureML workspace to host a real-time inference endpoint for Challenge 6 (optional)

## Contributors

- Pardeep Singla
- Juan Llovet
- Leandro Santana
