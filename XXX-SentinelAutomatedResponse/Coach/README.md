
<!-- REPLACE_ME (this section will be removed by the automation script) -->
# What The Hack - Sentinel Automated Response - Coach Guide
<!-- REPLACE_ME (this section will be removed by the automation script) -->

## Introduction

<!-- REPLACE_ME (this section will be removed by the automation script) -->
Welcome to the coach's guide for the Sentinel Automated Response What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.
<!-- REPLACE_ME (this section will be removed by the automation script) -->

This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

<!-- REPLACE_ME (this section will be removed by the automation script) -->
- Challenge 1: **[Architecture, Agents, Data Connectors and Workbooks](Solution-01.md)**
   - Understand the various architecture and decide on the appropriate design based on the requirements. Install the appropriate data connector to import Windows security events and validate Log Analytics data ingestion.
- Challenge 2: **[Custom Queries & Watchlists](Solution-02.md)**
   -  Build a custom analytics rule to show data ingested through the connector. Create a Watchlist and add data, verify the data is available in Log Analytics.  Change the table retention time to 7 days
- Challenge 3: **[Automated Response](Solution-03.md)**
   -  Bulid a custom rule that alerts when your user ID logs into a server. Use a playbook to automatically close the incident only if login occurred from a known IP address
<!-- REPLACE_ME (this section will be removed by the automation script) -->


## Prerequisites

- Access to the Internet - Azure Docs
- Access to the Azure Portal 
- A Windows servers running in the subscription where you will run Sentinel

</br>

## Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the \`/Student/Resources\` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

### Additional Coach Prerequisites (Optional)

*Please list any additional pre-event setup steps a coach would be required to set up such as, creating or hosting a shared dataset, or deploying a lab environment.*

## Azure Requirements

- An Azure subscription with Owner access
- Two virtual machines running in the subscription
- Kusto code knowledge/reference material available
- Patience

## Suggested Hack Agenda (Optional)

*This section is optional. You may wish to provide an estimate of how long each challenge should take for an average squad of students to complete and/or a proposal of how many challenges a coach should structure each session for a multi-session hack event.  For example:*


	- Challenge 1 (2 hours)
	- Challenge 2 (2 hours)
	- Challenge 3 (2 hours)


## Repository Contents


- `./Coach`
  - Coach's Guide and related files
  - Powerpoint files
- `./Coach`
  - Student's Challenge Guide
- `./Student`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)