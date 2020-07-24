// Databricks notebook source
// MAGIC %md
// MAGIC #### Summary
// MAGIC 1) Load yellow taxi data in staging directory to raw data directory, and save as parquet<br />
// MAGIC 2) Create external unmanaged Hive tables<br />
// MAGIC 3) Create statistics for tables

// COMMAND ----------

import org.apache.spark.sql._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType,LongType,FloatType,DoubleType, TimestampType}
import com.databricks.backend.daemon.dbutils._
import com.databricks.backend.daemon.dbutils.FileInfo

// COMMAND ----------

// MAGIC %md
// MAGIC #### 1. Run shared/common notebooks

// COMMAND ----------

// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %run ./00-Functions

// COMMAND ----------

// MAGIC %md
// MAGIC #### 2. Set source and destination folder paths

// COMMAND ----------

//Source, destination directories
val srcDataDirRoot = mountRoot + source + "/transactional-data-small/"
val destDataDirRoot = mountRoot + raw + "/yellow-taxi"

// COMMAND ----------

// MAGIC %md
// MAGIC #### 3. Prepare canonical schema to which to conform source data sets

// COMMAND ----------

// Canonical ordered column list to homogenize schema
val canonicalTripSchemaColList = Seq(
	"trip_year",
	"trip_month",
	"taxi_type",
	"vendor_id",
	"pickup_datetime",
	"dropoff_datetime",
	"passenger_count",
	"trip_distance",
	"rate_code_id",
	"store_and_fwd_flag",
	"pickup_location_id",
	"dropoff_location_id",
	"pickup_longitude",
	"pickup_latitude",
	"dropoff_longitude",
	"dropoff_latitude",
	"payment_type",
	"fare_amount",
	"extra",
	"mta_tax",
	"tip_amount",
	"tolls_amount",
	"improvement_surcharge",
	"total_amount"
)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 4. Define schemas for source data
// MAGIC Different years have different schemas - fields added/removed

// COMMAND ----------

//Schema for source data based on year and month

// 2016H2, 2017, 2018
val yellowTripSchema_16H2to18 = StructType(Array(
    StructField("VendorID", StringType, true),
    StructField("tpep_pickup_datetime", TimestampType, true),
    StructField("tpep_dropoff_datetime", TimestampType, true),
    StructField("passenger_count", IntegerType, true),
    StructField("trip_distance", DoubleType, true),
    StructField("RatecodeID", IntegerType, true),
    StructField("store_and_fwd_flag", StringType, true),
    StructField("PULocationID", IntegerType, true),
    StructField("DOLocationID", IntegerType, true),
    StructField("payment_type", StringType, true),
    StructField("fare_amount", DoubleType, true),
    StructField("extra", DoubleType, true),
    StructField("mta_tax", DoubleType, true),
    StructField("tip_amount", DoubleType, true),
    StructField("tolls_amount", DoubleType, true),
    StructField("improvement_surcharge", DoubleType, true),
    StructField("total_amount", DoubleType, true)))

//2015 and 2016H1
val yellowTripSchema_15to16H1 = StructType(Array(
    StructField("VendorID", StringType, true),
    StructField("tpep_pickup_datetime", TimestampType, true),
    StructField("tpep_dropoff_datetime", TimestampType, true),
    StructField("passenger_count", IntegerType, true),
    StructField("trip_distance", DoubleType, true),
    StructField("pickup_longitude", DoubleType, true),
    StructField("pickup_latitude", DoubleType, true),
    StructField("RatecodeID", IntegerType, true),
    StructField("store_and_fwd_flag", StringType, true),
    StructField("dropoff_longitude", DoubleType, true),
    StructField("dropoff_latitude", DoubleType, true),
    StructField("payment_type", StringType, true),
    StructField("fare_amount", DoubleType, true),
    StructField("extra", DoubleType, true),
    StructField("mta_tax", DoubleType, true),
    StructField("tip_amount", DoubleType, true),
    StructField("tolls_amount", DoubleType, true),
    StructField("improvement_surcharge", DoubleType, true),
    StructField("total_amount", DoubleType, true)))

