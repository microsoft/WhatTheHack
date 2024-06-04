# Fabric notebook source

# METADATA ********************

# META {
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "edcbcfc1-a9fa-4074-95e4-b29aa628ecdc",
# META       "default_lakehouse_name": "hls_sample_lakehouse",
# META       "default_lakehouse_workspace_id": "f592ff04-4de0-4237-b356-fa21aef3f3e6",
# META       "known_lakehouses": [
# META         {
# META           "id": "edcbcfc1-a9fa-4074-95e4-b29aa628ecdc"
# META         }
# META       ]
# META     }
# META   }
# META }

# MARKDOWN ********************

# ## Module 4 - Simulate Input data, perform Batch Predictions and save predictions to Lakehouse

# MARKDOWN ********************

# ### Simulate input heart failure diagnostic data to be used for predictions

# MARKDOWN ********************

# 
# Use [Faker](https://faker.readthedocs.io/en/master/) Python package to simulate heart failure diagnostic data. Python Libraries can be added in the Workspace Settings or installed inline using _%pip install Faker_. Read more on the public docs - [Manage Apache Spark libraries](https://learn.microsoft.com/en-us/fabric/data-engineering/library-management)

# CELL ********************

%pip install Faker==18.10.1

# CELL ********************

from pyspark.sql.types import StructType, StructField, IntegerType, DoubleType, StringType

heartFailureDataSchema = StructType(
[
    StructField('Age', IntegerType(), True),
    StructField('Sex', StringType(), True),
    StructField('ChestPainType', StringType(), True),
    StructField('RestingBP', IntegerType(), True),
    StructField('Cholestrol', IntegerType(), True),
    StructField('FastingBS', IntegerType(), True),
    StructField('RestingECG', StringType(), True),
    StructField('MaxHR', IntegerType(), True),
    StructField('ExerciseAnigma', StringType(), True),
    StructField('OldPeak', DoubleType(), True),
    StructField('ST_Slope', StringType(), True)
]
)

# CELL ********************

from faker import Faker

faker = Faker()
simulateRecordCount = 10
simData = []

for i in range(simulateRecordCount):
    age = faker.random_int(54,70)
    RestingBP = faker.random_int(70, 170)
    Cholestrol = faker.random_int(100, 300)
    FastingBS= faker.random_int(0, 1)    
    MaxHR = faker.random_int(100,200)
    OldPeak = faker.pyfloat(right_digits = 2, positive = True, max_value = 4.5)

    ChestPain = faker.random_element(elements=('ASY','ATA','TA','NAP'))
    Sex = faker.random_element(elements=('M','F'))
    RestingECG  = faker.random_element(elements=('ST','NORMAL','LVH'))
    ExerciseAnigma = faker.random_element(elements=('N','Y'))
    StSlope= faker.random_element(elements=('Up','Down'))
    simData.append((age, Sex,ChestPain, RestingBP,Cholestrol,FastingBS,RestingECG , MaxHR,ExerciseAnigma,OldPeak, StSlope))

#print(simData)

df = spark.createDataFrame(data = simData, schema =heartFailureDataSchema)
display(df)



# MARKDOWN ********************

# ### Load trained and registered model to generate predictions

# CELL ********************

import mlflow
from pyspark.ml.feature import VectorAssembler
from pyspark.ml import Pipeline
from synapse.ml.core.platform import *
from synapse.ml.lightgbm import LightGBMRegressor

model_uri = "models:/heartfailure-lgbm/latest"
model = mlflow.spark.load_model(model_uri)

predictions_df = model.transform(df)
display(predictions_df)

# MARKDOWN ********************

# ### Format Predictions and save as a Delta Table for consumption

# CELL ********************

from pyspark.sql.functions import get_json_object
from pyspark.sql.functions import col
from pyspark.sql.functions import udf
from pyspark.sql.types import FloatType
from pyspark.sql.functions import format_number

firstelement=udf(lambda v: float(v[0]) if (float(v[0]) >  float(v[1])) else float(v[1]), FloatType())

predictions_formatted_df = predictions_df \
    .withColumn("prob", format_number(firstelement('probability'), 4)) \
    .withColumn("diab_pred", predictions_df.prediction.cast('int')) \
    .drop("features", "rawPrediction", "probability", "prediction", "insulin_level_vec", "obesity_level_vec")

display(predictions_formatted_df)


# CELL ********************

# optimize writes to Delta Table
spark.conf.set("sprk.sql.parquet.vorder.enabled", "true") # Enable Verti-Parquet write
spark.conf.set("spark.microsoft.delta.optimizeWrite.enabled", "true") # Enable automatic delta optimized write

# CELL ********************

table_name = "diabetes_pred"
predictions_formatted_df.write.mode("overwrite").format("delta").save(f"Tables/{table_name}")
print(f"Output Predictions saved to delta table: {table_name}")

# CELL ********************

# MAGIC %%sql
# MAGIC 
# MAGIC --preview predicted data
# MAGIC select * from diabetes_pred limit 10;
