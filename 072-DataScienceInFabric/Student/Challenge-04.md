# Challenge 04 - Generate batch predictions
[< Previous Challenge](./Challenge-03.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-05.md)

## Introduction

During Challenge 3, you trained and registered a model. You validated it using a variety of metrics. You must now leverage this same model to generate predictions over new data. To do so, you will create a set of simulated input data to feed the model and receive a prediction. Once you have generated the predictions you will save them as a delta table for further use.

## Description
Your task in this challenge is to obtain predictions from some simulated inputs. This is a notebook-based challenge, you will find all instructions within Notebook 4.

Notebook sections:
1. Simulate input data to be used for predictions
2. Load the model and generate predictions
3. Format predictions and save them to a delta table

By the end of this challenge, you should be able to understand and know how to use:
- The PREDICT function, how to use the `MLFlowTransfomer` object, how to create predictions
- (Additional learnings, not core to the hack) The Python Faker library, how to use it to create simulated data to be used for model inference


## Success Criteria

Verify that you have generated a set of predictions with the simulated data and have saved them as a delta table, making them available to create a PowerBI report. Verify that you can load the table with the newly generated predictions into the notebook. 

## Learning Resources

Refer to Notebook 4 for helpful links

## Tips

- Notebooks depend on Lakehouses to read and write data.
- As you move on to using notebooks, most cells depend on each other. If you are getting an error on a cell that you think shouldn't be there, navigate upstream to try to find what is wrong. Leverage Microsoft Learn and the provided documentation to make sure you are using the right functions. Check that you are using the correct variable names.
- If you stop halfway through a notebook, your progress will be saved in the code cells but the variables might be deleted from memory. If that happens, run every cell from the start in succession to get back to the starting point.

## Advanced Challenges (Optional)

Interested in how you can integrate the PREDICT function call into your analytics workflow?

You can run Fabric notebooks from a pipeline, which means you can generate predictions over new data during the ETL process using Delta tables that you have created/uploaded. Explore how you can use the [notebook activity](https://learn.microsoft.com/en-us/fabric/data-factory/notebook-activity) to call a notebook from a pipeline and how you can [integrate a notebook](https://learn.microsoft.com/en-us/fabric/data-engineering/author-execute-notebook#integrate-a-notebook) by using parameters to pass along table names that the notebook can use for its inference and to write back the results.
