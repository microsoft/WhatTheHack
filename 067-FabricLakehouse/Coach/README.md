# What The Hack - Fabric Lakehouse - Coach Guide

## Introduction

Welcome to the coach's guide for the Fabric Lakehouse What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes an awesome [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

You may also want to customise the deck to include logistics, timings, you and other coaches details, and other information specific to your event. Additional sea-themed puns are also encouraged. Yarrr...

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Grab your fins and a full tank!](Solution-00.md)**
  - Provision your Fabric Lakehouse
- Challenge 01: **[Finding Data](Solution-01.md)**
  - Head out into open waters to find your data
- Challenge 02: **[Land ho!](Solution-02.md)**
  - Land your data in your Fabric Lakehouse
- Challenge 03: **[Swab the Decks!](Solution-03.md)**
  - Clean and combine your datasets ready for analysis
- Challenge 04: **[Make a Splash](Solution-04.md)**
  - Build a data story to bring your findings to life
- Challenge 05: **[Giant Stride](Solution-05.md)**
  - Take a giant stride and share your data story with the world

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event.

### About the Audience

Students will most likely have a wide range of backgrounds and experience ranging from Data Engineers comfortable with Pyspark, T-SQL and datalake technology, to business analysts with little or no coding experience. The hack is intended to be accessible to all, but coaches should be aware of the following:

- The hack is designed to be completed by teams of 2-4 students working together. Coaches should consider how to arrange students into teams to ensure a mix of skills and experience. However, for an event with more experienced (or daring) students the hack can be completed individually.
- The hack is designed to be completed in a linear fashion. Encourage students to work outside of their areas of expertise, but be aware that some challenges may be more difficult for some students than others. Use your discretion - students may commence challenges in parallel. For example, a Power BI reporting expert may wish to start Challenge 4 while the other team members are data wrangling in Challenge 2/3.

### Duration & Agenda

Ideally this hack can be completed in a day, but it is highly dependant on student profiles. For a more relaxed pace for a less experienced group, consider running the hack over 2 days - one day for challenges 1-3 and the second day for challenges 3-5.

Times are very fluid and almost certainly will vary, but a *very* indicative agenda for a 1 day hack is as follows:

|Time|Duration|Activity|
|----|--------|--------|
|9:30 AM|15 mins|Welcome!|
|9:45 AM|30 mins|An Overview of Microsoft Fabric|
|10:15 AM|15 mins|About The Hack & Challenge 0 - Get Your Gear Ready|
|10:30 AM|15 mins|Break|
|10:45 AM|45 mins|Challenge 1 - Finding Data|
|11:30 AM|60 mins|Challenge 2  - Land Ho!|
|12:00 PM|60 mins|Lunch|
|1:00 PM|30 min|Challenge 2 cont.|
|1:30 PM|60 mins|Challenge 3  - Swab the Decks!|
|2:30 PM|15 mins|Break|
|2:45 PM|60 mins|Challenge 4  - Make A Splash!|
|3:45 PM|30 mins|Challenge 5  - Giant Stride|
|4:15 PM|15 mins|Wrap Up|

### Additional Coach Prerequisites

This hack as been left very open ended - [TMTOWTDI](https://perl.fandom.com/wiki/TIMTOWTDI). Coaches should be familiar with the following technologies and concepts:

- Microsoft Fabric (duh!)
- Python / PySpark
- Dataflow Gen 2 / M / Power Query
- Power BI / DAX

Coaches should deploy the solution files before the event to ensure they are familiar with the approach and the technologies used. Coaches should also be familiar with the datasets and source government agency websites used in the example solutions. Links are provided in the various [Solutions](./Solutions).

### Coach Resources

- [What is Microsoft Fabric?](https://aka.ms/learnfabric)
- [Microsoft Fabric Blog](https://aka.ms/FabricBlog)
- [Import Existing Notebooks](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook#import-existing-notebooks)
- [Importing a datafow gen2 template](https://learn.microsoft.com/en-us/fabric/data-factory/move-dataflow-gen1-to-dataflow-gen2)

- [Fabric (trial) Known Issues](https://learn.microsoft.com/en-gb/fabric/get-started/fabric-known-issues)

### Student Resources

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

There are no specific student resources for this hack, but you of course may share parts of the solutions, hints, doco links etc with students who may be struggling as you see fit.

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure / Fabric Requirements

This hack requires students to have access to a Microsoft Fabric tenant account with an active subscription. These tenant requirements should be shared with stakeholders in the organization that will be providing the Fabric environment that will be used by the students.

There are no specific Azure resources required for this hack, beyond a Fabric capacity (see below).

### Enabling Microsoft Fabric

Fabric needs to be enabled in the tenant (see [Enable Microsoft Fabric for your organization](https://learn.microsoft.com/en-us/fabric/admin/fabric-switch)) and students need to be granted permission to create Fabric resources. Depending on the host org config and policy, students could be added to an security group that has permission to create Fabric resources:

![](https://learn.microsoft.com/en-us/fabric/admin/media/fabric-switch/fabric-switch-enabled.png)

### Microsoft Fabric Licenses

At the time of writing, Fabric is in preview and a trial license is available. See [Start a Fabric (Preview) trial](https://learn.microsoft.com/en-us/fabric/get-started/fabric-trial). Post-trial, a paid Fabric capacity will be required, although a small F2-F4 capacity should be sufficient for this hack.

Overall, students must have a premium capacity backed workspace, through one of the following methods.
1. FT - [Fabric trial](https://learn.microsoft.com/fabric/get-started/fabric-trial)    
2. F - [Fabric capacity](https://learn.microsoft.com/fabric/enterprise/buy-subscription#buy-an-azure-sku)
3. P - [Power BI Premium](https://learn.microsoft.com/power-bi/enterprise/service-admin-premium-purchase)

See [Microsoft Fabric Licenses](https://learn.microsoft.com/en-us/fabric/enterprise/licenses) for details.

### Microsoft Fabric Workspace

Students will require a Microsoft Fabric enabled Workspace where they can create Fabric artefacts (Lakehouse, Dataflow, Pipeline, Notebook, Report etc). If the group is arranged into pods, it is recommended to provision one workspace per pod. If the group is working individually, it is recommended to provision one workspace per student. It is recommended that students are granted Admin role on this workspace to allow them to create and manage all artefacts.

*Note:* for pods collaborating in a per-pod Workspace, students will also require a Power BI Pro license if they intend to publish reports to this workspace.

See [Microsoft Fabric Workspaces](https://learn.microsoft.com/en-us/fabric/get-started/workspaces) and [Create a workspace](https://learn.microsoft.com/en-us/fabric/get-started/create-workspace) for details.


### Power BI Desktop

Students will require Power BI desktop to be installed on their PC. Either the store or download version is fine.
1. [Microsoft Store](https://aka.ms/pbidesktop) See also [Learn more about the benefits of installing from the Microsoft Store including automatic updates](https://docs.microsoft.com/power-bi/fundamentals/desktop-get-the-desktop#install-as-an-app-from-the-microsoft-store).
  or
2. [Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=58494) Ensure you have the latest version of downloaded.

### Trial tenant

https://go.microsoft.com/fwlink/p/?LinkID=698279 [Microsoft 365 developer subscription in Visual Studio subscriptions](https://docs.microsoft.com/visualstudio/subscriptions/vs-m365)

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)

## Other Fabric What The Hacks

These WTHs are currently in development and will be released soon:
- Fabric Datamesh - A more architecturally focused hack covering Data Mesh, Medalion Architecture, and Fabric
- Fabric Realtime - A hack focused on realtime data processing with Fabric
