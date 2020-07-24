// Databricks notebook source
import org.apache.spark.sql.functions._

// COMMAND ----------

// MAGIC %md
// MAGIC ### 2.  Add extra columns to yellow taxi - to match green taxi
// MAGIC Because we are working with parquet, we cannot just throw in additional columns in a select statement.<BR>
// MAGIC We are systematically adding the three extra columns with default values in this section.

// COMMAND ----------

// MAGIC %sql
// MAGIC use taxi_db;
// MAGIC refresh table yellow_taxi_trips_curated;
// MAGIC refresh table green_taxi_trips_curated;

// COMMAND ----------

//Read source data
val yellowTaxiDF = sql("""
SELECT 
    taxi_type,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    store_and_fwd_flag,
    rate_code_id,
    pickup_location_id,
    dropoff_location_id,
    pickup_longitude,
    pickup_latitude,
    dropoff_longitude,
    dropoff_latitude,
    passenger_count,
    trip_distance,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    payment_type,
    vendor_abbreviation,
    vendor_description,
    month_name_short,
    month_name_full,
    payment_type_description,
    rate_code_description,
    pickup_borough,
    pickup_zone,
    pickup_service_zone,
    dropoff_borough,
    dropoff_zone,
    dropoff_service_zone,
    pickup_year,
    pickup_month,
    pickup_day,
    pickup_hour,
    pickup_minute,
    pickup_second,
    dropoff_year,
    dropoff_month,
    dropoff_day,
    dropoff_hour,
    dropoff_minute,
    dropoff_second,
    trip_year,
    trip_month
  FROM taxi_db.yellow_taxi_trips_curated 
""")

//Add extra columns
val yellowTaxiDFHomogenized = yellowTaxiDF.withColumn("ehail_fee",lit(0.0))
                                          .withColumn("trip_type",lit(0))
                                          .withColumn("trip_type_description",lit("")).cache()
//Materialize
yellowTaxiDFHomogenized.count()

//Register temporary view
yellowTaxiDFHomogenized.createOrReplaceTempView("yellow_taxi_trips_unionable")

//Approximately 2 minutes

// COMMAND ----------

yellowTaxiDFHomogenized.printSchema

// COMMAND ----------

// MAGIC %md
// MAGIC ### 3.  Create materialized view

// COMMAND ----------

//Destination directory
val destDataDirRoot = "/mnt/data/nyctaxi/curatedDir/materialized-view" 

//Delete any residual data from prior executions for an idempotent run
dbutils.fs.rm(destDataDirRoot,recurse=true)

// COMMAND ----------

val matViewDF = sql("""
  SELECT DISTINCT  
    taxi_type,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    store_and_fwd_flag,
    rate_code_id,
    pickup_location_id,
    dropoff_location_id,
    pickup_longitude,
    pickup_latitude,
    dropoff_longitude,
    dropoff_latitude,
    passenger_count,
    trip_distance,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    ehail_fee,
    improvement_surcharge,
    total_amount,
    payment_type,
    trip_type,
    vendor_abbreviation,
    vendor_description,
    trip_type_description,
    month_name_short,
    month_name_full,
    payment_type_description,
    rate_code_description,
    pickup_borough,
    pickup_zone,
    pickup_service_zone,
    dropoff_borough,
    dropoff_zone,
    dropoff_service_zone,
    pickup_year,
    pickup_month,
    pickup_day,
    pickup_hour,
    pickup_minute,
    pickup_second,
    dropoff_year,
    dropoff_month,
    dropoff_day,
    dropoff_hour,
    dropoff_minute,
    dropoff_second,
    trip_year,
    trip_month
  FROM yellow_taxi_trips_unionable 
UNION ALL
  SELECT DISTINCT 
    taxi_type,
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    store_and_fwd_flag,
    rate_code_id,
    pickup_location_id,
    dropoff_location_id,
    pickup_longitude,
    pickup_latitude,
    dropoff_longitude,
    dropoff_latitude,
    passenger_count,
    trip_distance,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    ehail_fee,
    improvement_surcharge,
    total_amount,
    payment_type,
    trip_type,
    vendor_abbreviation,
    vendor_description,
    trip_type_description,
    month_name_short,
    month_name_full,
    payment_type_description,
    rate_code_description,
    pickup_borough,
    pickup_zone,
    pickup_service_zone,
    dropoff_borough,
    dropoff_zone,
    dropoff_service_zone,
    pickup_year,
    pickup_month,
    pickup_day,
    pickup_hour,
    pickup_minute,
    pickup_second,
    dropoff_year,
    dropoff_month,
    dropoff_day,
    dropoff_hour,
    dropoff_minute,
    dropoff_second,
    trip_year,
    trip_month
  FROM taxi_db.green_taxi_trips_curated 
""")


// COMMAND ----------

val blobStorage = "dta01storage.blob.core.windows.net"
val blobContainer = "nyctaxi-curated"
val blobAccessKey =  "zGpUIfM9mlxPaeTq41ItcVE4pgoP0IRFm1f3FTxEcrHEUde3Mac7l8Wwz2qATQmySJOcAFB/QU18Hy4GEDC0AQ=="
val tempDir = "wasbs://" + blobContainer + "@" + blobStorage +"/tempDirs"

val acntInfo = "fs.azure.account.key."+ blobStorage
 sc.hadoopConfiguration.set(acntInfo, blobAccessKey)

//SQL Data Warehouse related settings
 val dwDatabase = "dta"
 val dwServer = "dta" 
 val dwUser = "dta"
 val dwPass = "fy19@12345"
 val dwJdbcPort =  "1433"
 val dwJdbcExtraOptions = "encrypt=true;trustServerCertificate=true;hostNameInCertificate=*.database.windows.net;loginTimeout=30;"
 val sqlDwUrl = "jdbc:sqlserver://" + dwServer + ".database.windows.net:" + dwJdbcPort + ";database=" + dwDatabase + ";user=" + dwUser+";password=" + dwPass + ";$dwJdbcExtraOptions"
 val sqlDwUrlSmall = "jdbc:sqlserver://" + dwServer + ".database.windows.net:" + dwJdbcPort + ";database=" + dwDatabase + ";user=" + dwUser+";password=" + dwPass

spark.conf.set(
   "spark.sql.parquet.writeLegacyFormat",
   "true")


// COMMAND ----------

matViewDF.write
     .format("com.databricks.spark.sqldw")
     .option("url", sqlDwUrlSmall) 
     .option("dbtable", "NYCTaxiData-2")
     .option( "forward_spark_azure_storage_credentials","True")
     .option("tempdir", tempDir)
     .mode("overwrite")
     .save()

// COMMAND ----------

databricks secrets list 
