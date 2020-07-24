// Databricks notebook source
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

//Read source data
val VendorDF = sql("""
SELECT 
   *
  FROM taxi_db.Vendor_Lookup
""")

VendorDF.write
     .format("com.databricks.spark.sqldw")
     .option("url", sqlDwUrlSmall) 
     .option("dbtable", "Vendor_Lookup")
     .option( "forward_spark_azure_storage_credentials","True")
     .option("tempdir", tempDir)
     .mode("overwrite")
     .save()

// COMMAND ----------

//Read source data
val trip_typeDF = sql("""
SELECT 
   *
  FROM taxi_db.trip_type_lookup
""")

trip_typeDF.write
     .format("com.databricks.spark.sqldw")
     .option("url", sqlDwUrlSmall) 
     .option("dbtable", "trip_type_lookup")
     .option( "forward_spark_azure_storage_credentials","True")
     .option("tempdir", tempDir)
     .mode("overwrite")
     .save()

// COMMAND ----------

//Read source data
val trip_monthDF = sql("""
SELECT 
   *
  FROM taxi_db.trip_month_lookup
""")

trip_monthDF.write
     .format("com.databricks.spark.sqldw")
     .option("url", sqlDwUrlSmall) 
     .option("dbtable", "trip_month_lookup")
     .option( "forward_spark_azure_storage_credentials","True")
     .option("tempdir", tempDir)
     .mode("overwrite")
     .save()

// COMMAND ----------

//Read source data
val payment_typeDF = sql("""
SELECT 
   *
  FROM taxi_db.payment_type_lookup
""")

payment_typeDF.write
     .format("com.databricks.spark.sqldw")
     .option("url", sqlDwUrlSmall) 
     .option("dbtable", "payment_type_lookup")
     .option( "forward_spark_azure_storage_credentials","True")
     .option("tempdir", tempDir)
     .mode("overwrite")
     .save()

// COMMAND ----------

//Read source data
val rate_codeDF = sql("""
SELECT 
   *
  FROM taxi_db.rate_code_lookup
""")

rate_codeDF.write
     .format("com.databricks.spark.sqldw")
     .option("url", sqlDwUrlSmall) 
     .option("dbtable", "rate_code_lookup")
     .option( "forward_spark_azure_storage_credentials","True")
     .option("tempdir", tempDir)
     .mode("overwrite")
     .save()

// COMMAND ----------

//Read source data
val taxi_zoneDF = sql("""
SELECT 
   *
  FROM taxi_db.taxi_zone_lookup
""")

taxi_zoneDF.write
     .format("com.databricks.spark.sqldw")
     .option("url", sqlDwUrlSmall) 
     .option("dbtable", "taxi_zone_lookup")
     .option( "forward_spark_azure_storage_credentials","True")
     .option("tempdir", tempDir)
     .mode("overwrite")
     .save()

// COMMAND ----------

dbutils.secrets list-scopes
