// Databricks notebook source
import com.databricks.backend.daemon.dbutils._

// COMMAND ----------

def GenerateBatchID(): Int = 
{
  var batchId: Int = 0
  
  spark.sql("CREATE TABLE IF NOT EXISTS batch_job_history (batch_id INT, name STRING, status STRING, timestamp TIMESTAMP)")
  
  val recordCount = sql("select count(batch_id) from batch_job_history").first().getLong(0)
  
  println("Record count = " + recordCount)

  if(recordCount == 0)
    batchId = 1
  else 
    batchId = sql("select max(batch_id) from batch_job_history").first().getInt(0) + 1
 
  batchId
}

// COMMAND ----------


