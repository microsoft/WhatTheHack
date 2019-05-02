// Databricks notebook source
// MAGIC %md
// MAGIC # Using Dataframes in Spark
// MAGIC Dataframes are the standard data structure in Spark 2.0 and later. They offer a consistent way to work with data in any Spark-supported language (Python, Scala, R, Java, etc.), and also support the Spark SQL API so you can query and manipulate data using SQL syntax.
// MAGIC 
// MAGIC In this lab, exercise, you'll use Dataframes to explore some data from the United Kingdom Government Department for Transport that includes details of road traffic accidents in 2016 (you'll find more of this data and related documentation at https://data.gov.uk/dataset/cb7ae6f0-4be6-4935-9277-47e5ce24a11f/road-safety-data.)
// MAGIC 
// MAGIC ## Read a Dataframe from a File
// MAGIC After uploading the data files for this lab to your Azure storage account, adapt the code below to read the *Accidents.csv* file from your account into a Dataframe by replacing ***ACCOUNT_NAME*** with the name of your storage account:

// COMMAND ----------

val textFile = spark.read.text("wasb://spark@ACCOUNT_NAME.blob.core.windows.net/data/Accidents.csv")
textFile.printSchema()

// COMMAND ----------

// MAGIC %md
// MAGIC View the output returned, which describes the schema of the DataFrame. Note that the file content has been loaded into a DataFrame with a single column named **value**.
// MAGIC 
// MAGIC Let's take a look at the first ten lines of the text file:

// COMMAND ----------

textFile.show(10, truncate = false)

// COMMAND ----------

// MAGIC %md
// MAGIC The file seems to contain comma-separated values, with the column header names in the first line.
// MAGIC 
// MAGIC You can use the **spark.read.csv** function to read a CSV file and infer the schema from its contents. Adapt the following code to use your storage account and run it to see the schema it infers:

// COMMAND ----------

val accidents = spark.read.option("inferSchema","true").option("header","true").csv("wasb://spark@ACCOUNT_NAME.blob.core.windows.net/data/Accidents.csv")
accidents.printSchema()

// COMMAND ----------

// MAGIC %md
// MAGIC Now let's look at the first ten rows of data:

// COMMAND ----------

accidents.show(10)

// COMMAND ----------

// MAGIC %md
// MAGIC Inferring the schema makes it easy to read structured data files into a DataFrame containing multiple columns. However, it incurs a performance overhead; and in some cases you may want to have specific control over column names or data types. For example, use the following code to define the schema of the *Vehicles.csv* file:

// COMMAND ----------

import org.apache.spark.sql.types._;

val vehicle_schema = StructType(List(
  StructField("Accident_Index", StringType, false),
  StructField("Vehicle_Reference", IntegerType, false),
  StructField("Vehicle_Type", IntegerType, false),
  StructField("Towing_and_Articulation", StringType, false),
  StructField("Vehicle_Manoeuvre", IntegerType, false),
  StructField("Vehicle_Location-Restricted_Lane", IntegerType, false),
  StructField("Junction_Location", IntegerType, false),
  StructField("Skidding_and_Overturning", IntegerType, false),
  StructField("Hit_Object_in_Carriageway", IntegerType, false),
  StructField("Vehicle_Leaving_Carriageway", IntegerType, false),
  StructField("Hit_Object_off_Carriageway", IntegerType, false),
  StructField("1st_Point_of_Impact", IntegerType, false),
  StructField("Was_Vehicle_Left_Hand_Drive?", IntegerType, false),
  StructField("Journey_Purpose_of_Driver", IntegerType, false),
  StructField("Sex_of_Driver", IntegerType, false),
  StructField("Age_of_Driver", IntegerType, false),
  StructField("Age_Band_of_Driver", IntegerType, false),
  StructField("Engine_Capacity_(CC)", IntegerType, false),
  StructField("Propulsion_Code", IntegerType, false),
  StructField("Age_of_Vehicle", IntegerType, false),
  StructField("Driver_IMD_Decile", IntegerType, false),
  StructField("Driver_Home_Area_Type", IntegerType, false),
  StructField("Vehicle_IMD_Decile", IntegerType, false)))

print(vehicle_schema.printTreeString)

// COMMAND ----------

// MAGIC %md
// MAGIC Now you can use the **spark.read.csv** function with the **schema** argument to load the data from the file based on the schema you have defined.
// MAGIC 
// MAGIC Adapt the following code to read the *Vehicles.csv* file from your storage account and verify that it's schema matches the one you defined:

// COMMAND ----------

val vehicles = spark.read.schema(vehicle_schema).option("header",true).csv("wasb://spark@ACCOUNT_NAME.blob.core.windows.net/data/Vehicles.csv")
vehicles.printSchema()

