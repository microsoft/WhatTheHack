from zipfile import ZipFile
import requests
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import json

from azureml.core import Workspace
from azureml.core import Experiment
from azureml.core import Workspace, Datastore, Dataset
from azureml.core.authentication import AzureCliAuthentication

with open("./configuration/config.json") as f:
    config = json.load(f)

workspace_name = config["workspace_name"]
resource_group = config["resource_group"]
subscription_id = config["subscription_id"]
location = config["location"]

cli_auth = AzureCliAuthentication()

# Get workspace
#ws = Workspace.from_config(auth=cli_auth)
ws = Workspace.get(
        name=workspace_name,
        subscription_id=subscription_id,
        resource_group=resource_group,
        auth=cli_auth
    )

url = 'https://github.com/asherif844/MLOps/raw/master/data/AdventureWorks-oltp-install-script.zip'
zip_data = requests.get(url)

with open('./data/adventureworks.zip', 'wb') as f:
    f.write(zip_data.content)

with ZipFile('./data/adventureworks.zip', 'r') as fzip:
    fzip.extractall('./data/csv_data')

header = ['TransactionID', 'ProductID', 'ReferenceOrderID', 'ReferenceOrderLineID', 'TransactionDate', 'TransactionType', 'Quantity', 'ActualCost', 'ModifiedDate']

trans_hist_df = pd.read_csv('./data/csv_data/TransactionHistory.csv', sep='\t', names=header)

trans_hist_df['PaidAmount'] = trans_hist_df['Quantity'] * trans_hist_df['ActualCost']
trans_hist_df['TransactionDate'] = pd.to_datetime(trans_hist_df['TransactionDate'])
df = trans_hist_df[['TransactionDate', 'PaidAmount']]
df.set_index('TransactionDate',inplace=True)

df = df.resample('D').mean().interpolate()
df = df['2013-07':'2014-05']
df1 = df['2013']
df2 = df['2014']

df1.plot(title='Daily Transactions')
plt.show()

df.to_csv('./data/mlops_forecast_data.csv', index=True, header=True)
df1.to_csv('./data/mlops_forecast_data2013.csv', index=True, header=True)
df2.to_csv('./data/mlops_forecast_data2014.csv', index=True, header=True)

datastore = ws.get_default_datastore()
datastore.upload_files(files = ['./data/mlops_forecast_data.csv'], target_path = 'mlops_timeseries/', overwrite = True,show_progress = True)
datastore.upload_files(files = ['./data/mlops_forecast_data2013.csv'], target_path = 'mlops_timeseries/', overwrite = True,show_progress = True)
datastore.upload_files(files = ['./data/mlops_forecast_data2014.csv'], target_path = 'mlops_timeseries/', overwrite = True,show_progress = True)

dataset = Dataset.Tabular.from_delimited_files(path=datastore.path('mlops_timeseries/mlops_forecast_data.csv'))
dataset1 = Dataset.Tabular.from_delimited_files(path=datastore.path('mlops_timeseries/mlops_forecast_data2013.csv'))
dataset2 = Dataset.Tabular.from_delimited_files(path=datastore.path('mlops_timeseries/mlops_forecast_data2014.csv'))

dataset.register(workspace = ws, name = 'transaction_ts', description='time series dataset for mlops', create_new_version=True)
dataset1.register(workspace = ws, name = 'transaction_ts2013', description='2013 time series dataset for mlops', create_new_version=True)
dataset2.register(workspace = ws, name = 'transaction_ts2014', description='2014 time series dataset for mlops', create_new_version=True)