// Databricks notebook source
// MAGIC %md
// MAGIC ### Download NYC taxi public dataset

// COMMAND ----------

// MAGIC %md
// MAGIC # DO NOT RUN THIS AT OPENHACK
// MAGIC # USE AZURE-STORED NYC TAXI DATA INSTEAD
// MAGIC # THIS IS HERE FOR REFERENCE ONLY

// COMMAND ----------

// MAGIC %md
// MAGIC Reference: http://www.nyc.gov/html/tlc/html/about/trip_record_data.shtml

// COMMAND ----------

import sys.process._
import scala.sys.process.ProcessLogger

// COMMAND ----------

// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %md
// MAGIC ### Reference data

// COMMAND ----------

/*
Only one of the six reference data files is at the AWS S3 URL indicated in Anagha's notebook. Don't know where the others came from.
I got them from her storage account.

payment_type_lookup.csv - unknown
rate_code_lookup.csv - unknown
taxi_zone_lookup.csv - https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv   (also don't know why there's a + in the file name)
trip_month_lookup.csv - unknown
trip_type_lookup.csv - unknown
vendor_lookup.csv - unknown
*/

// COMMAND ----------

// Delete local files if exist
dbutils.fs.rm("file:/tmp/taxi+_zone_lookup.csv")

// COMMAND ----------

// Local and blob paths
val localPath = "file:/tmp/taxi+_zone_lookup.csv"
val wasbPath = mountRoot + "scratch/reference-data/taxi_zone_lookup.csv"

// Download files to local tmp
"wget -P /tmp https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv" !!

// Inspect local
display(dbutils.fs.ls(localPath))

// Copy local to blob
dbutils.fs.cp(localPath, wasbPath)

// Cleanup local
dbutils.fs.rm(localPath)

// Inspect blob
display(dbutils.fs.ls(wasbPath))

// COMMAND ----------

// MAGIC %md
// MAGIC ### Transactional Data

// COMMAND ----------

def GetFileName(taxiType: String, year: Int, month: Int): String =
{
  var fileName = taxiType + "_tripdata_" + year + "-" + "%02d".format(month) + ".csv"
  
  // println(fileName)
  
  return fileName
}

// COMMAND ----------

def GetLocalPath(fileName: String): String =
{
  var localPath = "file:/tmp/" + fileName
  
  // println(localPath)
  
  return localPath
}

// COMMAND ----------

def GetWasbPath(taxiType: String, year: Int, month: Int): String =
{
  var wasbPath = mountRoot + "source/transactional-data/year=" + year + "/month=" + "%02d".format(month) + "/type=" + taxiType + "/"
  
  // println(wasbPath)
  
  return wasbPath
}

// COMMAND ----------

def DownloadFile(taxiType: String, year: Int, startMonth: Int, endMonth: Int)
{
  for (month <- startMonth to endMonth)
  {
    val fileName = GetFileName(taxiType, year, month)
    val localPath = GetLocalPath(fileName)
    val wasbPath = GetWasbPath(taxiType, year, month)

    val wgetToExec = "wget -nv -P /tmp https://s3.amazonaws.com/nyc-tlc/trip+data/" + fileName

    println(wgetToExec)

    wgetToExec !!

    // Make folders in blob
    dbutils.fs.mkdirs(wasbPath)

    // Copy local to blob
    dbutils.fs.cp(localPath, wasbPath)

    // Cleanup local
    dbutils.fs.rm(localPath)

    // Inspect blob
    // display(dbutils.fs.ls(wasbPath))
  }
}

// COMMAND ----------

// 2018: Months 1-6

val taxiTypes = Seq("yellow", "green")
val year = 2018
val startMonth = 1
val endMonth = 6

for (taxiType <- taxiTypes)
{
  DownloadFile(taxiType, year, startMonth, endMonth)
}

// COMMAND ----------

// 2017: Months 1-12

val taxiTypes = Seq("yellow", "green", "fhv")
val year = 2017
val startMonth = 1
val endMonth = 12

for (taxiType <- taxiTypes)
{
  DownloadFile(taxiType, year, startMonth, endMonth)
}

// COMMAND ----------

// 2014-2016
// Months 1-12

val taxiTypes = Seq("yellow", "green")
val years = Seq(2014, 2015, 2016)
val startMonth = 1
val endMonth = 12

for (year <- years)
{
 for (taxiType <- taxiTypes)
  {
    DownloadFile(taxiType, year, startMonth, endMonth)
  }
}

// COMMAND ----------

// 2013
// Months 1-7

val taxiTypes = Seq("yellow")
val year = 2013
val startMonth = 1
val endMonth = 7

for (taxiType <- taxiTypes)
{
  DownloadFile(taxiType, year, startMonth, endMonth)
}

// COMMAND ----------

// 2013
// Months 8-12

val taxiTypes = Seq("yellow", "green")
val year = 2013
val startMonth = 8
val endMonth = 12

for (taxiType <- taxiTypes)
{
  DownloadFile(taxiType, year, startMonth, endMonth)
}

// COMMAND ----------

// 2009-2012
// Months 1-12

val taxiTypes = Seq("yellow")
val years = Seq(2009, 2010, 2011, 2012)
val startMonth = 1
val endMonth = 12

for (year <- years)
{
 for (taxiType <- taxiTypes)
  {
    DownloadFile(taxiType, year, startMonth, endMonth)
  }
}

// COMMAND ----------

display(dbutils.fs.ls("/tmp"))
