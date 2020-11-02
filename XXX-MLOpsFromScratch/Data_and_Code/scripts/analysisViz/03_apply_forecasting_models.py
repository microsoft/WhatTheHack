from statsmodels.tsa.arima_model import ARIMA
from statsmodels.graphics.tsaplots import plot_acf, plot_pacf
from statsmodels.tsa.stattools import adfuller
from datetime import datetime

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

df = pd.read_csv('csv_data/forecast_data.csv', index_col=False)

print(df.head())
print(df.dtypes)


df['RateChangeDate'] = pd.to_datetime(df['RateChangeDate'])
df.set_index('RateChangeDate', inplace=True)


# convert to time series

ts = df['paidAmountSum']
plt.plot(ts)
plt.show()


print("p-value:", adfuller(ts.dropna())[1])

fig = plt.figure(figsize=(10, 10))
ax1 = fig.add_subplot(311)
fig = plot_acf(ts, ax=ax1,
               title="Autocorrelation on Original Series")
ax2 = fig.add_subplot(312)
fig = plot_acf(ts.diff().dropna(), ax=ax2,
               title="1st Order Differencing")
ax3 = fig.add_subplot(313)
fig = plot_acf(ts.diff().diff().dropna(), ax=ax3,
               title="2nd Order Differencing")

model = ARIMA(ts, order=(1, 1, 1))
results = model.fit()
results.plot_predict(1, 220)
