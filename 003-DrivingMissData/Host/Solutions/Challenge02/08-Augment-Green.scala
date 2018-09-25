// Databricks notebook source
// MAGIC %md
// MAGIC #DTA FY19 NOTE - DO NOT DO THIS!
// MAGIC #AUGMENTATION IS --NOT-- PART OF CHALLENGE02!

// COMMAND ----------

// MAGIC %md
// MAGIC #### Summary
// MAGIC 
// MAGIC 1) Read raw data, augment with derived attributes, augment with reference data & persist<br /> 
// MAGIC 2) Create external unmanaged Hive tables<br />
// MAGIC 3) Create statistics for tables                          

// COMMAND ----------

import spark.implicits._
import spark.sql
import com.databricks.backend.daemon.dbutils.FileInfo
import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.fs.{ FileSystem, Path }
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType,LongType,FloatType,DoubleType, TimestampType}

// COMMAND ----------

// MAGIC %md
// MAGIC #### 1. Run shared/common notebooks; set database

// COMMAND ----------

// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %run ./00-Functions

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 2.  Read raw, augment, persist as parquet 

// COMMAND ----------

//Destination directory
val destDataDirRoot = mountRoot + curated + "/green-taxi"

// COMMAND ----------

//Delete any residual data from prior executions for an idempotent run
dbutils.fs.rm(destDataDirRoot, recurse=true)

// COMMAND ----------

val curatedDF = spark.sql("""
  select 
      t.taxi_type,
      t.vendor_id,
      t.pickup_datetime,
      t.dropoff_datetime,
      t.store_and_fwd_flag,
      t.rate_code_id,
      t.pickup_location_id,
      t.dropoff_location_id,
      t.pickup_longitude,
      t.pickup_latitude,
      t.dropoff_longitude,
      t.dropoff_latitude,
      t.passenger_count,
      t.trip_distance,
      t.fare_amount,
      t.extra,
      t.mta_tax,
      t.tip_amount,
      t.tolls_amount,
      t.ehail_fee,
      t.improvement_surcharge,
      t.total_amount,
      t.payment_type,
      t.trip_type,
      t.trip_year,
      t.trip_month,
      v.abbreviation as vendor_abbreviation,
      v.description as vendor_description,
      tt.description as trip_type_description,
      tm.month_name_short,
      tm.month_name_full,
      pt.description as payment_type_description,
      rc.description as rate_code_description,
      tzpu.borough as pickup_borough,
      tzpu.zone as pickup_zone,
      tzpu.service_zone as pickup_service_zone,
      tzdo.borough as dropoff_borough,
      tzdo.zone as dropoff_zone,
      tzdo.service_zone as dropoff_service_zone,
      year(t.pickup_datetime) as pickup_year,
      month(t.pickup_datetime) as pickup_month,
      day(t.pickup_datetime) as pickup_day,
      hour(t.pickup_datetime) as pickup_hour,
      minute(t.pickup_datetime) as pickup_minute,
      second(t.pickup_datetime) as pickup_second,
      year(t.dropoff_datetime) as dropoff_year,
      month(t.dropoff_datetime) as dropoff_month,
      day(t.dropoff_datetime) as dropoff_day,
      hour(t.dropoff_datetime) as dropoff_hour,
      minute(t.dropoff_datetime) as dropoff_minute,
      second(t.dropoff_datetime) as dropoff_second
  from 
    green_taxi_trips t
    left outer join vendor_lookup v on (t.vendor_id = v.vendor_id)
    left outer join trip_type_lookup tt on (t.trip_type = tt.trip_type)
    left outer join trip_month_lookup tm on (t.trip_month = tm.trip_month)
    left outer join payment_type_lookup pt on (t.payment_type = pt.payment_type)
    left outer join rate_code_lookup rc on (t.rate_code_id = rc.rate_code_id)
    left outer join taxi_zone_lookup tzpu on (t.pickup_location_id = tzpu.location_id)
    left outer join taxi_zone_lookup tzdo on (t.dropoff_location_id = tzdo.location_id)
  """)


// COMMAND ----------

//Write parquet output, calling function to calculate number of partition files
curatedDF.coalesce(8).write.partitionBy("trip_year", "trip_month").parquet(destDataDirRoot)

// COMMAND ----------

//Delete residual files from job operation (_SUCCESS, _start*, _committed
DeleteSparkJobFiles(destDataDirRoot)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 3.  Define Hive external table

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS green_taxi_trips_curated")

// COMMAND ----------

spark.sql("""
  CREATE TABLE green_taxi_trips_curated(
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
  PARTITIONED BY (trip_year,trip_month)
  LOCATION '""" + mountRoot + curated + """/green-taxi/'"""
)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 4.  Create Hive table partitions

// COMMAND ----------

//Register Hive partitions for the transformed table
spark.sql("MSCK REPAIR TABLE green_taxi_trips_curated")

// COMMAND ----------

// MAGIC %md
// MAGIC #### 5.  Compute Hive table statistics

// COMMAND ----------

sql("REFRESH TABLE green_taxi_trips_curated")
sql("ANALYZE TABLE green_taxi_trips_curated COMPUTE STATISTICS")

// COMMAND ----------

display(spark.sql("select trip_year, trip_month, count(*) as trip_count from green_taxi_trips_curated group by trip_year, trip_month order by trip_year, trip_month"))
