# Challenge 03 - Swab the Decks! - Coach's Guide

[< Previous Solution](./Solution-02.md) - **[Home](./README.md)** - [Next Solution >](./Solution-04.md)

## Notes & Guidance

Challenge Three is about cleaning and loading the data to delta tables. The students should be encouraged to explore both notebooks and dataflows (for example, processing BOM forecast XML is easy in a dataflow, but the WAM-002 data is better suited to a notebook).

Overall, the method used by the students are very much a design choice by each.

## Solutions

Solutions are contained in the [Solutions](./Solutions) folder,

__Dataflow2__
Load BOM Forecasts.pqt - dataflow template
Dataflow Load IDW11160 M Code.txt - M code for the above dataflow

__Notebooks__
``Download BOM Forecasts To OneLake.ipynb`` - downloads BOM forecasts to OneLake
``Load Shipwrecks.ipynb`` - loads WAM-002 data merging with the BOM Marine Zones data
``Loading Planetary Computer Climate Prediction Models.ipynb`` - bonus level - loads ECMWF climate models from the Planetary Computer

__Misc__
``Cleanup.ipynb`` - cleans up OneLake tables and files
``troubleshooting/Cancel-Dataflow.ps1`` - a Posh script to cancel a dataflow (or at least mark the metadata as cancelled)
