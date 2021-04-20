# Challenge 3 – Create a Unit Test Locally and in Azure DevOps

[< Previous Challenge](./02-BuildPipeline.md) - **[Home](./README.md)** - [Next Challenge >](./04-ReleasePipeline.md)

## Solution

1.  Make sure you have created a new project in Azure DevOps, created new service connections and have Azure ML workspace configured for the project using config.json file.

2.  Write a Python snippet to validate that AdventureWorks data is indeed downloaded and extracted into `Data/` folder. Do a preview of file count in the data folder. Additionally, you could also pick a csv file visualize the data.
    - **HINT:** For Azure DevOps, it is encouraged to leverage the Python Script task using the pipeline task manager in Azure DevOps


