# Challenge 6 - Building Models in Azure Machine Learning Designer

## Prerequisites

1. [Challenge 5 - Building Machine Learning in Power BI AutoML](./05-AMLAutoML.md) should be done successfully.

## Introduction

Adventure Works marketing team loves the insights they've been getting from the Bike Buyer predictive model.  They love it so much, they'd like to apply it more broadly and use it from other systems.  Since the current model can only be used by Power BI, you've been asked to help Adventure Works recreate the model for use outside of Power BI.  For our first step into this process lets use the Azure Machine Learning Studio Designer.  In subsequent labs we will improve on this even more and learn new tools to rapidly implement ML Models.

## Basic Hackflow
1. Go to "https://ml.azure.com" to launch the new "Studio" experience 
1. Create a new "Designer" Training Pipeline
   1. Add in the dataset
   2. Add "Edit Metadata" and create categorical features
   3. Add "Split Data"
   4. Add "Two-Class Logistic Regression".
   5. Add "Train Model"
   6. Add "Score Model"
   7. Add "Evaluate Model"
   8. Run the trained model
      1. Create Training Compute
1. Examine Model and output of each "Pill"
1. Create "Inferencing Pipeline"
1. "Publish" to Endpoint
   1. Create AKS Cluster
1. Examine in "Endpoints"
1. Use the Swagger api to create Postman calls
   1. Use "Import from Link"
1. Test Postman calls for service health
1. Test Postman calls for inference output
1. Add into Power BI dataflow 
   1. Use "AI Insights" to find your model

## Hints
1.  If you don't want to write code to call the REST API, Postman is a great tool. (http://getpostman.com)

