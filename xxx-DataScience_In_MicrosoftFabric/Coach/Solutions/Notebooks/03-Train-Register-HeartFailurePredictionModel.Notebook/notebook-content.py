# Fabric notebook source

# METADATA ********************

# META {
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "4bde1018-56b9-4006-ad26-4228682091bb",
# META       "default_lakehouse_name": "datascience_lakehouse",
# META       "default_lakehouse_workspace_id": "09052c32-4b61-4529-9171-c45d5557d7e4"
# META     }
# META   }
# META }

# MARKDOWN ********************

# ## Module 3: Train and register Heart Failure Prediction Machine Learning Model
# In this module you will learn to train a machine learning model to predict the likelihood of an individual getting heart failure based on some historical diagnostic measurements available in the training dataset
# 
# Once a model is trained, you will learn to register the trained model, and log hyperaparameters used and evaluation metrics using Trident's native integration with the MLflow framework.
# 
# [MLflow](https://mlflow.org/docs/latest/index.html) is an open source platform for managing the machine learning lifecycle with features like Tracking, Models, and Model Registry. MLflow is natively integrated with Fabric Data Science Experience.

# MARKDOWN ********************

# ### Import mlflow and create an experiment to log the run


# CELL ********************

# Create Experiment to Track and register model with mlflow
import mlflow
print(f"mlflow lbrary version: {mlflow.__version__}")
EXPERIMENT_NAME = "heartfailure_prediction"
mlflow.set_experiment(EXPERIMENT_NAME)


# MARKDOWN ********************

# ### Read data from lakehouse delta table (saved in previous module)

# CELL ********************

data_df = spark.read.format("delta").load("Tables/diabetes_processed")
data_df.printSchema()
display(data_df)

# MARKDOWN ********************

# ### Perform random split to get train and test datasets and identify feature columns to be used or Model Training

# CELL ********************

train_test_split = [0.75 , 0.25]
seed = 1234
train_df, test_df = data_df.randomSplit(train_test_split, seed=seed)

print(f"Train set record count: {train_df.count()}")
print(f"Test set record count: {test_df.count()}")

# MARKDOWN ********************

# ### Define steps to perform feature engineering and train the model using Spark ML Pipelines and Microsoft SynapseML Library
# 
# You can learn more about Spark ML pipelines [here](https://spark.apache.org/docs/latest/ml-pipeline.html), and SynapseML is documented [here](https://microsoft.github.io/SynapseML/docs/about/)
# 
# The algorithm used for this tutorial, [LightGBM](https://lightgbm.readthedocs.io/en/v3.3.2/) is a fast, distributed, high performance gradient boosting framework based on decision tree algorithms. It is an open source project developed by Microsoft and supports regression, classification and many other machine learning scenarios. Its main advantages are faster training speed, lower memory usage, better accuracy, and support for distributed learning.

# CELL ********************

numeric_cols = train_df.drop("HeartDisease", "Sex", "ChestPainType", "RestingECG", "ExerciseAngina", "ST_Slope", "FastingBS").columns
print(numeric_cols)

# CELL ********************

from pyspark.ml.feature import OneHotEncoder, StringIndexer, VectorAssembler

#categorical_cols = ["Sex","ChestPainType", "RestingECG", "FastingBS", "ExerciseAngina", "ST_Slope"]
categorical_cols = ["Sex"]
# onehot encode above categorical columns
stages = []
for col in categorical_cols:
    stringIndexer = StringIndexer(inputCol=col, outputCol = col + "index")
    encoder = OneHotEncoder(inputCol = stringIndexer.getOutputCol(), outputCol = col  + "_vec")
    
    stages += [stringIndexer, encoder]

#Use VectorAssembler to generate feature column to be passed into ML Model for training
assemblerInputs = numeric_cols + [col + "_vec" for col in categorical_cols]
assembler = VectorAssembler(inputCols = assemblerInputs, outputCol = "features", handleInvalid="skip")

stages += [assembler]



# CELL ********************

display(stages)

# CELL ********************

from synapse.ml.lightgbm import LightGBMClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier, GradientBoostingClassifier
#this is the model training stage

learningRate = 0.3
numIterations = 100
numLeaves = 31

#lgr = GradientBoostingClassifier(learningRate = learningRate, numIterations = numIterations, numLeaves = numLeaves, labelCol = "HeartDisease")
#lgr1 = GradientBoostingClassifier(random_state=42)
lgr = LightGBMClassifier(learningRate = learningRate, numIterations = numIterations, numLeaves = numLeaves, labelCol = "HeartDisease")
stages += [lgr]

# CELL ********************

display(train_df)

# CELL ********************

from pyspark.ml import Pipeline
from synapse.ml.train import ComputeModelStatistics

from pyspark.ml.feature import VectorAssembler

#start mlflow run to capture parameters, metrics and log model
with mlflow.start_run():
       
    #define the pipeline
    ml_pipeline = Pipeline(stages = stages)

    #log the parameters used in training for tracking purpose
    mlflow.log_param("train_test_split",train_test_split)
    mlflow.log_param("learningRate", learningRate)
    mlflow.log_param("numIterations", numIterations)
    mlflow.log_param("numLeaves", numLeaves)

    #Call fit method on the pipeline with trianing subset data to create ML Model
    lg_model = ml_pipeline.fit(train_df)

    #perform the predictions on the test subset of the data
    lg_predictions = lg_model.transform(test_df)

    #measure and log metrics to track performance of model
    metrics = ComputeModelStatistics(
        evaluationMetric="classification",
        labelCol="HeartDisease",
        scoredLabelsCol="prediction",
        ).transform(lg_predictions)

    mlflow.log_metric("precision", round(metrics.first()["precision"],4))
    mlflow.log_metric("recall", round(metrics.first()["recall"],4))
    mlflow.log_metric("accuracy", round(metrics.first()["accuracy"],4))   
    mlflow.log_metric("AUC", round(metrics.first()["AUC"],4))

    #log the model for subsequent use
    model_name = "heartfailure-lgmb"
    mlflow.spark.log_model(lg_model, artifact_path = model_name, registered_model_name = model_name, dfs_tmpdir="Files/tmp/mlflow") 




# CELL ********************

#display raw predictions generated by model
display(lg_predictions)

# CELL ********************

#display performance metrics for the trained ML Model
display(metrics)
