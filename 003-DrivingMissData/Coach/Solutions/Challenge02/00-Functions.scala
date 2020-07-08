// Databricks notebook source
import org.apache.hadoop.fs.{ FileSystem, Path }
import org.apache.hadoop.conf.Configuration
import org.apache.spark.sql._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.{StructType, StructField, StringType, IntegerType,LongType,FloatType,DoubleType, TimestampType}
import com.databricks.backend.daemon.dbutils._
import com.databricks.backend.daemon.dbutils.FileInfo

// COMMAND ----------

// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %md
// MAGIC ###Data

// COMMAND ----------

def AnalyzeHiveTable(hiveDatabaseAndTable: String)
{
  // println("Table: " + hiveDatabaseAndTable)
  
  // println("Refresh table...")
  sql("REFRESH TABLE " + hiveDatabaseAndTable)
  
  // println("Analyze table and compute statistics...")
  sql("ANALYZE TABLE " + hiveDatabaseAndTable + " COMPUTE STATISTICS")
  
  // println("Done")
}

// COMMAND ----------

def ListHiveTables(hiveDatabase: String)
{
  spark.catalog.setCurrentDatabase(hiveDatabase)
  spark.catalog.listTables.show(false)
}

// COMMAND ----------

def DataframeInfo(df: org.apache.spark.sql.DataFrame)
{
  println("Record count: " + df.count().toString())

  // println("df.printSchema()")
  df.printSchema()
  
  // println("df.describe().show()")
  df.describe().show()

  // println("df.show(25)")
  df.show(25)
  
  // println("display(df)")
  display(df)
}

// COMMAND ----------

// MAGIC %md
// MAGIC ### Blob storage

// COMMAND ----------

// Reference: https://docs.databricks.com/spark/latest/data-sources/azure/azure-storage.html#mount-azure-blob
// In particular re the hardcoded strings below for extraConfigs

def MountStorageContainer(storageAccount: String, storageAccountKey: String, storageContainer: String, blobMountPoint: String) : Boolean =
{
  val mountStatus = dbutils.fs.mount(
    source = "wasbs://" + storageContainer + "@" + storageAccount + ".blob.core.windows.net/",
    mountPoint = blobMountPoint,
    extraConfigs = Map("fs.azure.account.key." + storageAccount + ".blob.core.windows.net" -> storageAccountKey)
  )
  
  // println("Status of mount of container " + storageContainer + " is: " + mountStatus)
  
  mountStatus
}

// COMMAND ----------

// MAGIC %md
// MAGIC ### File system

// COMMAND ----------

def CalcOutputFileCountTxtToParquet(srcTextFile: String, targetFileSizeMB: Int): Int =
{
  val fs = FileSystem.get(new Configuration())
  
  val estFileCount: Int = Math.floor((fs.getContentSummary(new Path(srcTextFile)).getLength * shrinkageParquet) / (targetFileSizeMB * 1024 * 1024)).toInt
  
  if(estFileCount == 0) 1 else estFileCount
}

// COMMAND ----------

// Get iterable file collection. Flattens hierarchical folder/file structure.
def GetRecursiveFileCollection(rootDirectoryPath: String): Seq[String] =
  dbutils.fs.ls(rootDirectoryPath).map(directoryItem =>
  {
    // Work around double encoding bug
    val directoryItemPath = directoryItem.path.replace("%25", "%").replace("%25", "%")
    
    if (directoryItem.isDir) 
      GetRecursiveFileCollection(directoryItemPath)
    else 
      Seq[String](directoryItemPath)
  })
  .reduce(_ ++ _)

// COMMAND ----------

// Delete residual files from job operation (_SUCCESS, _start*, _committed*) down the folder/file hierarchy
def DeleteSparkJobFiles(rootDirectoryPath: String)
{
  GetRecursiveFileCollection(rootDirectoryPath).foreach(directoryItemPath =>
  {
    if (directoryItemPath.indexOf("parquet") == -1)
    {
        // println("Deleting...." +  directoryItemPath)
        dbutils.fs.rm(directoryItemPath)
    }
  })
}

// COMMAND ----------


