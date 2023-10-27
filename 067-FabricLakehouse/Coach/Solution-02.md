# Challenge 02 - Land Ho! - Coach's Guide

[< Previous Solution](./Solution-01.md) - **[Home](./README.md)** - [Next Solution >](./Solution-03.md)

## Notes & Guidance

This challenge implements the design developed in Challenge 1, landing data in a "raw" format and cleaning to bronze, ready to further transform in [the next Challenge](./Solution-03.md).

## Outcome
At the end of this challenge, students should have landed their data in OneLake and cleaned it to bronze. The data should be available in the Lakehouse as geojson files for shipwrecks and marine zones, and as XML files for forecasts.

## Solution

Students may wish:

- to download the data manually and upload to OneLake
- to use a notebook, a dataflow or a combination of both to retrieve and land the data,
- to use the provided raw data files

any of these are acceptable.

Once the raw data has been landed, students will need to clean the data to bronze. The example solution uses a notebook to perform this step for shipwrecks and marine zones as this is the most applicable tool for processing spatial data. Since parquet does not support ``geometry`` types, shipwrecks and marine zones are stored as geojson in bronze.

Forecasts are left unprocessed for now as the XML format is best handled by a dataflow which can process directly to silver.

### The Example Notebook - Shipwrecks and Marine Zones Data Engineering

Challenge 2 and 3 solutions for shipwrecks and marine zones are contained in the notebook [Solution - Data Engineering.ipynb](./Solutions/Solution%20-%20Data%20Engineering.ipynb).

Coaches should upload this notebook to their workspace following [How to use Microsoft Fabric notebooks](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook#import-existing-notebooks).

The notebook contains notes on the steps required for this challenge (and challenge 3). Coaches should step through each code cell to become familiar with the overall code, and be able to use snippets of code from this notebook to help students.

### Dataflow - Forecasts Data Engineering

Some students may wish to process forecasts data to bronze with a dataflow, and then to silver with a second. Whilst not strictly necessary it is perfectly acceptable to do so. The example solution processes forecasts directly to silver in Challenge 3.

### Advanced Students

More advanced students might like to include climate (temperature and wave) models from  [ECMWF Open Data](https://planetarycomputer.microsoft.com/dataset/ecmwf-forecast) available via the Microsoft Planetary Computer. An example notebook is included in the [Solutions](./Solutions) folder.
