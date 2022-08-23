# What The Hack - Sentinel Automated Response - Coach Guide

## Introduction

Welcome to the coach's guide for the Sentinel Automated Response What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack includes optional lecture presentations that introduces key topics associated with each challenge:
- [Intro2Sentinel.pptx](../Intro2Sentinel.pptx?raw=true)
- [Intro2Sentinel-C2.pptx](../Intro2Sentinel.pptx?raw=true)

It is recommended that the host present each short presentation before attendees kick off that challenge.</br>

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 01: **[Architecture, Agents, Data Connectors and Workbooks](Solution-01.md)**
   - Understand the various architecture and decide on the appropriate design based on the requirements. Install the appropriate data connector to import Windows security events and validate Log Analytics data ingestion.
- Challenge 02: **[Custom Queries & Watchlists](Solution-02.md)**
   -  Build a custom analytics rule to show data ingested through the connector. Create a Watchlist and add data, verify the data is available in Log Analytics.  Change the table retention time to 7 days
- Challenge 03: **[Automated Response](Solution-03.md)**
   -  Bulid a custom rule that alerts when your user ID logs into a server. Use a playbook to automatically close the incident only if login occurred from a known IP address


## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the What The Hack Hosting Guide for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

### Additional Coach Prerequisites (Optional)

If the coach will do a demonstration then the following are required, if not, then these prerequisites can be ignored.
- Access to the Internet - Azure Docs
- Azure subscription with contributor role
- Prebuild a generic Windows server running in the subscription.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- One virtual machines running in the subscription
- Kusto code knowledge/reference material available
- Patience

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
  - Powerpoint files
- `./Student`
  - Student's Challenge Guide