//2010 though 2014
val yellowTripSchema_10to14 = StructType(Array(
    StructField("vendor_id", StringType, true),
    StructField("pickup_datetime", TimestampType, true),
    StructField("dropoff_datetime", TimestampType, true),
    StructField("passenger_count", IntegerType, true),
    StructField("trip_distance", DoubleType, true),
    StructField("pickup_longitude", DoubleType, true),
    StructField("pickup_latitude", DoubleType, true),
    StructField("rate_code", IntegerType, true),
    StructField("store_and_fwd_flag", StringType, true),
    StructField("dropoff_longitude", DoubleType, true),
    StructField("dropoff_latitude", DoubleType, true),
    StructField("payment_type", StringType, true),
    StructField("fare_amount", DoubleType, true),
    StructField("surcharge", DoubleType, true),
    StructField("mta_tax", DoubleType, true),
    StructField("tip_amount", DoubleType, true),
    StructField("tolls_amount", DoubleType, true),
    StructField("total_amount", DoubleType, true)))

// COMMAND ----------

// MAGIC %md
// MAGIC #### 5. Schema functions

// COMMAND ----------

// Function to return schema for a given year and month
// Input:  Year and month
// Output: StructType for applicable schema 
// Sample call: println(GetTaxiSchema(2009,1))

def GetTaxiSchema(tripYear: Int, tripMonth: Int): StructType = {
  var taxiSchema : StructType = null

  val years10To14 = Set(2010, 2011, 2012, 2013, 2014)
  
  if (tripYear >= 2017 || (tripYear == 2016 && tripMonth > 6))
  {
    // println("yellowTripSchema_16H2to18")
    taxiSchema = yellowTripSchema_16H2to18
  }
  else if ((tripYear == 2016 && tripMonth <= 6) || tripYear == 2015)
  {
    // println("yellowTripSchema_15to16H1")
    taxiSchema = yellowTripSchema_15to16H1
  }
  else if (years10To14 contains tripYear)
  {
    // println("yellowTripSchema_10to14")
    taxiSchema = yellowTripSchema_10to14
  }
//  else if (tripYear == 2009)
//    taxiSchema = yellowTripSchema_09
  else
  {
    println("No schema match!")
  }

  taxiSchema
}

// COMMAND ----------

// Function to add columns to dataframe as required to homogenize schema
// Input:  Dataframe, year and month
// Output: Dataframe with homogenized schema 
// Sample call: println(GetSchemaHomogenizedDataframe(DF,2014,6))

