# Databricks notebook source
from pyspark.sql.types import *
from pyspark.sql.functions import *

# Device log files are written to the stream folder
inputPath = "wasbs://spark@ACCOUNT_NAME.blob.core.windows.net/stream/"

# Each log contains a device and a status
jsonSchema = StructType([
  StructField("device", StringType(), False),
  StructField("status", StringType(), False)
])

# Continually read dataframes from the stream based on the schema
inStream = spark.readStream.schema(jsonSchema).option("maxFilesPerTrigger", 1).json(inputPath)


# Filter the dataframe to include only errors, and count them per-device
countErrors = inStream.filter("status == 'error'").groupBy(window(current_timestamp(), "1 minute"), "device").count()

# Write the stream of processed data to a table (in memory for this example)
outStream = countErrors.writeStream.format("memory").queryName("counts").outputMode("complete").start()


# COMMAND ----------

# MAGIC %sql
# MAGIC -- Read the in-memory table
# MAGIC select device, window.start, window.end, count from counts

# COMMAND ----------

# stop processing the stream
outStream.stop()
