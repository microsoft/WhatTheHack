// Databricks notebook source
import org.apache.spark.sql.types._;
import org.apache.spark.sql.functions._;

// Device log files are written to the stream folder
val inputPath = "wasbs://spark@<YOUR_ACCOUNT>.blob.core.windows.net/stream/"

val jsonSchema = new StructType().add("device", StringType).add("status", StringType)

val inStream = 
  spark.readStream.schema(jsonSchema).option("maxFilesPerTrigger", 2).json(inputPath)

val countErrors = 
  inStream.filter("status == 'error'").groupBy(window(current_timestamp(), "1 minute"), $"device").count()

val outStream =
  countErrors.writeStream.format("memory").queryName("counts").outputMode("complete").start()


// COMMAND ----------

// MAGIC %sql
// MAGIC -- Read the in-memory table
// MAGIC select device, window.start, window.end, count from counts

// COMMAND ----------

// stop processing the stream
outStream.stop()
