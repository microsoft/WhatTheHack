# Challenge 6: Add New Data Source(s)

[< Previous Challenge](./05-data-masking.md) - **[Home](../README.md)** - [Next Challenge >](./07-ml.md)

## Introduction
Pump up participation! 

## Description
The CPF wants to do more sophisticated analysis of sport participation and growth around the world. They have asked you to add population data by country and year. They want to be able to use this data to analyze participation rates. Participation rate is defined as number of lifters by country compared to the population of the country. Of course, this analysis is time sensitive since both number of lifters and population change every year. So, you need to be able to analyze participation rate by country and year.


## Success Criteria
- Located suitable data and implement this analysis
- Added a new data ingestion flow to put yearly population data by country into the data store
- Cleansed or transformed the data so "country" in the population data and in the powerlifting data can be correlated (i.e. joined)
- Created a query, view, or dataset that calculates participation rate by country, by year
- Added the resulting data to your visualizations from Challenge 3
- Identified another country level metric (e.g., GDP, health score, BMI, diet, education) that can be compared to lifter participation to gain insights on growth of the sport.