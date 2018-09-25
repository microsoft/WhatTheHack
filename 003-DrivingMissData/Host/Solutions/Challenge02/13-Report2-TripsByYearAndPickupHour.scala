// Databricks notebook source
import org.apache.spark.sql._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType, LongType, FloatType, DoubleType, TimestampType}
import com.databricks.backend.daemon.dbutils._
import com.databricks.backend.daemon.dbutils.FileInfo

// COMMAND ----------

// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %run ./00-Functions

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)

// COMMAND ----------

display(spark.catalog.listTables().orderBy("name"))

// COMMAND ----------

//Report dataframe
val reportDF = sql("""
  select 
    taxi_type,
    trip_year,
    pickup_hour,
    count(*) as trip_count
  from 
    taxi_trips_mat_view
  group by 
    taxi_type,
    trip_year,
    pickup_hour
  """)

// COMMAND ----------

reportDF.write.mode("overwrite").saveAsTable("report_trips_by_year_and_pickup_hour")

// COMMAND ----------

dbutils.notebook.exit("true")
