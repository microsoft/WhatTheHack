# Challenge 02 - Land Ho! - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

This challenge implements the design developed in Challenge 1, landing data in a "raw" format and cleaning to bronze, ready to further transform in [the next Challenge](./Solution-03.md).

## Outcome
At the end of this challenge, students should have landed their data in OneLake and cleaned it to bronze. The data should be available in the Lakehouse as GeoJSON files for shipwrecks and marine zones, and as an XML file for forecasts.

## Solution

Students may wish:

- to download the data manually and upload to OneLake
- to use a notebook, a dataflow or a combination of both to retrieve and land the data
- to use the provided raw data files

Any of these are acceptable.

Once the raw data has been landed, students will need to clean the data to bronze. The example solution uses a notebook to perform this step for shipwrecks and marine zones as this is the most applicable tool for processing spatial data. Since parquet does not support ``geometry`` types, shipwrecks and marine zones are stored as GeoJSON in bronze.

> **A Note on Forecasts**
>Some students may wish to transform forecasts data from XML to json, csv, etc. and write to bronze files with a dataflow. They may then want to process this file to silver using Spark as part of Challenge 3. Whilst not strictly necessary it is perfectly acceptable to do so. However, the example dataflow solution in [Challenge 3](./Solution-03.md) processes forecasts directly to silver skipping this intermediate step.

#### Example Notebook - Data Exploration

An important part of data engineering is understanding the data. Students should be encouraged to explore the data and a sample notebook is provided in the [Solutions](./Solutions) folder ``Data Exploration.ipynb``.

Coaches can use this notebook to demonstrate how to explore the data, as prompts to help guide students, and to help students with the steps required to initially clean the data to bronze.

#### Example Notebook - Shipwrecks and Marine Zones Data Engineering

Challenge 2 and 3 solutions for shipwrecks and marine zones are contained in the notebook [Solution - Data Engineering.ipynb](./Solutions/Solution%20-%20Data%20Engineering.ipynb).


The notebook contains notes on the steps required for this challenge (and challenge 3). Coaches should step through each code cell to become familiar with the overall code, and be able to use snippets of code from this notebook to help students.

#### Uploading the Notebooks

Coaches should upload notebooks to their workspace following [How to use Microsoft Fabric notebooks](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook#import-existing-notebooks).

#### Advanced Students

More (very..) advanced students might like to include climate (temperature and wave) models from [ECMWF Open Data](https://planetarycomputer.microsoft.com/dataset/ecmwf-forecast) available via the Microsoft Planetary Computer. Coaches 

An example notebook is included in the [Solutions](./Solutions) folder ``Loading Planetary Computer Climate Prediction Models.ipynb``.
