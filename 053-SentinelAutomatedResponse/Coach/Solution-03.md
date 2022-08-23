# Challenge-03 - Automated Response - Coach's Guide

[< Previous Challenge](./Solution-02.md) - **[Home](./README.md)** 


## Introduction
In this section of the Coach's guide, you fill find guidance, code, and examples that will help you guide the teams over the course of the WTH. 
In the spirit of continuous improvement, update this repository with any suggestions, altertnatives, or additional challenges.

This section of the hack includes a optional [Sentinel Review Deck](./Intro2Sentinel-C2.pptx?raw=true) that features a short presentation to introduce key topics associated with 
this challenge. 

Instructions on how to update the repository with updates can be found here. https://aka.ms/wthcontribute
</br>

## Part1

1. Install the following playbook and test the connections.  
https://github.com/Azure/Azure-Sentinel/tree/master/Playbooks/Watchlist-CloseIncidentKnownIPs </br>

Note: This repository is part of the Azure Sentinel Playbooks, this repo was available at the time of this publication but if it's not there, the coach should report it as a bug via the WTH Contribution Guide process: https://aka.ms/wthcontribute </br>

    When installing the logic app, you need to provide credentials.  For those using a Service Principle use the following: </br>
    ID's shown below are for example only. </br>

* Create a service principal by creating an “App Registration”  in my case I used Sentinel-Logic-App-ServicePrincipal.
* Copy the Application (Client) ID = b5369d2b-d9b1-4224-a2cb-82ec095119d1
* Tenant ID: 72f988bf-89f1-41af-91ab-2d7cd011db47

* Next go to Certificates and Secrets and create a client secret.  I called mine Sentinel-Logic-Apps-Client-Secret

* Copy the Value and the Secret ID
* Value(Client Secret)= IPT7Q~FA-YZpxLwwLrPiv_CRDuquaAt5w.Guq
* Secret ID = 1e42e774-e8b1-4e07-bcce-47769489755e

    You need to Assign Roles to the ServicePrincipal  – Logic App blade under Identity </br>


2.  Login (RDP) from a VM who’s IP is not in your Watchlist, verify Incident is created.

3.  Login (RDP) from a VM who’s IP is in your watchlist, verify the Incident is automatically closed.

## Part 2

Create a playbook that automatically posts a note into the security group TEAMS channel.  The guidance can be found here:  https://docs.microsoft.com/en-us/azure/sentinel/automate-responses-with-playbooks

Follow the link to the description of the logic app connector found here: https://docs.microsoft.com/en-us/connectors/teams/

Similar permission model to the first playbook.

This teaches people how to either create a monolithic playbook by combining multiple playbooks, or how to orchestrate so that a playbook is called from another playbook.




