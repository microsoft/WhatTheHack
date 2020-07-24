// Databricks notebook source
import org.apache.spark.sql._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType,LongType,FloatType,DoubleType, TimestampType}
import com.databricks.backend.daemon.dbutils._
import com.databricks.backend.daemon.dbutils.FileInfo

// COMMAND ----------

// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %run ./00-Functions

// COMMAND ----------

//Source, destination directories
val srcDataDirRoot = mountRoot + source + "/transactional-data-big/"
val destDataDirRoot = mountRoot + source + "/transactional-data-small/"

// COMMAND ----------

def Shrink(company: String, yyyy: String, mm: String, sampleProportion: Double)
{
  // Source file  
  var srcDataFile = srcDataDirRoot + "year=" + yyyy + "/month=" +  mm + "/type=" + company + "/" + company + "_tripdata_" + yyyy + "-" + mm + ".csv"     
  println("srcDataFile = " + srcDataFile)

  // Destination partition folder path (where raw CSV output will go)
  var destDataPartitionPath = destDataDirRoot + "year=" + yyyy + "/month=" +  mm + "/type=" + company + "/" + company + "_tripdata_" + yyyy + "-" + mm + ".tmp"
  println("destDataPartitionPath = " + destDataPartitionPath)

  // Destination file
  var destDataFile = destDataDirRoot + "year=" + yyyy + "/month=" + mm + "/type=" + company + "/" + company + "_tripdata_" + yyyy + "-" + mm + ".csv"
  println("destDataFile = " + destDataFile)

  // Read source file into dataframe
  var df = sqlContext.read
    .format("csv")
    .option("header", "true")
    .option("inferSchema", "true")
    .option("delimiter", ",")
    .load(srcDataFile)

  // Take a sample
  var df2 = df.sample(sampleProportion)

  // Write sample dataframe to partition folder - coaleasce to one output file
  df2
    .coalesce(1)
    .write
    .mode("overwrite")
    .option("header", "true")
    .option("delimiter", ",")
    .csv(destDataPartitionPath)

  // Get the path of the single CSV file we wrote
  var tempFilePath = dbutils.fs.ls(destDataPartitionPath).filter(file => file.name.endsWith(".csv"))(0).path

  // Copy the temp file to the path we actually want
  dbutils.fs.cp(tempFilePath, destDataFile)

  // Remove the partition folder with the Spark job files and CSV file we no longer need (now that we have a copy with correct name)
  dbutils.fs.rm(destDataPartitionPath, recurse=true)

  println()
}

// COMMAND ----------

var companies = List("yellow", "green")

for(company <- companies)
{
  var startYear = 2018

  // Yellow data starts in 2010 (actually 2009 but that data is a mess). Green starts in 2013.
  if (company == "yellow")
    startYear = 2010
  else if (company == "green")
    startYear = 2013
  
  var endYear = 2018

  
  for (yyyy <- startYear to endYear)
  {
    var startMonth = 1
    
    // The first year of Green, 2013, starts in August
    if (company == "green" && yyyy == 2013)
      startMonth = 8
    
    // For 2018 our source data stops with June
    var endMonth = if (yyyy == 2018) 6 else 12
    
    for (m <- startMonth to endMonth)
    {
      // By default we'll take 1 in 20 records
      var sampleProportion = 0.05
      
      if (company == "green")
      {
        // Green has much less source data than Yellow, so we'll take 1 in 3 for Green to even it out a bit in the reduced sample
        sampleProportion = 0.33
      }
      else if (company == "yellow" && (yyyy >= 2017 || (yyyy == 2016 && m > 6)))
      {
        // Starting in July 2016, Yellow file sizes shrunk by half so we'll take 1 in 10 starting then
        sampleProportion = 0.1
      }
      
      var sy = yyyy.toString()
      var mm = "%02d".format(m)
      
      Shrink(company, sy, mm, sampleProportion)
    }
  }
}

// COMMAND ----------


