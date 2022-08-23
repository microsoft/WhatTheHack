# Challenge 01 - Architecture, Agents, Data Connectors and Workbooks - Coach's Guide

**[Home](./README.md)** - [Next Challenge>](./Solution-02.md)

## Introduction
In this Coach's guide, you fill find guidance, code, and examples that will help you guide the teams over the course of the WTH. In the spirit of continuous improvement, update this repository with any suggestions, altertnatives, or additional challenges.

This section of the hack includes a optional [Intro To Sentinel](./Intro2Sentinel.pptx?raw=true) that features short presentations to introduce key topics associated with each section of this challenge. 

Instructions on how to update the repository with updates can be found here. https://aka.ms/wthcontribute

## Challenge #1

Create a “Sentinel-Data” resource group and a log analytics workspace in your subscription
		Resource Group:		WTH-Sentinel
		LA Workspace name:	WTH-Sentinel-Workspace

Add Sentinel to the newly created workspace

Make sure everyone has a Windows server configured in the same subscription (not critical....just makes it easier).

Install the 'Windows Security Events via AMA' data connector (you can use the legacy agent, but...)
Install the agent on the Windows Server you've created.

Log onto the Windows machine with a correct ID/password - check you see 4624 (logon) events and then again with an incorrect ID/password - check you see 4625 (failed logon) events.

**Troubleshooting**</br>
Check that the server is connected to the correct workspace (can happen if using an existing server).

Kusto query to search for Events:   SecurityEvent | where EventID == 4624 or EventID == 4625

The 'Data collector health monitoring' is a built in workbook.
