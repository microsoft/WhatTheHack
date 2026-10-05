# What The Hack - GitHub Copilot Cost Optimization

## Introduction

GitHub Copilot transforms developer productivity, but with usage-based billing (UBB), every token counts. This What The Hack teaches engineering teams how to maximize code quality while minimizing AI credit spend through smart engineering practices.

You'll learn to control the three cost levers: what enters the context (instructions, attachments, MCP tools), what the model produces (model selection, output constraints), and how efficiently you use the session (cache management, context window hygiene, deterministic feedback loops). By the end, you'll understand that most Copilot cost optimization isn't about restricting usage, it's about engineering better inputs and workflows that help the agent succeed faster.

## Learning Objectives

In this hack, you will learn practical techniques to optimize GitHub Copilot usage costs:

- Reduce persistent instruction overhead through scoped, path-specific configuration files
- Choose appropriate models and apply output constraints to control generation costs
- Manage MCP tool sprawl and understand cache invalidation triggers
- Apply proactive context window management to maintain quality and control costs
- Leverage deterministic feedback loops (tests, linters, type checks) as token controls
- Measure and compare credit spend across different coding workflows

## Challenges

- Challenge 00: **[Prerequisites](Student/Challenge-00.md)**
   - Set up the hack environment
- Challenge 01: **[Spec-Driven Development](Student/Challenge-01.md)**
   - Demonstrate that deterministic controls (tests, specs) reduce trial-and-error token burn
- Challenge 02: **[Context Engineering](Student/Challenge-02.md)**
   - Audit and restructure global instructions into scoped files, and replace broad references with pinned attachments
- Challenge 03: **[Model Selection & Output Constraints](Student/Challenge-03.md)**
   - Compare credit costs across models and reasoning levels, and apply output constraints to reduce token spend
- Challenge 04: **[Session Configuration (Tools + Cache)](Student/Challenge-04.md)**
   - Prune unused MCP tools and understand cache invalidation patterns
- Challenge 05: **[Context Window Management](Student/Challenge-05.md)**
   - Use /compact proactively to manage growing context windows and avoid context rot
- Challenge 06: **[Token Golf Competition](Student/Challenge-06.md)**
   - Complete a coding task with the lowest credit spend while meeting all acceptance criteria

## Prerequisites

- GitHub Copilot subscription
- GitHub Copilot Fundamentals
- Visual Studio Code OR IDE of choice with GitHub Copilot extension installed

## Repository Contents

- `Student/Resources/` - Starter codebase with intentionally sub-optimal Copilot configuration for teams to optimize
- `Coach/Solutions/` - Reference implementations and measurement data for each challenge

## Contributors

- Andy Huang
- Andressa Siqueira
- Anastasia Nefedova
- Anahita Afshari
- Devanshi Thakar
