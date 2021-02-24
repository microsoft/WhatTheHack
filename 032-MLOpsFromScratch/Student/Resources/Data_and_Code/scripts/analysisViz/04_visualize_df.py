from statsmodels.tsa.arima_model import ARIMA
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
st.write(""" 
AdventureWorks Forecasting
""")


df = pd.read_csv('csv_data/forecast_data.csv', index_col=False)
df['RateChangeDate'] = pd.to_datetime(df['RateChangeDate'])
df.set_index('RateChangeDate', inplace=True)
ts = df['paidAmountSum']

st.text('This is a forecast')
st.line_chart(df)
st.dataframe(df)

model = ARIMA(ts, order=(1, 1, 1))
results = model.fit()
# results.plot_predict(1, 220)
values = st.sidebar.slider("Forecast Range", 200, 300)
st.pyplot(results.plot_predict(1, values))