# Automating Incremental Pipelines <br> (Azure SQL -> Synapse Dedicated Pool) <br> Coach's Guide 
## Introduction
Welcome to the coach's guide for the IoT Hack of the Century What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

Also remember that this hack includes a optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

## Coach's Guides
- Challenge 0: **[Setup the source and target environments](Solution-00.md)**
   - Standup and configure the Azure SQL and Synapse Environments
- Challenge 1: **[Initial Data Load into the Dedicated Pool](Solution-01.md)**
   - Use Synapse Pipelines to perform the initial data load
- Challenge 2: **[Create Incremental Load Pipelines](Solution-02.md)**
   - Implement Change Data Capture, create the synapse pipelines and the proper Dedicated Pool architecture to be used as a target for the pipelines and a source for reporting.
- Challenge 3: **[Setup the trigger to automate the incremental load](Solution-03.md)**
   - Create the trigger within Synapse to automate the pipeline and add data to SQL and watch it flow through the staging and production tables in the dedicated pool and viewable in your Power BI Report.
