from zipfile import ZipFile
import requests

url = 'https://github.com/asherif844/MLOps/raw/master/data/AdventureWorks-oltp-install-script.zip'

zip_data = requests.get(url)

with open('adventureworks.zip', 'wb') as f:
    f.write(zip_data.content)


with ZipFile('adventureworks.zip', 'r') as fzip:
    fzip.extractall('csv_data')
