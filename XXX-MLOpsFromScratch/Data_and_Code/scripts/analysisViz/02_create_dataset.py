import pandas as pd


header = ['BusinessEntityID', 'RateChangeDate',
          'Rate', 'PayFrequency', 'ModifiedDate']

emp_pay_hist_df = pd.read_csv(
    'csv_data/EmployeePayHistory.csv', sep='\t', names=header)

emp_pay_hist_df['paidAmount'] = emp_pay_hist_df['Rate'] * \
    emp_pay_hist_df['PayFrequency']

emp_pay_hist_df = emp_pay_hist_df.sort_values(by='RateChangeDate')

forecastable_data = emp_pay_hist_df[['RateChangeDate', 'paidAmount']]

forecastable_data_agg = forecastable_data.groupby(
    ['RateChangeDate'])['paidAmount'].sum().reset_index(name='paidAmountSum')

forecastable_data_agg.to_csv('csv_data/forecast_data_2.csv', index=False)
