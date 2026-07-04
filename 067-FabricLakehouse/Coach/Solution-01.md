# Challenge 01 - Finding Nemo - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

This first challenge is all about finding the data but not importing it (yet). The output is a list of datasets that meet the requirements, a strategy for ingesting / processing and a selection of the "best" tool - notebook, dataflow etc. Actual development starts in challenge 2.

For this challenge, the students will be searching for suitable data sources online. You should ensure that they are aware of the following:

- Licensing
- Copyright

This object of this challenge is to get the students to think about:

- the data they need to meet the requirements
- what sources are available
- how it is licensed
- how they can land this data automatically in OneLake

Whilst there is no formal output of this challenge, you should ensure that the students have made a note of the datasets they have found, and how they plan to ingest them as this will be useful in the next challenge.

## Solution

### (Strongly) Recommended Datasets

The example solutions have been built using Australian Bureau of Meteorology and Western Australian Museum datasets. These are the (strongly) recommended sources for the hack. However, students are free to use any datasets they like, as long as they meet the requirements to spatially locate a wreck and weather conditions at that point. Substitute datasets need to be licensed appropriately, and if students do decided to attempt creating a custom solution, you should ensure they are aware of the time constraints and the need to move on to the next challenge. You may also need to provide deeper technical guidance if they are not familiar with the tools but hey, if they want to try, let them! They can always revert to the provided solutions if they get stuck.

These two BOM datasets comprise forecasts for marine zones (with a textual zone key) and geo-coded marine zones (to allow spatially locating shipwrecks to a zone).

- BOM FTP data services: http://www.bom.gov.au/catalogue/data-feeds.shtml and http://www.bom.gov.au/catalogue/anon-ftp.shtml 

  - ``IDW11160`` - Coastal Waters Forecast - All Districts (WA)
  - ``IDM000003`` - Marine Zones - http://reg.bom.gov.au/catalogue/spatialdata.pdf


This dataset contains wreck details (date, name, description etc) in GeoJSON format, allowing joining to ``IDM000003`` and by extension, ``IDW11160``.

- WA Museum
  - ``WAM-002`` https://catalogue.data.wa.gov.au/dataset/shipwrecks (requires a free SLIP account and is CC BY 4.0)

### More Advanced Datasets

More advanced students might like to include climate (temperature and wave) models from  [ECMWF Open Data](https://planetarycomputer.microsoft.com/dataset/ecmwf-forecast) available via the Microsoft Planetary Computer. See https://planetarycomputer.microsoft.com/docs/quickstarts/reading-stac/

### Common Issues / Pitfalls

- Students may struggle to find suitable datasets. Guide those who are a bit lost at sea with some hints such as 
  - _"Who would be interested in documenting the history of shipwrecks?"_
    - A: Museums!
  - _"And are there any in Western Australia?"_ 
    - A: WA Museum (and Shipwreck Galleries in particular)
  - _"Is there an open data portal for all Australian government data (Federal and State)?"_
    - A: [data.gov.au](https://data.gov.au/)
  - "Is there a government agency that might have data on weather conditions?"
    - A: [Bureau of Meteorology](http://www.bom.gov.au/)
