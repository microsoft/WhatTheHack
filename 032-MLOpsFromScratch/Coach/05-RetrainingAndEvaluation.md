# Challenge 5 – Retraining and Model Evaluation

[< Previous Challenge](./04-ReleasePipeline.md) - **[Home](./README.md)**

## Solution

1.  To retrain your model, update the training code with new data

    1.  Pull up the training code in `transactions_arima.py` in `scripts/training`
        folder. The initial model was trained on 2013 transactions data.

    2.  Along with 2013 data, also read 2014 transactions data that was created
        in `service/code/AcquireData.py`

    3.  Concatenate these two datasets/dataframes and build an ARIMA trained
        model on this bigger dataset

2.  Rerun the Build pipeline to reflect the changes in training

3.  Rerun the Release pipeline. If the new model has better evaluation metrics
    than the previous model, then a new web service is created for your retrained
    model.

4.  Review artifacts and outputs from Build and Release pipelines

