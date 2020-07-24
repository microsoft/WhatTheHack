// Databricks notebook source
// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %run ./00-Functions

// COMMAND ----------

// MAGIC %md
// MAGIC ### Hive setup

// COMMAND ----------

spark.catalog.listDatabases.show(false)

// COMMAND ----------

spark.sql("DROP DATABASE IF EXISTS " + hiveDbName + " CASCADE")

// COMMAND ----------

spark.sql("CREATE DATABASE IF NOT EXISTS " + hiveDbName)

// COMMAND ----------

spark.catalog.listDatabases.show(false)

// COMMAND ----------

spark.catalog.setCurrentDatabase(hiveDbName)
spark.catalog.listTables.show(false)
