// Databricks notebook source
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._

// The log file name is a parameter passed to the job with a default value of IISlog.txt
var filePath = "wasb://spark@<YOUR_ACCOUNT>.blob.core.windows.net/data/" + getArgument("logFile", "IISlog.txt")

// Define the schema of the log file
val log_schema = StructType(List(
  StructField("date", TimestampType, false),
  StructField("time", StringType, false),
  StructField("c_ip", StringType, false),
  StructField("cs_username", StringType, false),
  StructField("s_ip", StringType, false),
  StructField("s_port", IntegerType, false),
  StructField("cs_method", StringType, false),
  StructField("cs_uri_stem", StringType, false),
  StructField("cs_uri_query", StringType, false),
  StructField("sc_status", IntegerType, false),
  StructField("sc_bytes", IntegerType, false),
  StructField("cs_bytes", IntegerType, false),
  StructField("time_taken", IntegerType, false),
  StructField("cs_user_agent", StringType, false),
  StructField("cs_referrer", StringType, false)
))

// Read the space-delimited log file, ignoring commented lines that start with a # character
val df = spark.read.schema(log_schema).option("header",false).option("comment","#").option("sep", " ").csv(filePath)

// Filter to include only product.aspx page views, and count the entries for each distinct query string (which includes the specific product ID viewed)
val pageCounts = df.filter("cs_uri_stem = '/product.aspx'").select("cs_uri_query").groupBy("cs_uri_query").count().orderBy(desc("count"))

// Rename the columns to products and hits
val productCounts = pageCounts.select(col("cs_uri_query").alias("product"), col("count").alias("hits"))

// Combine the results to a single partition and write them out as a CSV file.
productCounts.repartition(1).write.mode("overwrite").option("header", true).csv("wasb://spark@<YOUR_ACCOUNT>.blob.core.windows.net/output")