def GetSchemaHomogenizedDataframe(sourceDF: org.apache.spark.sql.DataFrame,
                                  tripYear: Int, 
                                  tripMonth: Int): org.apache.spark.sql.DataFrame =
{
  val years10To14 = Set(2010, 2011, 2012, 2013, 2014)
  
  var df : org.apache.spark.sql.DataFrame = null

  if (tripYear >= 2017 || (tripYear == 2016 && tripMonth > 6))
  {
    df = sourceDF
      .withColumn("trip_year", substring(col("tpep_pickup_datetime"), 0, 4))
      .withColumn("trip_month", substring(col("tpep_pickup_datetime"), 6, 2))
      .withColumn("taxi_type", lit("yellow"))
      .withColumn("temp_vendor_id", col("VendorID").cast(StringType)).drop("VendorID").withColumnRenamed("temp_vendor_id", "vendor_id")
      .withColumnRenamed("tpep_pickup_datetime", "pickup_datetime")
      .withColumnRenamed("tpep_dropoff_datetime", "dropoff_datetime")
      // passenger_count
      // trip_distance
      .withColumnRenamed("RatecodeID", "rate_code_id")
      // store_and_fwd_flag
      .withColumnRenamed("PULocationID", "pickup_location_id")
      .withColumnRenamed("DOLocationID", "dropoff_location_id")
      .withColumn("pickup_longitude", lit(""))
      .withColumn("pickup_latitude", lit(""))
      .withColumn("dropoff_longitude", lit(""))
      .withColumn("dropoff_latitude", lit(""))
      .withColumn("temp_payment_type", col("payment_type").cast(StringType)).drop("payment_type").withColumnRenamed("temp_payment_type", "payment_type")
      // fare_amount
      // extra
      // mta_tax
      // tip_amount
      // tolls_amount
      // improvement_surcharge
      // total_amount
  }
  else if ((tripYear == 2016 && tripMonth <= 6) || tripYear == 2015)
  {
    df = sourceDF
      .withColumn("trip_year", substring(col("tpep_pickup_datetime"), 0, 4))
      .withColumn("trip_month", substring(col("tpep_pickup_datetime"), 6, 2))
      .withColumn("taxi_type", lit("yellow"))
      .withColumn("temp_vendor_id", col("VendorID").cast(StringType)).drop("VendorID").withColumnRenamed("temp_vendor_id", "vendor_id")
      .withColumnRenamed("tpep_pickup_datetime", "pickup_datetime")
      .withColumnRenamed("tpep_dropoff_datetime", "dropoff_datetime")
      // passenger_count
      // trip_distance
      .withColumnRenamed("RatecodeID", "rate_code_id")
      // store_and_fwd_flag
      .withColumn("pickup_location_id", lit(0).cast(IntegerType))
      .withColumn("dropoff_location_id", lit(0).cast(IntegerType))
      .withColumn("temp_pickup_longitude", col("pickup_longitude").cast(StringType)).drop("pickup_longitude").withColumnRenamed("temp_pickup_longitude", "pickup_longitude")
      .withColumn("temp_pickup_latitude", col("pickup_latitude").cast(StringType)).drop("pickup_latitude").withColumnRenamed("temp_pickup_latitude", "pickup_latitude")
      .withColumn("temp_dropoff_longitude", col("dropoff_longitude").cast(StringType)).drop("dropoff_longitude").withColumnRenamed("temp_dropoff_longitude", "dropoff_longitude")
      .withColumn("temp_dropoff_latitude", col("dropoff_latitude").cast(StringType)).drop("dropoff_latitude").withColumnRenamed("temp_dropoff_latitude", "dropoff_latitude")
      .withColumn("temp_payment_type", col("payment_type").cast(StringType)).drop("payment_type").withColumnRenamed("temp_payment_type", "payment_type")
      // fare_amount
      // extra
      // mta_tax
      // tip_amount
      // tolls_amount
      // improvement_surcharge
      // total_amount
  }
  else if (years10To14 contains tripYear)
  {
    df = sourceDF
      .withColumn("trip_year", substring(col("pickup_datetime"), 0, 4))
      .withColumn("trip_month", substring(col("pickup_datetime"), 6, 2))    
      .withColumn("taxi_type", lit("yellow"))
      .withColumn("temp_vendor_id", col("vendor_id").cast(StringType)).drop("vendor_id").withColumnRenamed("temp_vendor_id", "vendor_id")
      // pickup_datetime
      // dropoff_datetime
      // passenger_count
      // trip_distance 
      .withColumnRenamed("rate_code", "rate_code_id")
      // store_and_fwd_flag
      .withColumn("pickup_location_id", lit(0).cast(IntegerType))
      .withColumn("dropoff_location_id", lit(0).cast(IntegerType))
      .withColumn("temp_pickup_longitude", col("pickup_longitude").cast(StringType)).drop("pickup_longitude").withColumnRenamed("temp_pickup_longitude", "pickup_longitude")
      .withColumn("temp_pickup_latitude", col("pickup_latitude").cast(StringType)).drop("pickup_latitude").withColumnRenamed("temp_pickup_latitude", "pickup_latitude")
      .withColumn("temp_dropoff_longitude", col("dropoff_longitude").cast(StringType)).drop("dropoff_longitude").withColumnRenamed("temp_dropoff_longitude", "dropoff_longitude")
      .withColumn("temp_dropoff_latitude", col("dropoff_latitude").cast(StringType)).drop("dropoff_latitude").withColumnRenamed("temp_dropoff_latitude", "dropoff_latitude")
      .withColumn("temp_payment_type", col("payment_type").cast(StringType)).drop("payment_type").withColumnRenamed("temp_payment_type", "payment_type")
      // fare_amount
      .withColumnRenamed("surcharge", "extra")
      // mta_tax
      // tip_amount
      // tolls_amount
      .withColumn("improvement_surcharge",lit(0).cast(DoubleType))
      // total_amount
  }
  
  df
}

// COMMAND ----------

// MAGIC %md
// MAGIC #### 6. Create Hive external table

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)

// COMMAND ----------

spark.catalog.listTables.show(false)

// COMMAND ----------

spark.sql("DROP TABLE IF EXISTS yellow_taxi_trips")

// COMMAND ----------

