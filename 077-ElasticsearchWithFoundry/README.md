# What The Hack - Context Quest: Optimizing AI Agents with Microsoft Foundry and Elastic Context Engine

## Introduction

Your fictional company, Precision Labs, keeps CRM accounts, support tickets, and knowledge base (KB) articles in Elasticsearch. Precision's Support Copilot is built and hosted in Microsoft Foundry.

We're going to learn how to connect a Foundry agent to an Elasticsearch datastore using the Model Context Protocol (MCP). And then we're going to learn how you can use Elastic Context Engine to optimize your agent's performance and token usage.

Meet **Agent Mole**, measure its discovery work, and help **Agent Optimus** use Knowledge Indicators (KIs) from a single AI Index to navigate multiple sources. Then introduce a harmless instruction hidden in a retrieved document: can your agent use the facts without following the document's commands? Use Microsoft Foundry evaluation to investigate. Your goal is a grounded, explainable support answer, not just a smaller token count.

## Learning Objectives

- Connect a Microsoft Foundry agent to Elasticsearch through Elastic MCP with scoped, read-only access.
- Explain how native Context Engine automations turn source data into reusable KIs in an AI Index.
- Use one AI Index to describe multiple source indices while preserving access to current source records.
- Compare discovery calls, service-reported tokens, answer correctness, and latency without assuming guaranteed savings.
- Evaluate an agent response to an indirect prompt injection and distinguish evaluation from runtime filtering.

## Challenges

- Challenge 00: **[Ready, Set, Connect](Student/Challenge-00.md)**
  - Prepare your own environments and launch the supplied notebook workspace.
- Challenge 01: **[Connect Foundry Agent to Elastic](Student/Challenge-01.md)**
  - Build a Foundry agent with Elastic MCP and collect a discovery baseline.
- Challenge 02: **[Build the Context Engine](Student/Challenge-02.md)**
  - Create an AI Index and Knowledge Indicators, and retrieve the Context Engine MCP endpoint.
- Challenge 03: **[Rise of Agent Optimus](Student/Challenge-03.md)**
  - Build a Foundry agent on the Context Engine and compare it with Agent Mole.

## Prerequisites

- Access to an Azure subscription with Owner access
	- If you don’t have one, Sign Up for Azure [HERE](https://azure.microsoft.com/en-us/free/)
- A GitHub account with access to [GitHub Codespaces](https://github.com/features/codespaces) as a developer workspace in the cloud
- Access to an Elastic Cloud Serverless project with native Context Engine, workflow, and inference access.
  - If you don't have one, Sign up for a free Elastic trial [HERE](https://elastic.co)

## Contributors

- [Peter Laudati](https://github.com/jrzyshr) 
- [Jeff Vestal](https://github.com/jeffvestal)
- GitHub Copilot (drafting assistance)
