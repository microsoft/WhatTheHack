# Challenge 5 – Retraining and Model Evaluation

[< Previous Challenge](./Solution-04.md) - **[Home](./README.md)**

## Solution

1.  To retrain your model, update the training code with new data
    1.  Pull up the training code in `transactions_arima.py` in `scripts/training` folder. The initial model was trained on 2013 transactions data.
    1.  Along with 2013 data, also read 2014 transactions data that was created in `service/code/AcquireData.py`
    1.  Concatenate these two datasets/dataframes and build an ARIMA trained model on this bigger dataset.
        Example code:
        ```python
        dataset1 = Dataset.get_by_name(workspace=ws, name='transaction_ts2013')
        dataset2 = Dataset.get_by_name(workspace=ws, name='transaction_ts2014')
        df1 = dataset1.to_pandas_dataframe()
        df2 = dataset2.to_pandas_dataframe()
        df = pd.concat([df1, df2])
        ```
1.  Rerun the `Build` pipeline to reflect the changes in training.
1.  Rerun the `Release` pipeline. If the new model has better evaluation metrics than the previous model, then a new web service is created for your retrained model.
1.  Review artifacts and outputs from `Build` and `Release` pipelines.
