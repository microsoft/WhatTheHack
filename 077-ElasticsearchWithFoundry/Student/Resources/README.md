# What The Hack - Context Quest: Optimizing AI Agents with Microsoft Foundry and Elastic Context Engine - Student Resources
This folder/repo contains all the student resources needed for the Context Quest What The Hack.

Students should follow the instructions in the student guide for this hack here:
- [WTH Context Quest Student Guide](https://microsoft.github.io/WhatTheHack/077-ElasticsearchWithFoundry/)

The contents of this folder/repo are listed below:

## `/.devcontainer`
This folder contains the configuration for these resources to be hosted in GitHub Codespaces or a DevContainer on your local workstation.

## `/data`
This folder contains the fictional CRM accounts, support tickets, and knowledge base articles used to complete the challenges of this hack, along with a script to load the data into Elasticsearch and sample agent queries.

## `/infra`

This folder contains the deployment script and Azure Bicep template for provisioning Microsoft Foundry resources in Azure.

## `/notebooks`
This folder contains a Jupyter Notebook for evaluating agent responses. You must have a Jupyter Notebook runtime environment to run this file.

## `/workflows`
This folder contains Elastic workflow definitions for creating Knowledge Indicators (KIs) in the Context Engine AI Index.

See [Challenge 02](https://microsoft.github.io/WhatTheHack/077-ElasticsearchWithFoundry/Student/Challenge-02.html) of the student guide for instructions on using these workflows.

## `.env.sample`

This is a sample `.env` file with the environment variables used to connect to your Elastic project. Copy this file to `.env` and add your configuration values to it during the hack. Keep `.env` private and never commit it to Git.

See [Challenge 00](https://microsoft.github.io/WhatTheHack/077-ElasticsearchWithFoundry/Student/Challenge-00.html) of the student guide for environment setup instructions.

## `.gitignore`

This file has a list of files that Git should ignore and not commit to a Git repo if a student chooses to commit these files to a repo from their local workstation.

## `requirements.txt`

This file is used for configuring Python libraries on your workstation.