// COMMAND ----------

// MAGIC %md
// MAGIC Once again, let's take a look at the first ten rows of data:

// COMMAND ----------

vehicles.show(10)

// COMMAND ----------

// MAGIC %md
// MAGIC ## Use DataFrame Methods
// MAGIC The Dataframe class provides numerous properties and methods that you can use to work with data.
// MAGIC 
// MAGIC For example, run the code in the following cell to use the **select** method. This creates a new dataframe that contains specific columns from an existing dataframe:

// COMMAND ----------

val vehicle_driver = vehicles.select("Accident_Index", "Vehicle_Reference", "Vehicle_Type", "Age_of_Vehicle", "Sex_of_Driver" , "Age_of_Driver" , "Age_Band_of_Driver")
vehicle_driver.show()

// COMMAND ----------

// MAGIC %md
// MAGIC The **filter** method creates a new dataframe with rows that match a specified criteria removed from an existing dataframe:

// COMMAND ----------

val drivers = vehicle_driver.filter($"Age_Band_of_Driver" > -1)
drivers.show()

// COMMAND ----------

// MAGIC %md
// MAGIC You can chain multiple operations together into a single statement. For example, the following code uses the **select** method to define a subset of the **accidents** dataframe, and chains the output of that that to the **join** method, which creates a new dataframe by combining the columns from two dataframes based on a common key field:

// COMMAND ----------

val driver_accidents = accidents.select("Accident_Index", "Accident_Severity", "Speed_Limit", "Weather_Conditions").join(drivers, "Accident_Index")
driver_accidents.show()

// COMMAND ----------

// MAGIC %md
// MAGIC ## Using the Spark SQL API
// MAGIC The Spark SQL API enables you to use SQL syntax to query dataframes that have been persisted as temporary or global tables.
// MAGIC For example, run the following cell to save the driver accident data as a temporary table, and then use the **spark.sql** function to query it using a SQL expression:

// COMMAND ----------

driver_accidents.createOrReplaceTempView("tmp_accidents")

val q = spark.sql("SELECT * FROM tmp_accidents WHERE Speed_Limit > 50")
q.show()

// COMMAND ----------

// MAGIC %md
// MAGIC When using a notebook to work with your data, you can use the **%sql** *magic* to embed SQL code directly into the notebook. For example, run the following cell to use a SQL query to filter, aggregate, and group accident data from the temporary table you created:

// COMMAND ----------

// MAGIC %sql
// MAGIC SELECT Vehicle_Type, Age_Band_of_Driver, COUNT(*) AS Accidents
// MAGIC FROM tmp_accidents
// MAGIC WHERE Vehicle_Type <> -1
// MAGIC GROUP BY Vehicle_Type, Age_Band_of_Driver
// MAGIC ORDER BY Vehicle_Type, Age_Band_of_Driver

// COMMAND ----------

// MAGIC %md
// MAGIC Databricks notebooks include built-in data visualization tools that you can use to make sense of your query results. For example, perform the followng steps with the table of results returned by the query above to view the data as a bar chart:
// MAGIC  1. In the drop-down list for the chart type, select **Bar**.
// MAGIC  2. Click **Plot Options...**.
// MAGIC  3. Apply the following plot options:
// MAGIC - **Keys**: Age_Band_of_Driver
// MAGIC - **Series groupings**: Vehicle_Type
// MAGIC - **Values**: Accidents
// MAGIC - **Stacked**: Selected
// MAGIC - **Aggregation**: SUM
// MAGIC - **Display type**: Bar chart
// MAGIC 
// MAGIC View the resulting chart (you can resize it by dragging the handle at the bottom-right) and note that it clearly shows that the most accidents involve drivers in age band **6** and vehicle type **9**. The UK Department for Transport publishes a lookup table for these variables at http://data.dft.gov.uk/road-accidents-safety-data/Road-Accident-Safety-Data-Guide.xls, which indicates that these values correlate to drivers aged between *26* and *35* in *cars*. 

// COMMAND ----------

// MAGIC %md
// MAGIC Temporary tables are saved within the current session, which for interactive analytics can be a good way to explore the data and discard it automatically at the end of the session. If you want to to persist the data for future analysis, or to share with other data processing applications in different sessions, then you can save the dataframe as a global table.
// MAGIC 
// MAGIC Run the following cell to save the data as a global table and query it.

// COMMAND ----------

driver_accidents.write.mode(SaveMode.Overwrite).saveAsTable("accidents")
val q = spark.sql("SELECT * FROM accidents WHERE Speed_Limit > 50")
q.show()
