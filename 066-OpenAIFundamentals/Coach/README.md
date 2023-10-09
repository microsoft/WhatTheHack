# What The Hack - Azure OpenAI Fundamentals - Coach Guide

## Introduction

Welcome to the coach's guide for the Azure OpenAI Fundamentals What The Hack. While this Hack is designed to be taken individually in a self-paced, self-administered manner, here you will find links to specific guidance for each of the challenges. There can be multiple ways to implement a solution in the challenges, so these solution guides are non-exhaustive but are rather, guides for when participants are feeling stuck or if they would like to compare solutions. In addition, take a look at the suggested hack agenda for options on how to conduct this hack with your participants.

**NOTE:** If you are a Hackathon participant, this is the answer guide. We encourage you to challenge yourself and avoid cheating yourself out of the experience by only referencing these when needed.


This hack includes an optional [lecture presentation](Lectures.pptx) that features short presentations to introduce key topics associated with each challenge.

## Suggested Hack Agenda 
The following is guidance for hosting this hack versus directing students to self-administer.
- Create a 2-week async format where participants work through these challenges at their own pace. There would be an initial synchronous kick-off call. Coaches would provide office hours a few times a week. In addition, there would be asynchronous support via a Microsoft Team's Channel - one channel per challenge that the subject matter experts/Coaches monitor for the duration of the hack.
- Run the hack for 2-3 days with coach assistance. Have all the participants join the kickoff call. Create breakout rooms for each coach to work with their set of students. Encourage the participants to work with each other in a team.

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

Before the hack, it is the Coach's responsibility to download and package up the contents of the `/Student/Resources` folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.

### Additional Coach Prerequisites (Optional)

Coaches will not need additional resources other than the student prerequisites. We have reproduced the list below for reference.

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- [Azure subscription](https://portal.azure.com/) - Estimated spend may be around $10 based on running Cognitive Search for four days (total length of time depends on implementation time)
- [Access to Azure OpenAI](https://customervoice.microsoft.com/Pages/ResponsePage.aspx?id=v4j5cvGGr0GRqy180BHbR7en2Ais5pxKtso_Pz4b1_xUOFA5Qk1UWDRBMjg0WFhPMkIzTzhKQ1dWNyQlQCN0PWcu)
- Jupyter Notebook editor (we recommend [Visual Studio Code](https://code.visualstudio.com/Download) or [Azure Machine Learning Studio](https://ml.azure.com/))
	- If using Visual Studio Code, we also recommend installing [Anaconda](https://docs.anaconda.com/anaconda/install) OR [Miniconda](https://docs.anaconda.com/anaconda/install) for project environment management
- [Python](https://www.python.org/downloads/) (version 3.7.1 or later), plus the package installer [pip](https://pypi.org/project/pip/)
- [Azure Cognitive Search](https://learn.microsoft.com/azure/search) (Basic Tier) - This will be created during the Hack and is not necessary to get started.

## Repository Contents

_The default files & folders are listed below. You may add to this if you want to specify what is in additional sub-folders you may add._

- `./Coach`
  - Coach's Guide and related files
  - `./Coach/Solutions`
    - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
  - `./Student/Challenges`
    - Student's Collection of Challenges
  - `./Student/Resources`
    - Resource files, sample code, scripts, etc meant to be provided to students. (Must be packaged up by the coach and provided to students at start of event)
    - `./Student/Resources/data`
      - Data resources for the Challenge Notebooks
    - `./Student/Resources/Notebooks`
      - Challenge Jupyter Notebooks
