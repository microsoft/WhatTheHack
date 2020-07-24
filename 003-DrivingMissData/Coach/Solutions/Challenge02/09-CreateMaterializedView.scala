// Databricks notebook source
// MAGIC %md
// MAGIC #DTA FY19 NOTE
// MAGIC #ATTENDEES SHOULD USE CODE SIMILAR TO THIS BUT!!
// MAGIC #THEIR CODE SHOULD BE THE NON-AUGMENTED TRANSACTION TABLES ONLY!
// MAGIC #THIS NOTEBOOK SHOWS USE OF AUGMENTED SCHEMAS - FROM BEFORE WE DECIDED TO REMOVE AUGMENTATION
// MAGIC #I.E. DENORMALIZATION WITH REF DATA

// COMMAND ----------

import org.apache.spark.sql.functions._

// COMMAND ----------

// MAGIC %md
// MAGIC #### 1. Run shared/common notebooks; set paths and database

// COMMAND ----------

// MAGIC %run "./00-Config"

// COMMAND ----------

// MAGIC %run "./00-Functions"

// COMMAND ----------

//Destination directory
val destDataDirRoot = mountRoot + curated + "/materialized-view" 

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 2.  Add extra columns to yellow taxi - to match green taxi
// MAGIC Because we are working with parquet, we cannot just throw in additional columns in a select statement.<BR>
// MAGIC We are systematically adding the three extra columns with default values in this section.

// COMMAND ----------

spark.sql("REFRESH TABLE yellow_taxi_trips_curated")

// COMMAND ----------

spark.sql("REFRESH TABLE green_taxi_trips_curated")

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
  FROM yellow_taxi_trips_curated 
""")

//Add extra columns
val yellowTaxiDFHomogenized = yellowTaxiDF.withColumn("ehail_fee", lit(0.0))
    .withColumn("trip_type", lit(0))
    .withColumn("trip_type_description", lit(""))
    .cache()

//Materialize
yellowTaxiDFHomogenized.count()

//Register temporary view
yellowTaxiDFHomogenized.createOrReplaceTempView("yellow_taxi_trips_unionable")

// COMMAND ----------

yellowTaxiDFHomogenized.printSchema

// COMMAND ----------

// MAGIC %md
// MAGIC #### 3.  Create materialized view

// COMMAND ----------

//Delete any residual data from prior executions for an idempotent run
dbutils.fs.rm(destDataDirRoot, recurse=true)

// COMMAND ----------

val matViewDF = sql("""
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
  FROM green_taxi_trips_curated 
""").cache()

// COMMAND ----------

//Write parquet output, calling function to calculate number of partition files
matViewDF.coalesce(8).write.partitionBy("taxi_type", "trip_year", "trip_month").parquet(destDataDirRoot)

// COMMAND ----------

matViewDF.printSchema

// COMMAND ----------

//Delete residual files from job operation (_SUCCESS, _start*, _committed*)
DeleteSparkJobFiles(destDataDirRoot)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 4.  Create Hive external table

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS taxi_trips_mat_view")

// COMMAND ----------

spark.sql("""
  CREATE TABLE taxi_trips_mat_view(
    taxi_type STRING,
    vendor_id INT,
    pickup_datetime TIMESTAMP,
    dropoff_datetime TIMESTAMP,
    store_and_fwd_flag STRING,
    rate_code_id INT,
    pickup_location_id INT,
    dropoff_location_id INT,
    pickup_longitude STRING,
    pickup_latitude STRING,
    dropoff_longitude STRING,
    dropoff_latitude STRING,
    passenger_count INT,
    trip_distance DOUBLE,
    fare_amount DOUBLE,
    extra DOUBLE,
    mta_tax DOUBLE,
    tip_amount DOUBLE,
    tolls_amount DOUBLE,
    ehail_fee DOUBLE,
    improvement_surcharge DOUBLE,
    total_amount DOUBLE,
    payment_type INT,
    trip_type INT,
    trip_year STRING,
    trip_month STRING,
    vendor_abbreviation STRING,
    vendor_description STRING,
    trip_type_description STRING,
    month_name_short STRING,
    month_name_full STRING,
    payment_type_description STRING,
    rate_code_description STRING,
    pickup_borough STRING,
    pickup_zone STRING,
    pickup_service_zone STRING,
    dropoff_borough STRING,
    dropoff_zone STRING,
    dropoff_service_zone STRING,
    pickup_year INT,
    pickup_month INT,
    pickup_day INT,
    pickup_hour INT,
    pickup_minute INT,
    pickup_second INT,
    dropoff_year INT,
    dropoff_month INT,
    dropoff_day INT,
    dropoff_hour INT,
    dropoff_minute INT,
    dropoff_second INT)
  USING parquet
  PARTITIONED BY (taxi_type, trip_year, trip_month)
  LOCATION '""" + mountRoot + curated + """/materialized-view/'"""
)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 5.  Create Hive table partitions

// COMMAND ----------

//Register Hive partitions for the transformed table
spark.sql("MSCK REPAIR TABLE taxi_trips_mat_view")

// COMMAND ----------

// MAGIC %md
// MAGIC #### 6.  Compute table statistics

// COMMAND ----------

//Compute statistics
sql("ANALYZE TABLE taxi_trips_mat_view COMPUTE STATISTICS")

// COMMAND ----------

display(spark.sql("select taxi_type, count(*) as trip_count from taxi_trips_mat_view group by taxi_type"))
