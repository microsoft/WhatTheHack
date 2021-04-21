# Challenge 4: Coach's Guide

[< Previous Challenge](./03-CloudIngest.md) - **[Home](README.md)** - [Next Challenge >](./05-TransformLoad.md)

In this challenge, the team is incorporating additional data sources into their
new data lake. While the initial data was extracted from cloud based Azure SQL
databases, the data from this challenge comes from on-premises data stores.

To establish the lab environment, these “on-premises” sources are modelled
as Azure VMs; we ask the attendees to suspend disbelief!

Azure Data Factory supports extraction of on-premises sources
via the installation of a self-hosted integration runtime.

As far as source control is concerned,
Azure Data Factory supports git integration, or the team can more manually export and commit their work.
We recommend you guide the team towards GitHub, but they can use Azure Dev Ops if they like.

For the best experience with ADF's Git integration, teams should defer linking their git repository
until they have completed the creation of their pipelines.

### File downloading blocked on the Virtual Machines

Attendees may struggle to download files from within the Virtual Machines.
To address it, they need to enable file downloads on Internet Explorer.

To do so, on Internet Explorer, go to:

`Tools (Alt+X) > Internet options > Security tab > Select "Internet" zone > Custom level...`

Scroll down to `Downloads` and check `Enabled` for `File download`.

![File Download option](./images/ie-enable-filedownload.jpg)

Be aware that the popup blocker may be avoiding the download.
Help them disable it as well:

![Allow popups](./images/ie-allow-popups.jpg)

### Extracting on-premises SQL data

Install the self-hosted integration runtime to extract the data into the
data lake. Note that in true production scenarios, we would not advise
installing the runtime on the SQL Server itself, but would rather use a jump
box. To streamline the WhatTheHack experience and to save VM costs, we will
allow teams to install the runtime directly on the SQL Server VM.

You can find more about Jumpboxes on the following links:

[Windows N-tier application on Azure with SQL Server - Architecture](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/n-tier/n-tier-sql-server#architecture)
[Implement a DMZ between Azure and your on-premises datacenter](https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/dmz/secure-vnet-hybrid)
[Jump boxes vs. firewalls](https://www.techrepublic.com/blog/data-center/jump-boxes-vs-firewalls/)