// Databricks notebook source
// MAGIC %sql
// MAGIC USE nyctaxi;

// COMMAND ----------

// MAGIC %md
// MAGIC #### 1.  Trip count by taxi type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type,
// MAGIC   count(*) as trip_count
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC group by taxi_type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type,
// MAGIC   count(*) as trip_count
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC group by taxi_type

// COMMAND ----------

// MAGIC %md
// MAGIC #### 2.  Revenue including tips by taxi type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type, sum(total_amount + tip_amount) as revenue_with_tip
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC group by
// MAGIC   taxi_type

// COMMAND ----------

// MAGIC %md
// MAGIC #### 3.  Revenue share by taxi type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type, sum(total_amount) revenue
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC group by
// MAGIC   taxi_type

// COMMAND ----------

// MAGIC %md
// MAGIC #### 4.  Trip count trend between 2010 and 2017 (2018 not complete year yet)

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type,
// MAGIC   trip_year,
// MAGIC   count(*) as trip_count
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC where
// MAGIC   trip_year between 2010 and 2017
// MAGIC group by
// MAGIC   taxi_type, trip_year
// MAGIC order by
// MAGIC   trip_year asc

// COMMAND ----------

// MAGIC %md
// MAGIC #### 5.  Trip count trend by month, by taxi type, for 2017

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type,
// MAGIC   trip_month as month,
// MAGIC   count(*) as trip_count
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC where 
// MAGIC   trip_year=2017
// MAGIC group by
// MAGIC   taxi_type, trip_month
// MAGIC order by
// MAGIC   trip_month 

// COMMAND ----------

// MAGIC %md
// MAGIC #### 6.  Average trip distance by taxi type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type,
// MAGIC   round(avg(trip_distance), 2) as trip_distance_miles
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC group by
// MAGIC   taxi_type

// COMMAND ----------

// MAGIC %md
// MAGIC #### 7.  Average trip amount by taxi type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type,
// MAGIC   round(avg(total_amount), 2) as avg_total_amount
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC group by
// MAGIC   taxi_type

// COMMAND ----------

// MAGIC %md
// MAGIC #### 8.  Trips with no tip, by taxi type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type,
// MAGIC   count(*) as tipless_count
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC where
// MAGIC   tip_amount = 0
// MAGIC group by
// MAGIC   taxi_type

// COMMAND ----------

// MAGIC %md
// MAGIC #### 9.  Trips with no charge, by taxi type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   taxi_type,
// MAGIC   count(*) as num_transactions
// MAGIC from 
// MAGIC   taxi_trips_mat_view
// MAGIC where
// MAGIC   payment_type_description = 'No charge' and
// MAGIC   total_amount = 0.0
// MAGIC group by
// MAGIC   taxi_type

// COMMAND ----------

// MAGIC %md
// MAGIC #### 10.  Trips by payment type

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   payment_type_description,
// MAGIC   count(*) as num_transactions
// MAGIC from
// MAGIC   nyctaxi.taxi_trips_mat_view
// MAGIC group by
// MAGIC   payment_type_description

// COMMAND ----------

// MAGIC %md
// MAGIC #### 11.  Trip trend by pickup hour for yellow taxi in 2017

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select
// MAGIC   pickup_hour,
// MAGIC   count(*) as num_pickups
// MAGIC from
// MAGIC   nyctaxi.yellow_taxi_trips_curated
// MAGIC where
// MAGIC   trip_year=2017
// MAGIC group by
// MAGIC   pickup_hour
// MAGIC order by
// MAGIC   pickup_hour

// COMMAND ----------

// MAGIC %md
// MAGIC #### 12.  Top 3 yellow taxi pickup-dropoff zones for 2017

// COMMAND ----------

// MAGIC %sql
// MAGIC 
// MAGIC select 
// MAGIC   pickup_zone,
// MAGIC   dropoff_zone,
// MAGIC   count(*) as trip_count
// MAGIC from 
// MAGIC   nyctaxi.yellow_taxi_trips_curated
// MAGIC where 
// MAGIC   trip_year = 2017 and
// MAGIC   pickup_zone is not null and
// MAGIC   pickup_zone <> 'NV' and 
// MAGIC   dropoff_zone is not null and
// MAGIC   dropoff_zone <> 'NV'
// MAGIC group by
// MAGIC   pickup_zone,
// MAGIC   dropoff_zone
// MAGIC order by
// MAGIC   trip_count desc
// MAGIC limit 3

// COMMAND ----------


