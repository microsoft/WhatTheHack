# What The Hack - Azure OpenAI Fundamentals - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure OpenAI Fundamentals What The Hack. This hack is designed to be completed individually in a self-paced, self-administered manner without a coach or being part of an event.

However, you can use this coach's guide to host a hack the traditional way as documented in the [What The Hack Host Guide](https://aka.ms/wthhost).

Here you will find links to specific guidance for each of the challenges. There can be multiple ways to implement a solution in the challenges, so these solution guides are non-exhaustive but are rather, guides for when participants are feeling stuck or if they would like to compare solutions. In addition, take a look at the suggested hack agenda for options on how to conduct this hack with your participants.

**NOTE:** If you are a Hackathon participant, this is the answer guide. We encourage you to challenge yourself and avoid cheating yourself out of the experience by only referencing these when needed.

<!-- Commented out until  presentation slides are actually posted
This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge.
-->

## Coach's Guides
There are six challenges, but only the first four require participants to generate their own code. We have included solution guides for those challenges here.

- Challenge 00: **[Prerequisites - Ready, Set, GO!](./Solution-00.md)**
	 - Prepare your workstation to work with Azure.
- Challenge 01: **[Prompt Engineering](./Solution-01.md)**
	 - What's possible through Prompt Engineering 
	 - Best practices when using OpenAI text and chat models
- Challenge 02: **[OpenAI Models & Capabilities](./Solution-02.md)**
	 - This challenge is OPTIONAL.
   - What are the capacities of each Azure OpenAI model?
	 - How to select the right model for your application
- Challenge 03: **[Grounding, Chunking, and Embedding](./Solution-03.md)**
	 - Why is grounding important and how can you ground a Large Language Model (LLM)?
	 - What is a token limit? How can you deal with token limits? What are techniques of chunking?
- Challenge 04: **[Retrieval Augmented Generation (RAG)](./Solution-04.md)**
	 - What is Retrieval Augmented Generation?
	 - How does it work with structured and unstructured data?
- Challenge 05: **[Responsible AI](./Solution-05.md)**
	   - What are services and tools to identify and evaluate harms and data leakage in LLMs?
     - What are ways to evaluate truthfulness and reduce hallucinations?
     - What are methods to evaluate a model if you don't have a ground truth dataset for comparison?

## Coach Prerequisites

If you would like to host this hack as event, there are prerequisites that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

This hack has been designed for students to run a Jupyter Notebook environment hosted in GitHub Codespaces. A separate GitHub repo containing the student resources and Codespace's configuration for this hack is hosted here:
- [WTH OpenAI Fundamentals Codespace Repo](https://aka.ms/wth/openaifundamentals/codespace)

A GitHub Codespace is a development environment that is hosted in the cloud that you access via a browser. All of the pre-requisite developer tools for this hack are pre-installed and available in the codespace. This makes it easy to complete this hack for students in organizations where they do not have the ability to install software packages on their local workstations.

We highly recommend students use the GitHub Codespace to complete this hack.  If a student wants to set up their local workstation to complete the hack, the instructions for doing so are still listed in Challenge 00 of the student guide.

The student resources required to run this hack from a local workstation are provided in a `Resources.zip` file that is hosted [here](https://aka.ms/wth/openaifundamentals/resources). Students are provided a link to this file in the Challenge 00 instructions of the student guide. 

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- [Azure subscription](https://azure.microsoft.com/en-us/free/) 
  <!-- Estimated spend may be around $10 based on running Cognitive Search for four days (total length of time depends on implementation time) -->
- [Access to Azure OpenAI](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR7en2Ais5pxKtso_Pz4b1_xUOFA5Qk1UWDRBMjg0WFhPMkIzTzhKQ1dWNyQlQCN0PWcu)
- Jupyter Notebook editor (we recommend [Visual Studio Code](https://code.visualstudio.com/Download) or [Azure Machine Learning Studio](https://ml.azure.com/))
	- If using Visual Studio Code, we also recommend installing [Anaconda](https://docs.anaconda.com/anaconda/install) OR [Miniconda](https://docs.anaconda.com/anaconda/install) for project environment management
- [Python](https://www.python.org/downloads/) (version 3.7.1 or later), plus the package installer [pip](https://pypi.org/project/pip/)
- [Azure Cognitive Search](https://learn.microsoft.com/azure/search) (Basic Tier) - This will be created during the Hack and is not necessary to get started.

## Suggested Hack Agenda 

This hack is designed for students to go through on their own in a self-paced manner.  You can also run this hack the traditional way as documented in the [What The Hack Host Guide](https://aka.ms/wthhost).

In addition to running the hack the traditional way for 2-3 days with coach assistance, you can run it as a two-week asynchronous event. 

Here are some tips for doing this:
- Schedule a 2-week async format where participants work through these challenges at their own pace.
- Host an initial synchronous kick-off call to share logistics with the students, and review the hack's challenges.
- Coaches should provide office hours a few times a week.
- In addition, there should be asynchronous support via a Microsoft Team's Team
	- Create one channel per challenge that the subject matter experts/Coaches monitor for the duration of the hack.

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
  - `./Coach/Solutions`
    - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
  - `./Student/Resources`
    - Resource files, sample code, scripts, etc meant to be provided to students.
    - `./Student/Resources/data`
      - Data resources for the Challenge Notebooks
    - `./Student/Resources/notebooks`
      - Challenge Jupyter Notebooks
