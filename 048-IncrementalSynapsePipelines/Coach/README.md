# What The Hack - Incremental Synapse Pipelines <br> <i>Utilizing Change Data Capture in Azure SQL</i> <br> Coach's Guide 

## Introduction
Welcome to the coach's guide for the Automating Incremental Pipelines What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

Also remember that this hack includes a optional [lecture presentation](Automating-Incremental-Pipelines.pptx?raw=true) that features key topics for this What the Hack. 

## Solutions
- Challenge 0: **[Setup the Source and Target Environments](Solution-00.md)**
   - Standup and configure the Azure SQL and Synapse Environments
- Challenge 1: **[Initial Data Load into the Dedicated Pool](Solution-01.md)**
   - Use Synapse Pipelines to perform the initial data load
- Challenge 2: **[Create Incremental Load Pipelines](Solution-02.md)**
   - Implement Change Data Capture, create the synapse pipelines and the proper Dedicated Pool architecture to be used as a target for the pipelines and a source for reporting.
- Challenge 3: **[Setup the Trigger to Automate the Incremental Load](Solution-03.md)**
   - Create the trigger within Synapse to automate the pipeline and add data to SQL and watch it flow through the staging and production tables in the dedicated pool and viewable in your Power BI Report.

## Session Guidance
This What the Hack was created during the pandemic and was designed and executed for a remote/virtual audience.

We initially conducted this hackathon in three - 3 hour sessions for a total of 9 hours.  It was done over a three week period with each session being conducted on a Friday.

Moving forward, I would highly recommend that you dedicate at least 12 hours overall to this hackathon.  This excludes breaks.  Thus, you may want to break this into 3 sessions that are a total of 5-6 hours long, including breaks. 

Also, the feedback that we received from attendees is that they prefer that these sessions were held on consecutive days.  Since we did it every Friday, attendees felt that they spent too much time refreshing their memory on what was accomplished the week(s) before.

Challenge 2 will take the longest.  It will probably equal the length of challenge 0 and 1 put together.  Thus, please plan accordingly.

Finally, we also had the attendees fill out a survey during registration to guage their expertise and we made sure that each team was balanced with experts and beginners using the following questions:
- Experience Level with Azure SQL  (100=Newbie -> 400=SME)
- Experience Level with SQL Dedicated Pools / SQL DW
- Experience Level with ADF/Synapse Pipelines

Answers were single select options of 100/200/300/400
