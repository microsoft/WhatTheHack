# Challenge 5 - Building Models in Azure Machine Learning AutoML

## Prerequisites

1. [Challenge 4 - Building Machine Learning in Power BI](./04-PowerBIAutoML.md) should be done successfully.

## Introduction

Now that we have created an AML Designer based model and deployed that to an endpoint, we understand the process of model creation.  We can now use that to craft an AutoML run, deploy the best model to and endpoint, and finally use that endpoint back in Power BI.

## Basic Hackflow
1. Create an Azure Machine Learning Workspace in your Azure Subscription (Ensure it is "Enterprise")
1. Go to <a href=https://ml.azure.com target="_blank">ML Studio"</a> to launch the new "Studio" experience, ensure you are in the right "workspace"
1. Create a "Dataset" from a new "Datastore" by connecting it to the SQLServer in earlier labs and running 
   1. Use "Select * from BikeBuyerTraining"
1. Create an AutoML Service
1. Publish the "Best Model" to an Endpoint ("No Auth")
1. Test in a Power BI Dataflow like you did the Cognitive Services

## Hints
1. None


[Optional challenge (Building Machine Learning Models in Azure Machine Learning Designer) >](./06-AMLDesigner.md)