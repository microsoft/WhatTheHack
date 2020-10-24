# Challenge 2: Load patient data into FHIR Server

[< Previous Challenge](./Challenge01.md) - **[Home](../readme.md)** - [Next Challenge>](./Challenge03.md)

## Introduction

**Goal**
Build a patient search react application with a serverless backend in 24 hours.

## Description

- Deploy CosmosDB instance supporting SQL interface through the portal.
- Deploy a serverless function in Azure Functions that reads from FHIR server and writes to the SQL interface of Azure CosmosDB (unit testing).
    - Look for these files for sample code on how to read from FHIR Server
        - dataread.js
        - config.json
    - Trigger your function manually for now

## Success Criteria
- Produce dummy patient records in FHIR format and persist in FHIR Server.

## Learning Resources

*List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge.*
