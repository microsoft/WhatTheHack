# Challenge 03 - Train and register the model

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Introduction

During Challenge 2, you cleaned up the data you will be working with. You explored the structure and statistics of the data and uncovered various inconsistencies, which you resolved. You must now use this data to train and register an ML model. To keep track of the model iterations, you will leverage Fabric's direct integration with MLFlow. Once you have a trained model you will save it for further prediction.

## Description
Your task in this challenge is to train and register an ML model with MLFlow. This is a notebook-based challenge, you will find all instructions within Notebook 3.

Notebook sections:
1. Creating an MLFlow experiment
2. Reading the delta table with Spark
3. Performing a random split of the data
4. Creating a run within the experiment to fit the model
5. Loading the saved model and generating predictions with the validation data

By the end of this challenge, you should be able to understand and know how to use:
- MLFlow, what are experiments and runs, how to set and start them and how to load models
- `sklearn`, what are some basic notions of using this ML framework, how does it integrate with MLFlow and how that transfers to any other framework
- Basics of evaluating machine learning models, confusion matrices, classification reports and auc scores


## Success Criteria

Verify that your model has been trained and registered with MLFlow and you are able to load it and generate predictions with the validation data.

## Learning Resources

Refer to Notebook 3 for helpful links

## Tips

- Notebooks depend on Lakehouses to read and write data.
- As you move on to using notebooks, most cells depend on each other. If you are getting an error on a cell that you think shouldn't be there, navigate upstream to try to find what is wrong. Leverage Microsoft Learn and the provided documentation to make sure you are using the right functions. Check that you are using the correct variable names.
- If you stop halfway through a notebook, your progress will be saved in the code cells but the variables might be deleted from memory. If that happens, run every cell from the start in succession to get back to the starting point.

## Advanced Challenges (Optional)

Wondering how MLFlow can assist in the process of model iteration and fine-tuning?

Look back to the model set up. Understand what each of the stated hyperparameters do and how that affects the model generated. Set up another run in the experiment to create a version 2 of the model and try to switch some hyperparameters this time around. Look at the evaluation metrics. Can you perfect the model? 

Interested in learning more about how MLFlow is integrated with Fabric?

Go back to your workspace and see what items have been automatically created. You should have a model and an experiment, and if you've had multiple runs you should see different model versions.
