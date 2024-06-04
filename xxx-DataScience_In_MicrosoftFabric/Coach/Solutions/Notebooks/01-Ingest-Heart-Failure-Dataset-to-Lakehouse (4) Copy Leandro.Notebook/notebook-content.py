# Fabric notebook source

# METADATA ********************

# META {
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "4bde1018-56b9-4006-ad26-4228682091bb",
# META       "default_lakehouse_name": "datascience_lakehouse",
# META       "default_lakehouse_workspace_id": "09052c32-4b61-4529-9171-c45d5557d7e4",
# META       "known_lakehouses": [
# META         {
# META           "id": "4bde1018-56b9-4006-ad26-4228682091bb"
# META         },
# META         {
# META           "id": "d83926e6-8f2a-4a35-a215-ab49f1ac0b63"
# META         }
# META       ]
# META     }
# META   }
# META }

# MARKDOWN ********************

# # Module 1: Read data from lakehouse and load into Delta format
# 
# **Lakehouse**: A lakehouse is a collection of files/folders/tables that represent a database over a data lake used by the Spark engine and SQL engine for big data processing and that includes enhanced capabilities for ACID transactions when using the open-source Delta formatted tables.
# 
# **Delta Lake**:Delta Lake is an open-source storage layer that brings ACID transactions, scalable metadata management, and batch and streaming data processing to Apache Spark. A Delta Lake table is a data table format that extends Parquet data files with a file-based transaction log for ACID transactions and scalable metadata management.


# MARKDOWN ********************

# #### Pre-Requisites 
# 
# * A [Microsoft Fabric subscription](https://learn.microsoft.com/en-us/fabric/enterprise/licenses) or sign up for a free [Microsoft Fabric (Preview) trial](https://learn.microsoft.com/en-us/fabric/get-started/fabric-trial).
# * Sign in to [Microsoft Fabric](https://fabric.microsoft.com/).
# * Create or use an existing Fabric Workspace and Lakehouse, follow the steps here to [Create a Lakehouse in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/data-engineering/create-lakehouse)
# * Create shortcut to ADLS Gen2 account and load the the heart failure data into lakehouse file section
# * After getting this notebook, attach the lakehouse with notebook.

# CELL ********************

# Read the heartfailure Dataset file
df = spark.read.format("csv").option("header","true").option("inferSchema", "true").load("Files/heart.csv")
# df now is a Spark DataFrame containing CSV data from "Files/diabetestdataset/diabetes.csv".
display(df)

# CELL ********************

#print schema
df.printSchema()

# MARKDOWN ********************

# ## Write Spark dataframe to lakehouse delta table

# MARKDOWN ********************

# **Enable Vorder and Optimized Delta Write**
# 
# **Verti-Parquet or VOrder** “ Trident includes Microsoftâ€™s VertiParquet engine. VertiParquet writer optimizes the Delta Lake parquet files resulting in 3x-4x compression improvement and up to 10x performance acceleration over Delta Lake files not optimized using VertiParquet while still maintaining full Delta Lake and PARQUET format compliance.<p>
# **Optimize write** “ Spark in Trident includes an Optimize Write feature that reduces the number of files written and targets to increase individual file size of the written data. It dynamically optimizes files during write operations generating files with a default 128 MB size. The target file size may be changed per workload requirements using configurations.
# 
# These configs can be applied at a session level(as spark.conf.set in a notebook cell) as demonstrated in the following code cell, or at workspace level which is applied automatically to all spark sessions created in the workspace. The workspace level Apache Spark configuration can be set at:
# - _Workspace settings >> Data Engineering/Sceience >> Spark Compute >> Spark Properties >> Add_

# CELL ********************

spark.conf.set("sprk.sql.parquet.vorder.enabled", "true") # Enable Verti-Parquet write
spark.conf.set("spark.microsoft.delta.optimizeWrite.enabled", "true") # Enable automatic delta optimized write

# CELL ********************

table_name = "heartFailure"
df.write.mode("overwrite").format("delta").save(f"Tables/{table_name}")
#print(f"Spark dataframe saved to delta table: {table_name}")

# CELL ********************

data_df = spark.read.format("delta").load("Tables/heartFailure")
display(data_df)
