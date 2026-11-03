# What The Hack - Context Quest: Optimizing AI Agents with Microsoft Foundry and Elastic Context Engine

## Introduction

Precision Labs sells a business-to-business operations intelligence platform that customers use for analytics dashboards, workflow automation, and data reporting. Precision Labs keeps CRM accounts, support tickets, and knowledge base (KB) articles in Elasticsearch. Precision's Support Copilot is built and hosted in Microsoft Foundry.

We're going to learn how to connect a Foundry agent to an Elasticsearch datastore using the Model Context Protocol (MCP). And then we're going to learn how you can use Elastic Context Engine to optimize your agent's performance and token usage.

You will build two agents to answer support questions using Precision Labs' data. First, connect **Agent Mole** directly to Elasticsearch and measure the work it does to discover and query the available data. Then, use Elastic's Context Engine to build an AI Index with Knowledge Indicators (KIs). **Agent Optimus** will use that AI Index and its KIs to help it navigate the same sources. Run the same questions through both agents and compare their discovery calls, token usage, answer correctness, and latency to see how added context changes their behavior.

## Learning Objectives

- Connect a Microsoft Foundry agent to Elasticsearch through Elastic MCP with scoped, read-only access.
- Explain how native Context Engine automations turn source data into reusable KIs in an AI Index.
- Use one AI Index to describe multiple source indices while preserving access to current source records.
- Compare discovery calls, service-reported tokens, answer correctness, and latency without assuming guaranteed savings.

## Challenges

- Challenge 00: **[Ready, Set, Connect](Student/Challenge-00.md)**
  - Prepare your own environments and launch the supplied notebook workspace.
- Challenge 01: **[Connect Foundry Agent to Elastic](Student/Challenge-01.md)**
  - Build a Foundry agent with Elastic MCP and collect a discovery baseline.
- Challenge 02: **[Build the Context Engine](Student/Challenge-02.md)**
  - Create an AI Index and Knowledge Indicators, and retrieve the Context Engine MCP endpoint.
- Challenge 03: **[Rise of Agent Optimus](Student/Challenge-03.md)**
  - Build a Foundry agent that uses Knowledge Indicators and compare it with Agent Mole.

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
