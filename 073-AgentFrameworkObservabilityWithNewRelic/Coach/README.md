# What The Hack - 🚀 WanderAI - Coach Guide

## Introduction

Welcome to the coach's guide for the WanderAI What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.
This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge. It is recommended that the host present each short presentation before attendees kick off that challenge.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
  - Prepare your workstation to work with Azure.
- Challenge 01: **[Master the Foundations](./Solution-01.md)**
  - Understand Microsoft Agent Framework and AI agent concepts (45 mins)
- Challenge 02: **[Build Your MVP](./Solution-02.md)**
  - Create Flask app with AI travel planner agent (2-3 hours)
- Challenge 03: **[Add OpenTelemetry Instrumentation](./Solution-03.md)**
  - Initialize built-in OpenTelemetry, verify console output, and validate in New Relic (45 mins)
- Challenge 04: **[New Relic Integration](./Solution-04.md)**
  - Add custom spans/metrics/logging and validate custom signals in New Relic (1 hour)
- Challenge 05: **[Monitoring Best Practices](./Solution-05.md)**
  - Build dashboards and configure alerts for production (1.5 hours)
- Challenge 06: **[LLM Evaluation & Quality Gates](./Solution-06.md)**
  - Implement AI quality assurance and CI/CD gates (2-3 hours)
- Challenge 07: **[AI Security: Platform-Level Guardrails](./Solution-07.md)**
  - Configure and validate Microsoft Foundry Guardrails (1-1.5 hours)
- Challenge 08: **[AI Security: Application-Level Prompt Injection Controls](./Solution-08.md)**
  - Build custom detection and blocking in `web_app.py` (1.5-2 hours)

## Coach Prerequisites

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites (Optional)

_Please list any additional pre-event setup steps a coach would be required to set up such as, creating or hosting a shared dataset, or deploying a lab environment._

## Azure Requirements

This hack requires students to have access to the following:

### Required Azure Resources

- Access to an Azure subscription with **owner** access
- Already deployed and configured Azure Native New Relic Service
- All development is done in GitHub Codespaces or locally
- LLM access is provided through:
  - Option 1: GitHub Models (free tier, requires GitHub account)
  - Option 2: OpenAI API (requires API key, usage fees apply)
  - Option 3: Azure OpenAI Service (requires Azure subscription, optional)

### Required External Services

- **New Relic Account (Free Tier, if no Azure subscription is available)**
  - Sign up at: <https://newrelic.com/signup>
  - Free tier includes:
    - 100 GB data ingest per month
    - 1 full platform user
    - Unlimited basic users
    - Full access to AI Monitoring features
  - Students need to obtain:
    - License Key (for OTLP ingestion)
    - Account credentials

### GitHub Requirements

- **GitHub Account** (free)
  - Required for Codespaces
  - Required for GitHub Models access (optional LLM provider)
  - GitHub Copilot recommended (30-day free trial available)

### Permissions Required

- No special Azure permissions needed
- Azure subscription with **owner** access
- Students manage their own external service accounts

### Cost Estimates

- **Azure Subscription:** Test accounts will be available through educational programs and provided by the coach if needed
- **New Relic:** Free tier sufficient for hack duration
- **GitHub Codespaces:** Free tier (60 hours/month) sufficient
- **OpenAI API:** $0.50-$2.00 per student for hack duration (if using OpenAI)
- **GitHub Models:** Free tier available
- **Total estimated cost per student:** $0-$2 (if using free tiers)

## Suggested Hack Agenda

This hack is designed to be completed in a single day and finish by 5:00 PM with a compressed agenda (no scheduled breaks).

### **Single Day Agenda (8 hours)**

- **9:00 - 9:20** - Opening & Challenge 0 (Prerequisites)
  - Ensure all participants have working Codespaces or local dev environments
  - Verify GitHub Copilot is configured
- **9:20 - 9:45** - Challenge 1 (Master the Foundations)
  - Brief lecture on Microsoft Agent Framework concepts
  - Quick knowledge check
- **9:45 - 11:15** - Challenge 2 (Build Your MVP)
  - Hands-on: Build Flask app with AI travel planner agent
  - Support participants who encounter issues
- **11:15 - 12:00** - Challenge 3 (Add OpenTelemetry)
  - Brief lecture on observability concepts
  - Verify built-in telemetry in console and New Relic
- **12:00 - 12:40** - Lunch
- **12:40 - 1:30** - Challenge 4 (New Relic Integration)
  - Add custom spans/metrics/logging
  - Validate custom signals in New Relic
- **1:30 - 2:20** - Challenge 5 (Monitoring Best Practices)
  - Build custom dashboards
  - Configure alerts, SLIs, and SLOs for production readiness
- **2:20 - 3:20** - Challenge 6 (LLM Evaluation & Quality Gates)
  - Implement custom events for New Relic AI Monitoring
  - Build evaluation pipeline
- **3:20 - 4:20** - Challenge 7/8 security implementation
  - Configure platform guardrails (Challenge 7)
  - Add application-level controls in `web_app.py` (Challenge 8)
- **4:20 - 5:00** - Final presentations and wrap-up
  - Teams demo complete solutions
  - Q&A and next steps

### **Flexible/Self-Paced Option**

Participants can complete this hack at their own pace over 1-2 weeks, spending approximately:

- Challenges 0-1: 1.5 hours
- Challenge 2: 2-3 hours
- Challenge 3: 45 minutes
- Challenge 4: 1 hour
- Challenge 5: 1.5 hours
- Challenge 6: 2.5 hours
- Challenge 7: 1-1.5 hours
- Challenge 8: 1.5-2 hours

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

## Judging Criteria

If this hack is run as a competition, use the following 100-point rubric:

### Judge Scorecard (One Page)

| Category | Weight | Score (0-4) | Weighted Score | Notes |
| --- | ---: | ---: | ---: | --- |
| Solution Completeness | 25 |  |  |  |
| Observability Quality | 20 |  |  |  |
| AI Quality & Evaluation | 20 |  |  |  |
| Security Implementation | 20 |  |  |  |
| Demo Clarity & Engineering Excellence | 15 |  |  |  |
| **Total** | **100** |  |  |  |

Scoring formula for each row: `Weighted Score = (Score / 4) x Weight`

Use this quick worksheet format:

- Team Name:
- Judge Name:
- Date:
- Final Total (out of 100):

- **Solution Completeness (25 points)**
  - Challenges 0-6 implemented end-to-end
  - Challenge 7 and 8 security controls implemented and demonstrated
- **Observability Quality (20 points)**
  - Built-in and custom telemetry visible and actionable in New Relic
  - Dashboards, alerts, SLIs, and SLOs are meaningful and production-oriented
- **AI Quality & Evaluation (20 points)**
  - LLM evaluation pipeline is implemented and produces clear pass/fail signals
  - Quality gates are integrated into workflow (manual or CI/CD)
- **Security Implementation (20 points)**
  - Platform guardrails are correctly configured and validated
  - Application-level prompt injection protections are effective and tested
- **Demo Clarity & Engineering Excellence (15 points)**
  - Team explains architecture and trade-offs clearly
  - Code/readme organization, reliability, and troubleshooting approach are strong

Suggested scoring scale per category:

- 0 = Not implemented
- 1 = Partially implemented, major gaps
- 2 = Functional but limited depth
- 3 = Strong implementation with minor gaps
- 4 = Excellent, production-ready quality

Tie-breakers (in order):

1. Best evidence-driven incident response workflow using telemetry and alerts
2. Strongest measurable improvement from evaluation/quality gate iterations
3. Most complete and defensible security validation during demo
