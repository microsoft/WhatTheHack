# Challenge 02 - Data preparation with Data Wrangler

[< Previous Challenge](./Challenge-01.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-03.md)

## Introduction

Welcome to Challenge 2! In this exercise, you will learn how to use Data Wrangler to prepare a heart dataset for model training. In the previous challenge, you mapped the data within One Lake. You will now focus on transforming and preparing your data for the next challenges. You have the flexibility to either write code in a notebook or leverage Data Wrangler’s intuitive interface to streamline the pre-processing tasks.

## Description

The main tasks in this challenge consist in different pre-processing steps that are important for developing robust, efficient and reliable machine learning models. You must ensure that you accomplish the following tasks during this challenge:
1. Removing unnecessary columns from a dataset. It is the best practice that enhances model performance, improves interpretability & reduces complexity.
2. Dropping rows with missing values ensure compatibility with a wide range of algorithms without needing additional imputation strategies.
3. Handling duplicate rows is an essential step in data preparation because it ensures data quality.
4. Adjusting data types. Machine learning algorithms operate on numerical data (integers, floats, etc.). If you feed them non-numeric data (e.g., strings), they won’t work. 

This is a notebook-based challenge. You will find all instructions as well as more guidance and helpful links in Notebook 2. Additionally, visit the end of this challenge for documentation links on how to get started with Data Wrangler in Microsoft Fabric. 

For most of these tasks you can use *Data Wrangler* to accelerate the data preparation process.  *Data Wrangler* is a tool used in notebooks. It offers an easy-to-use interface for exploring data. This tool shows data in a grid format, offers automatic summary statistics, built-in visualizations, and a library of common data-cleaning operations. Each operation can be done in just a few clicks. It shows the changes to the data right away and creates code in `pandas` or `PySpark` that can be saved back to the notebook for future use.

Another important step before the training model is the feature engineering. In the feature engineering process, especially when dealing with categorical data, encoding is a crucial step. One of the simplest methods for converting categorical values into numerical values is using the `LabelEncoder`.  In this challenge you will need to figure out how to handle categorical values in the dataset. 

Notebook sections:
1. Read the .csv file into a pandas dataframe in the notebook.
2. Launch the Data Wrangler and interact with the data cleaning operations
3. Apply the operations using python codes
4. Develop feature engineering using spark.
5. Write the dataframe to the lakehouse as a delta table. 

By the end of this challenge, you should be able to understand and know how to use:
- Fabric Data Wrangler, how it works and how it can help you in your data preparation process.
- Fabric Notebooks, their role, how to create a new one and execute spark applications.

## Success Criteria

Verify that the heart dataset is correctly shaped, cleaned and prepared for the model training by confirming the following:
- There are no duplicates row in the dataset.
- There are no missing values. 
- There are no categorical values. Categorical values must be transformed to numerical values.
- The processed data is saved to the Fabric Lakehouse as a Delta table. Verify that you can load the table back to the notebook.

## Learning Resources

[Data Science in Microsoft Fabric](https://learn.microsoft.com/en-us/fabric/data-science/data-science-overview)

[Accelerate Data prep with Data Wrangler](https://learn.microsoft.com/en-us/fabric/data-science/data-wrangler)

[Pre-process data with Data Wrangler in Microsoft Fabric](https://learn.microsoft.com/en-us/training/modules/preprocess-data-with-data-wrangler-microsoft-fabric/)

## Tips

- You will need to access your Microsoft Fabric subscription or sign up for a free trial.
- Sign in to Microsoft Fabric and switch to the Synapse Data Science experience.
- You can launch Data Wrangler directly from a Fabric notebook to explore and transform pandas or Spark DataFrames.
- Use the Data Wrangler dropdown prompt under the notebook ribbon’s “Data” tab to browse active DataFrames available for editing.
- Note that Data Wrangler cannot be opened while the notebook kernel is busy; an executing cell must finish its execution first.
- When Data Wrangler loads, it displays a descriptive overview of the chosen DataFrame in the Summary panel. This overview includes information about the DataFrame’s dimensions, missing values, and more.
- Use Data Wrangler’s grid-like interface to apply various data-cleaning operations. The generated code can be saved back to the notebook as a reusable function.


