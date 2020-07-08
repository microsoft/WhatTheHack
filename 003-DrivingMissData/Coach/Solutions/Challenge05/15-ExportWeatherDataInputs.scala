// Databricks notebook source
import org.apache.spark.sql._
import org.apache.spark.sql.functions._
import com.databricks.backend.daemon.dbutils._
import com.databricks.backend.daemon.dbutils.FileInfo

// COMMAND ----------

// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %run ./00-Functions

// COMMAND ----------

// Destination paths
val destDataDirRoot = mountRoot + source + "/weather-input/"
val destDataDirRootTemp = destDataDirRoot + "data.tmp"
val destDataFile = destDataDirRoot + "data.csv"

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)
spark.catalog.listTables.show(false)

// COMMAND ----------

var df = spark.sql("""
  select
    pickup_datetime,
    pickup_longitude,
    pickup_latitude
  from
    taxi_trips_mat_view
  where
    pickup_longitude is not null and
    pickup_longitude != "" and
    pickup_longitude != "0.0" and
    pickup_latitude is not null and
    pickup_latitude != "" and
    pickup_latitude != "0.0"
  order by
    pickup_datetime desc
  limit 100
""")

// COMMAND ----------

display(df)

// COMMAND ----------

// Write dataframe to temp output folder - coaleasce to one output file
  df
    .coalesce(1)
    .write
    .mode("overwrite")
    .option("header", "false")
    .option("delimiter", ",")
    .csv(destDataDirRootTemp)

// COMMAND ----------

// Get the path of the single CSV file we wrote
  var tempFilePath = dbutils.fs.ls(destDataDirRootTemp).filter(file => file.name.endsWith(".csv"))(0).path

  // Copy the temp file to the path we actually want
  dbutils.fs.cp(tempFilePath, destDataFile)

  // Remove the partition folder with the Spark job files and CSV file we no longer need (now that we have a copy with correct name)
  dbutils.fs.rm(destDataDirRootTemp, recurse=true)

// COMMAND ----------


