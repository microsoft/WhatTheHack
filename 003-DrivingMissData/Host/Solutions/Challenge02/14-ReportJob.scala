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

// MAGIC %run ./11-ReportsCommon

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)

// COMMAND ----------

val batchID: Long = GenerateBatchID()

// COMMAND ----------

var executionStatusReport1 = "false"

sql("insert into batch_job_history VALUES(" + batchID + ", '12-Report1-TripsByYear', 'Started', CURRENT_TIMESTAMP)")

executionStatusReport1 = dbutils.notebook.run("./12-Report1-TripsByYear", 120)

if(executionStatusReport1 == "true")
  sql("insert into batch_job_history VALUES(" + batchID + ", '12-Report1-TripsByYear', 'Completed', CURRENT_TIMESTAMP)")

// COMMAND ----------

var executionStatusReport2 = "false"

if(executionStatusReport1 == "true")
{
  sql("insert into batch_job_history VALUES(" + batchID + ", '13-Report2-TripsByYearAndPickupHour', 'Started', CURRENT_TIMESTAMP)")

  executionStatusReport2 = dbutils.notebook.run("./13-Report2-TripsByYearAndPickupHour", 120)

  sql("insert into batch_job_history VALUES(" + batchID + ", '13-Report2-TripsByYearAndPickupHour', 'Completed', CURRENT_TIMESTAMP)")
}

// COMMAND ----------

display(spark.sql("select * from batch_job_history order by batch_id, timestamp"))

// COMMAND ----------

display(spark.sql("select * from report_trips_by_year order by trip_year, taxi_type"))

// COMMAND ----------

display(spark.sql("select * from report_trips_by_year_and_pickup_hour order by trip_year, pickup_hour, taxi_type"))

// COMMAND ----------

dbutils.notebook.exit(executionStatusReport2)
