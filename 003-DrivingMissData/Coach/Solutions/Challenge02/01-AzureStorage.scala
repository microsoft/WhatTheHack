// Databricks notebook source
// MAGIC %run ./00-Config

// COMMAND ----------

// MAGIC %run ./00-Functions

// COMMAND ----------

// MAGIC %md
// MAGIC #### Mount Azure blob storage

// COMMAND ----------

MountStorageContainer(storageAccountName, storageAccountKey, appName + "-" + source, mountRoot + source)
MountStorageContainer(storageAccountName, storageAccountKey, appName + "-" + reference, mountRoot + reference)
MountStorageContainer(storageAccountName, storageAccountKey, appName + "-" + raw, mountRoot + raw)
MountStorageContainer(storageAccountName, storageAccountKey, appName + "-" + curated, mountRoot + curated)

// COMMAND ----------

// List with Databricks util command
display(dbutils.fs.ls(mountRoot))

// COMMAND ----------

// MAGIC %md
// MAGIC #### Unmount storage

// COMMAND ----------

// Here for reference / optional use
/*
dbutils.fs.unmount(mountRoot + curated)
dbutils.fs.unmount(mountRoot + raw)
dbutils.fs.unmount(mountRoot + reference)
dbutils.fs.unmount(mountRoot + source)
*/

// COMMAND ----------

// MAGIC %md
// MAGIC #### Refresh mounts

// COMMAND ----------

// Here for reference / optional use
// dbutils.fs.refreshMounts()
