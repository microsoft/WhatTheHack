// Databricks notebook source
import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType,LongType,FloatType,DoubleType, TimestampType}
import com.databricks.backend.daemon.dbutils.FileInfo

// COMMAND ----------

// MAGIC %md
// MAGIC #### 1. Execute shared notebooks; set paths

// COMMAND ----------

// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %run ./00-Functions

// COMMAND ----------

//Define source and destination directories
val srcDataDirRoot = mountRoot + source + "/reference-data/" //Root dir for source data
val destDataDirRoot = mountRoot + reference + "/" //Root dir for consumable ref data

// COMMAND ----------

// MAGIC %md
// MAGIC #### 2. List reference datasets

// COMMAND ----------

display(dbutils.fs.ls(srcDataDirRoot))

// COMMAND ----------

// MAGIC %md
// MAGIC #### 3. Define schema for raw reference data

// COMMAND ----------

// Payment type
val paymentTypeSchema = StructType(Array(
    StructField("payment_type", IntegerType, true),
    StructField("abbreviation", StringType, true),
    StructField("description", StringType, true)))

// Rate code id
val rateCodeSchema = StructType(Array(
    StructField("rate_code_id", IntegerType, true),
    StructField("description", StringType, true)))

// Taxi zone
val taxiZoneSchema = StructType(Array(
    StructField("location_id", StringType, true),
    StructField("borough", StringType, true),
    StructField("zone", StringType, true),
    StructField("service_zone", StringType, true)))

// Trip month
val tripMonthNameSchema = StructType(Array(
    StructField("trip_month", StringType, true),
    StructField("month_name_short", StringType, true),
    StructField("month_name_full", StringType, true)))

// Trip type
val tripTypeSchema = StructType(Array(
    StructField("trip_type", IntegerType, true),
    StructField("description", StringType, true)))

// Vendor ID
val vendorSchema = StructType(Array(
    StructField("vendor_id", IntegerType, true),
    StructField("abbreviation", StringType, true),
    StructField("description", StringType, true)))

// COMMAND ----------

// MAGIC %md
// MAGIC #### 4. Load Data

// COMMAND ----------

// MAGIC %md
// MAGIC ##### 4.1. Create function to load data

// COMMAND ----------

def LoadReferenceData(srcDatasetName: String, srcDataFile: String, destDataDir: String, srcSchema: StructType, delimiter: String )
{
  // println("Dataset: " + srcDatasetName)
  
  // Delete dest to recreate clean for idempotent runs
  dbutils.fs.rm(destDataDir, recurse=true)
  
  // Read source data
  val refDF = sqlContext
    .read
    .option("header", "true")
    .schema(srcSchema)
    .option("delimiter", delimiter)
    .csv(srcDataFile)

  // Write parquet output
  // println("Reading source and saving as parquet")
  refDF.coalesce(1).write.parquet(destDataDir)
  
  // Delete residual files from job operation (_SUCCESS, _start*, _committed*)
  // println("Delete temp/job files")
  DeleteSparkJobFiles(destDataDir)
  
  // println("Done")
}

// COMMAND ----------

// MAGIC %md
// MAGIC ##### 4.2. Load data

// COMMAND ----------

LoadReferenceData("payment_type", srcDataDirRoot + "payment_type_lookup.csv", destDataDirRoot + "payment-type", paymentTypeSchema, "|")
LoadReferenceData("rate_code", srcDataDirRoot + "rate_code_lookup.csv", destDataDirRoot + "rate-code", rateCodeSchema, "|")
LoadReferenceData("taxi_zone", srcDataDirRoot + "taxi_zone_lookup.csv", destDataDirRoot + "taxi-zone", taxiZoneSchema, ",")
LoadReferenceData("trip_month", srcDataDirRoot + "trip_month_lookup.csv", destDataDirRoot + "trip-month", tripMonthNameSchema, ",")
LoadReferenceData("trip_type", srcDataDirRoot + "trip_type_lookup.csv", destDataDirRoot + "trip-type", tripTypeSchema, "|")
LoadReferenceData("vendor", srcDataDirRoot + "vendor_lookup.csv", destDataDirRoot + "vendor", vendorSchema, "|")

// COMMAND ----------

// MAGIC %md
// MAGIC ##### 4.3. Validate load

// COMMAND ----------

display(dbutils.fs.ls(mountRoot + reference))

// COMMAND ----------

// MAGIC %md
// MAGIC #### 5. Create Hive tables

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)

// COMMAND ----------

spark.catalog.listTables.show(false)

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS payment_type_lookup")

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS rate_code_lookup")

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS taxi_zone_lookup")

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS trip_month_lookup")

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS trip_type_lookup")

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS vendor_lookup")

// COMMAND ----------

spark.sql("""
CREATE TABLE IF NOT EXISTS payment_type_lookup(
payment_type INT,
abbreviation STRING,
description STRING)
USING parquet
LOCATION '""" + mountRoot + reference + """/payment-type/'"""
)

// COMMAND ----------

spark.sql("""
CREATE TABLE IF NOT EXISTS rate_code_lookup(
rate_code_id INT,
description STRING)
USING parquet
LOCATION '""" + mountRoot + reference + """/rate-code/'"""
)

// COMMAND ----------

spark.sql("""
CREATE TABLE IF NOT EXISTS taxi_zone_lookup(
location_id STRING,
borough STRING,
zone STRING,
service_zone STRING)
USING parquet
LOCATION '""" + mountRoot + reference + """/taxi-zone/'"""
)

// COMMAND ----------

spark.sql("""
CREATE TABLE IF NOT EXISTS trip_month_lookup(
trip_month STRING,
month_name_short STRING,
month_name_full STRING)
USING parquet
LOCATION '""" + mountRoot + reference + """/trip-month/'"""
)

// COMMAND ----------

spark.sql("""
CREATE TABLE IF NOT EXISTS trip_type_lookup(
trip_type INT,
description STRING)
USING parquet
LOCATION '""" + mountRoot + reference + """/trip-type/'"""
)

// COMMAND ----------

spark.sql("""
CREATE TABLE IF NOT EXISTS vendor_lookup(
vendor_id INT,
abbreviation STRING,
description STRING)
USING parquet
LOCATION '""" + mountRoot + reference + """/vendor/'"""
)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 6. Refresh tables and compute statistics

// COMMAND ----------

AnalyzeHiveTable(hiveDbName + ".payment_type_lookup")
AnalyzeHiveTable(hiveDbName + ".rate_code_lookup")
AnalyzeHiveTable(hiveDbName + ".taxi_zone_lookup")
AnalyzeHiveTable(hiveDbName + ".trip_month_lookup")
AnalyzeHiveTable(hiveDbName + ".trip_type_lookup")
AnalyzeHiveTable(hiveDbName + ".vendor_lookup")

// COMMAND ----------

display(spark.sql("SELECT * FROM payment_type_lookup"))

// COMMAND ----------

display(spark.sql("SELECT * FROM rate_code_lookup"))

// COMMAND ----------

display(spark.sql("SELECT * FROM taxi_zone_lookup"))

// COMMAND ----------

display(spark.sql("SELECT * FROM trip_month_lookup"))

// COMMAND ----------

display(spark.sql("SELECT * FROM trip_type_lookup"))

// COMMAND ----------

display(spark.sql("SELECT * FROM vendor_lookup"))

// COMMAND ----------


