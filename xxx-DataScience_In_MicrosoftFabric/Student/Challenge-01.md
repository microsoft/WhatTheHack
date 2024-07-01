# Challenge 01 - <Title of Challenge>

[< Previous Challenge](./Challenge-00.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

***This is a template for a single challenge. The italicized text provides hints & examples of what should or should NOT go in each section.  You should remove all italicized & sample text and replace with your content.***

## Introduction

As you observed at the end of setup in Challenge 0, you have been provided with some anonimized historical data of patients who have suffered heart attacks. The csv file contains a set of conditions (or features) that these patients have had and an indication of whether they had a heart attack or not. The first step to working with this data is to bring it to Fabric's OneLake, from where you will be able to use it for your analysis and to train a machine learning model.

## Description

Your task in this challenge is to make your data available as a delta table in the Fabric OneLake. To do so, you must:
-Create a shortcut to the heart.csv file located in ADLS Gen2. 
-Load the data to the lakehouse you will be using throughout this hack

To load the data to the lakehouse, you will be using a spark notebook. Open notebook 1 that you uploaded to your Fabric workspace in Challenge 0. You will find more guidance and helpful links there. Additionally, visit the end of this challenge for documentation links on how to create a shortcut in Fabric.

Notebook sections:
1. Read the .csv file into a dataframe in the notebook
2. Write the dataframe to the lakehouse as a delta table

By the end of this challenge, you should be able to understand and know how to use:
-Fabric Shortcuts, how do they work, why are they beneficial and what is required to use them
-Fabric Lakehouses, their role, how to create a new one and their different components
-Delta, the concept of the delta lake, the delta parquet format and how to read/write to tables using spark

## Success Criteria

The heart.csv data is now saved as a delta table on the lakehouse in the same workspace where the notebooks are stored.

## Learning Resources

[Microsoft Fabric Lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)
[ADLS Shortcuts in Fabric](https://learn.microsoft.com/en-us/fabric/onelake/onelake-shortcuts#adls-shortcuts)

Refer to Notebook 1 for more helpful links


## Tips

- You will need to access your Azure subscription to complete this challenge, but you are not expected to change any settings. Requirements, such as the hierarchical namespace, have been taken care of by the setup script.
- Navigating the storage account can be complicated. Leverage Microsoft Learn to ensure you are bringing the right information over from Azure to Fabric when you set up the shortcut. You might need to do multiple attempts if you pick the wrong fields.
- If you do need to re-set the connection to the shortcut, make sure you are selecting "new connection" on the drop-down menu. The shortcut wizard will recognize the ADLS path and default to a previous connection instead of creating a new one.
- There are multiple ways to authenticate to ADLS from the shortcut menu. Some are easier to use than others.
- Notebooks depend on Lakehouses to read and write data.
- As you move on to using notebooks, most cells depend on each other. If you are getting an error on a cell that you think shouldn't be there, navigate upstream to try to find what is wrong. Leverage Microsoft Learn and the provided documentation to make sure you are using the right functions. Check that you are using the correct variable names.
- If you stop halfway through a notebook, your progress will be saved in the code cells but the variables might be deleted from memory. If that happens, run every cell from the start in succession to get back to the starting point.

## Advanced Challenges (Optional)

Interested in seeing the shortcut's low latency in action?

Find another dataset of interest to you, save it in the same folder as heart.csv in your Azure storage account and watch the new file appear on Fabric.
