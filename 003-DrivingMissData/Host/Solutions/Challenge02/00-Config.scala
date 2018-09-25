// Databricks notebook source
// MAGIC %md
// MAGIC ### Info / Reference

// COMMAND ----------

// MAGIC %md
// MAGIC ##### Storage Containers
// MAGIC nyctaxi-source: original data ingested from source.<br />
// MAGIC nyctaxi-reference: reference data saved as Parquet from nyctaxi-source. Hive tables created on top of these files.<br />
// MAGIC nyctaxi-raw: transaction data saved as Parquet from nyctaxi-source. Hive tables created on top of these files.<br />
// MAGIC nyctaxi-curated: denormalized, conformed data and merged materialized view for reports.

// COMMAND ----------

// MAGIC %md
// MAGIC ### Config Keys
// MAGIC 
// MAGIC The string values here (e.g. "storageAccountName" should be in the cluster config as the key part of a key-value pair)

// COMMAND ----------

val configKey_StorageAccountName = "storageAccountName"
val configKey_StorageAccountKey = "storageAccountKey"

val configKey_hiveDbName = "hiveDbName"

// COMMAND ----------

// MAGIC %md
// MAGIC ### Config Values
// MAGIC 
// MAGIC Use these from other notebooks.<br />
// MAGIC These are specified in cluster config.<br />
// MAGIC Note that if you export notebook without clearing results/state, the actual values from config will be exported as part of the notebook.<br />
// MAGIC Azure Key Vault would be a good (more secure) alternative for key storage.

// COMMAND ----------

val storageAccountName = spark.conf.get(configKey_StorageAccountName)
val storageAccountKey = spark.conf.get(configKey_StorageAccountKey)

val hiveDbName = spark.conf.get(configKey_hiveDbName)

// COMMAND ----------

// MAGIC %md
// MAGIC ### Constants
// MAGIC 
// MAGIC Use these from other notebooks.<br />
// MAGIC These are specified explicitly here.<br />
// MAGIC These should not contain sensitive information.

// COMMAND ----------

val appName = "nyctaxi"

val source = "source"
val reference = "reference"
val raw = "raw"
val curated = "curated"

// COMMAND ----------

val mountRoot = "/mnt/data/" + appName + "/"

// COMMAND ----------

val shrinkageParquet = 0.2 //Target compression for Parquet files from uncompressed"

// COMMAND ----------


