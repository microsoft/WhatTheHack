# Challenge 01 - Finding Nemo - Coach's Guide 

[< Previous Solution](./Solution-00.md) - **[Home](./README.md)** - [Next Solution >](./Solution-02.md)

## Notes & Guidance

This first challenge is all about finding the data but not importing it (yet). The output is a list of datasets that meet the requirements, a strategy for ingesting / processing and a selection of the "best" tool - notebook, dataflow etc. Actual development starts in challenge 2.

For this challenge, the students will be searching for suitable datasources online. You should ensure that they are aware of the following:

- Licensing
- Copyright

This object of this challenge is to get the students to think about 

- the data they need to meet the requirements,
- what sources are available
- how it is licensed
- how they can land this data automatically in OneLake

### Solution

The example solutions have been built using Australian Bureau of Meteorology and Western Australian Museum datasets:

- BOM FTP data services: http://www.bom.gov.au/catalogue/data-feeds.shtml and http://www.bom.gov.au/catalogue/anon-ftp.shtml 

  - ``IDW11160`` - Coastal Waters Forecast - All Districts (WA)
  - ``IDM000003`` - Marine Zones - http://reg.bom.gov.au/catalogue/spatialdata.pdf

- WA Museum
  - ``WAM-002`` https://catalogue.data.wa.gov.au/dataset/shipwrecks (requires a free SLIP account and is CC BY 4.0)

More advanced students might like to include climate (temperature and wave) models from  [ECMWF Open Data](https://planetarycomputer.microsoft.com/dataset/ecmwf-forecast) available via the Microsoft Planetary Computer. An example notebook is included in the [Solutions](./Solutions) folder.