spark.sql("""
  CREATE TABLE IF NOT EXISTS yellow_taxi_trips(
    trip_year STRING,
    trip_month STRING,
    taxi_type STRING,
    vendor_id STRING,
    pickup_datetime TIMESTAMP,
    dropoff_datetime TIMESTAMP,
    passenger_count INT,
    trip_distance DOUBLE,
    rate_code_id INT,
    store_and_fwd_flag STRING,
    pickup_location_id INT,
    dropoff_location_id INT,
    pickup_longitude STRING,
    pickup_latitude STRING,
    dropoff_longitude STRING,
    dropoff_latitude STRING,
    payment_type STRING,
    fare_amount DOUBLE,
    extra DOUBLE,
    mta_tax DOUBLE,
    tip_amount DOUBLE,
    tolls_amount DOUBLE,
    improvement_surcharge DOUBLE,
    total_amount DOUBLE)
  USING parquet
  PARTITIONED BY (trip_year, trip_month)
  LOCATION '""" + mountRoot + raw + """/yellow-taxi/'"""
)

// COMMAND ----------

spark.catalog.listTables.show(false)

// COMMAND ----------

// MAGIC %md
// MAGIC #### 7. Read CSV, homogenize schema across years, save as parquet

// COMMAND ----------

//Delete any residual data from prior executions for an idempotent run
dbutils.fs.rm(destDataDirRoot, recurse=true)

// COMMAND ----------

// To make Hive Parquet format compatible with Spark Parquet format
spark.sqlContext.setConf("spark.sql.parquet.writeLegacyFormat", "true")

//Process data, save as parquet
for (yyyy <- 2010 to 2018)
  {
    var startMonth = 1

    // At this writing we only have Jan-June for 2018
    var endMonth = if (yyyy==2018) 6 else 12
    
    for (m <- startMonth to endMonth) 
    {
      println()

      var mm = "%02d".format(m)
      
      // Source path  
      var srcDataFile = srcDataDirRoot + "year=" + yyyy + "/month=" +  mm + "/type=yellow/yellow_tripdata_" + yyyy + "-" + mm + ".csv"
      println("srcDataFile = " + srcDataFile)

      // Destination path  
      var destDataDir = destDataDirRoot + "/trip_year=" + yyyy + "/trip_month=" + mm + "/"
      println("destDataDir = " + destDataDir)
      
      println()

      // Source schema - use the Int m for this call, not the formatted String mm
      var taxiSchema = GetTaxiSchema(yyyy, m)

      // Read source data
      var taxiDF = sqlContext.read
        .format("csv")
        .option("header", "true")
        .option("delimiter", ",")
        .schema(taxiSchema)
        .load(srcDataFile)
        .cache()
      
      /*
      println("taxiDF")
      DataframeInfo(taxiDF)
      println()
      */
      
      // Add additional columns to homogenize schema across years - use the Int m for this call, not the formatted String mm
      var taxiFormattedDF = GetSchemaHomogenizedDataframe(taxiDF, yyyy, m)

      /*
      println("taxiFormattedDF")
      DataframeInfo(taxiFormattedDF)
      println()
      */
      
      // Order all columns to align with the canonical schema for yellow taxi
      var taxiCanonicalDF = taxiFormattedDF.select(canonicalTripSchemaColList.map(c => col(c)): _*)
      //.repartition(400)

      /*
      println("taxiCanonicalDF")
      DataframeInfo(taxiCanonicalDF)
      println()
      */
      
      // Write parquet output, calling function to calculate number of partition files
      taxiCanonicalDF.coalesce(CalcOutputFileCountTxtToParquet(srcDataFile, 64)).write.parquet(destDataDir)

      // Delete residual files from job operation (_SUCCESS, _start*, _committed*)
      DeleteSparkJobFiles(destDataDir)

      // Add partition for year and month
      spark.sql("ALTER TABLE yellow_taxi_trips ADD IF NOT EXISTS PARTITION (trip_year=" + yyyy + ",trip_month=" + mm + ") LOCATION '" + destDataDir.dropRight(1) + "'")
    
      // Refresh table
      spark.sql("REFRESH TABLE yellow_taxi_trips")
    }
  }

//Compute statistics for table for performance
spark.sql("ANALYZE TABLE yellow_taxi_trips COMPUTE STATISTICS")

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)
spark.catalog.listTables.show(false)

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2010 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2011 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2012 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2013 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2014 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2015 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2016 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2017 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2018 LIMIT 100"))

// COMMAND ----------

display(spark.sql("SELECT * FROM yellow_taxi_trips WHERE trip_year = 2018 LIMIT 100"))

// COMMAND ----------


