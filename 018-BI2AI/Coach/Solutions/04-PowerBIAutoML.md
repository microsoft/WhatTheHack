# Challenge 4 - Building Machine Learning in Power BI

## Prerequisites

1. [Challenge 3 - Working with Cognitive Services](./03-CognitiveServices.md) should be done successfully.

## Introduction
The purpose of this challenge is to train an operationalize an ML model leveraging AutoML in Power BI premium capacity.

## Basic Steps to Complete
1. Edit the existing data flow and import additional entities for BikeBuyerTraining and ProspectiveBuyer from the data warehouse
1. Save and refresh the dataflow
1. Add a new machine learning model to the dataflow
1. Select BikeBuyerTraining as the data source and BikeBuyer as the target column to predict
1. Select 1 as the target value, and provide labels for the positive and negative test cases
1. Select all the provided columns to train (Note: we've pruned the dataset to avoid errors, but this is where you'd have an opportunity to exclude fields from the training)
1. Move the slider to reduce the training time to **5 minutes** (Note: the default is 120)
1. Run the training
1. When training completes you'll be able to generate a report to view the details of your model and see which fields had the most impact on the results
1. Now that you have a trained model, select apply model to score your prospective buyers, map the fields and execute the scoring
1. In Power BI desktop load the scored data and build reports

## Hints

1.  This step requires A2 capacity to complete, the AI features won't show up unless an A2 capacity is assigned to the workspace.
1.  The datasets for ProspectiveBuyer and BikeBuyer don't match exactly.   ProspectiveBuyer has a birthday column not an age column.   You need to manipulate the BirthDate column to calculate the age before you can apply the model to ProspectiveBuyer.


[Next challenge (Building Models in Azure Machine Learning - AutoML) >](./05-AMLAutoML.md)
