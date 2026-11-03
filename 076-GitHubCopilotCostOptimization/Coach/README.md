# What The Hack - GitHub Copilot Cost Optimization - Coach Guide

## Introduction

Welcome to the coach's guide for the GitHub Copilot Cost Optimization What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

This hack teaches teams to maximize code quality while minimizing GitHub Copilot credit spend under usage-based billing (UBB). The focus is on practical engineering techniques: context engineering, model selection, session hygiene, and spec-driven development.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites & Baseline](./Solution-00.md)**
   - Set up the hack environment and establish baseline credit spend measurements
- Challenge 01: **[Spec-Driven Development](./Solution-01.md)**
   - Leverage deterministic controls as token controls
- Challenge 02: **[Context Engineering](./Solution-02.md)**
   - Optimize instruction architecture and attachment precision
- Challenge 03: **[Model Selection & Output Constraints](./Solution-03.md)**
   - Compare models and apply output constraints to reduce costs
- Challenge 04: **[Session Configuration (Tools + Cache)](./Solution-04.md)**
   - Manage MCP tool sprawl and understand cache invalidation
- Challenge 05: **[Context Window Management](./Solution-05.md)**
   - Use /compact proactively to maintain quality and control costs
- Challenge 06: **[Token Golf Competition](./Solution-06.md)**
   - Competitive coding challenge optimizing for lowest credit spend

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

The Student/Resources folder should contain:

- **Starter codebase** with intentionally sub-optimal GitHub Copilot configuration:
  - Bloated `.github/copilot-instructions.md` (~1500 tokens) for Challenge 02
  - Multiple MCP tools enabled (some unnecessary) for Challenge 04
  - Sample code with opportunities for spec-first vs. trial-and-error comparison
- **Baseline coding task** (baseline-task.md) for Challenge 00
- **Model selection prompts + measurement template** (`Challenge-03-ModelSelection/`) for Challenge 03

Challenge 06 (Token Golf) requires no starter codebase or spec file—the weather dashboard task and its acceptance criteria are described directly in the student's Challenge 06 guide.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites

**Coach must complete Challenge 06 (Token Golf) before the hack:**

- Complete the Token Golf coding task yourself to establish "par" score
- Document your credit spend and techniques used
- This "par" becomes the benchmark teams compete against

**Prepare measurement tools:**

- Verify token visibility in VS Code Output panel (GitHub Copilot Chat)
- Test access to GitHub Copilot usage dashboard

## Azure Requirements

This hack does not require Azure resources. All work is done locally with GitHub Copilot in Visual Studio Code.

## Suggested Hack Agenda

This hack can be delivered as a half-day or full-day event:

### Half-Day Format (4 hours)
- Challenge 00: Prerequisites & Baseline (30 minutes)
- Challenge 01: Spec-Driven Development (45 minutes)
- Challenge 02: Context Engineering (45 minutes)
- Challenge 03: Model Selection & Output Constraints (45 minutes)
- Challenge 04: Session Configuration (30 minutes)
- Challenge 06: Token Golf Competition (45 minutes)

### Full-Day Format (6-7 hours)
- Challenge 00: Prerequisites & Baseline (45 minutes)
- Challenge 01: Spec-Driven Development (60 minutes)
- Challenge 02: Context Engineering (60 minutes)
- Break (15 minutes)
- Challenge 03: Model Selection & Output Constraints (60 minutes)
- Challenge 04: Session Configuration (45 minutes)
- Challenge 05: Context Window Management (45 minutes)
- Break (15 minutes)
- Challenge 06: Token Golf Competition (60 minutes)
- Debrief & Winning Strategies (30 minutes)

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with example measurements and techniques for each challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Starter codebase, baseline task, Token Golf specification (Must be packaged up by the coach and provided to students at start of event)

- Azure resources that will be consumed by a student implementing the hack's challenges
- Azure permissions required by a student to complete the hack's challenges.

## Suggested Hack Agenda (Optional)

_This section is optional. You may wish to provide an estimate of how long each challenge should take for an average squad of students to complete and/or a proposal of how many challenges a coach should structure each session for a multi-session hack event. For example:_

- Sample Day 1
  - Challenge 1 (1 hour)
  - Challenge 2 (30 mins)
  - Challenge 3 (2 hours)
- Sample Day 2
  - Challenge 4 (45 mins)
  - Challenge 5 (1 hour)
  - Challenge 6 (45 mins)

## Repository Contents

_The default files & folders are listed below. You may add to this if you want to specify what is in additional sub-folders you may add._

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
