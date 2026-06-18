# What The Hack - Author's Guide

This guide focuses on **what** makes a great hack — content design, challenge structure, templates, and resources. For the step-by-step **process** of setting up your environment and contributing to the repo (forking, scaffolding, pull requests), see the [Contribution Guide](../CONTRIBUTING.md#contribute-a-new-hack-to-what-the-hack).

Developing a new What The Hack is a great way to get your content out to the world. Chances are if you've done workshops or PoCs in the past, you already have the material on which to base a What The Hack.

## Why What The Hack?

The What The Hack "challenge" format is perfect for team-based, hands-on learning experiences.

What The Hack is all about being "for the people, by the people". This repo was originally created to share real-world hackathons that Microsoft employees have hosted with their customers. Here are our core principles:
- Anyone can contribute a hack.
- Anyone can use the content to host their own event.
- Anyone can modify the content as needed.
  - Submitting a pull request for modified/improved content is encouraged.
- The content can always be shared with attendees **(Only do this after the event is over!)**

## What Does It Take To Create a What The Hack?

The **"Create New Hack" GitHub Action** scaffolds out all of the elements you need for a hack from a set of template files. Once you have run the Action (see the [Contribution Guide](../CONTRIBUTING.md#development-process) for instructions), your hack folder will contain templates for each of the following elements that you will customize with your content:

- [Hack Folder Structure](#hack-folder-structure)
- [Hack Description](#hack-description) (aka "The One Pager")
- [Challenge Design](#challenge-design)
- [Student Resources](#student-resources)
- [Presentation Lectures](#presentation-lectures) (optional)
- [Coach's Guide](#coaches-guide)
- [Coach Solutions](#coach-solutions)

If you work through these in order, you will be able to flesh out a new hack rapidly. 

**HINT:** The Coach's guide and Coach Solutions is the most detail oriented & time consuming item to produce.  Shhh...  don't say we told you this, but hack authors have been known to write the Coach's Guide as a post-mortem from their first run of the hack.

## Hack Folder Structure

The "Create New Hack" GitHub Action scaffolds the following folder structure for your hack:

```
xxx-HackName/
├── README.md                        # Hack Description ("The One Pager")
├── Coach/
│   ├── Solution-XX.md               # Coach's Guide with solution steps per challenge
│   └── Solutions/                   # Solution code for the coach only
└── Student/
    ├── Challenge-00.md              # Challenge 0 (prerequisites)
    ├── Challenge-01.md              # Challenge 1
    ├── Challenge-XX.md              # Additional challenges
    └── Resources/                   # Files and resources for students
        └── .devcontainer/
            └── devcontainer.json    # DevContainer config for local use
```

There is also a root-level devcontainer entry created at `/.devcontainer/xxx-HackName/devcontainer.json` which is used for launching Codespaces from the WTH repo during development. See the [Student Resources](#student-resources) section for details.

Each of the templates contains in-line instructions and sample text to guide you. The sections below describe what each element should contain and how to customize it.

## Hack Description

Why should someone take the time to deliver or participate in your hack?  This is the main question you need to answer in order to define your hack. Every WTH needs to have an executive summary (aka "one pager") that quickly describes your hack to those who will host or attend your hack. Think of this as your marketing pitch. 

**HINT:** The "Hack Description" can serve a dual purpose. If you take the time to write it first, it can be the outline or specification for your hack before you develop the actual content.

The "Hack Description" is the `README.md` in the root of your hack's top level folder. The Action scaffolds this file from the [Hack Description Template](WTH-HackDescription-Template.md).

The "Hack Description" must include the following:

### Hack Title

Give your hack name. Keep it short, but consider giving it a "fun" name that is more than just the name of the technologies that the hack will cover.
  
### Introduction

This is your chance to sell the casual reader on why they should consider your hack. In a paragraph or two, consider answering the following questions:

- What technologies or solutions will it cover? 
- Why are these technologies or solutions important or relevant to the industry?
- What real world scenarios can these technologies or solutions be applied to?

### Learning Objectives

This is where you describe the outcomes a hack attendee should have. Provide a short list of key learnings you expect someone to come away with when they complete this hack.

### Challenges

Every WTH is made up of a collection of technical challenges. For the one pager, you should list out your challenges by name, with no more than a single sentence description for each unless the challenge title is descriptive enough on its own.

For most this page will act as a "Table of Contents" for your hack. We recommend that you create links for each challenge to its respective challenge page.

### Prerequisites

Provide a list of technical prerequisites for your hack here.  List out assumed knowledge attendees should have to be successful with the hack. For example, if the hack is an "Introduction to Kubernetes", the attendee should have a basic understanding of containers.  However, if it is an "Advanced Kubernetes" hack, then the attendee should know the basics of Kubernetes and not ask you what a "pod" or "deployment" is.

Provide a list of tools/software that the attendee needs to install on their machine to complete the hack. 

We have compiled a list of common tool pre-requisites needed for most of the Azure related hacks here:
- [What The Hack Common Prerequisites](WTH-Common-Prerequisites.md). 

You can provide a link to it in your hack's prerequisites section in addition to any unique prerequisites for your hack.

### Repository Contents (Optional)

While optional, it is a good idea to provide a catalog of the files you are providing with your hack. 

### Contributors

Finally, give yourself and your fellow hack authors some credit. List the names and optionally contact info for all of the authors that have contributed to this hack.

### Hack Description Template

The template for the Hack Description is available here for reference:
- [Hack Description Template](WTH-HackDescription-Template.md)

The Action has already placed this template as the `README.md` in your hack's root folder. Open it and replace the sample text with your own content.

## Challenge Design

Challenges are at the heart of the WTH format. Designing challenges is what a hack author should spend the majority of their time focusing on. 

There are different approaches to designing a hackathon. If you are familiar with the Marvel Comic Universe movies, you know that they follow one of two patterns:
- "Origin Story" - A movie focused on the back story of a SINGLE superhero that lets the audience get to know that character in depth (perhaps with a sidekick character or two included).
- "Avengers Story" - A movie with an ensemble cast of superhero characters working together to solve a mega problem, with each character getting varying amounts of screen time. 

You can use the same patterns when designing a What The Hack.

- Singleton Hack - A hack designed to give in-depth hands-on experience with a specific technology and maybe a "sidekick technology" or two included.
- Solution Hack - A hack designed to give experience solving a real-world scenario that involves using multiple technolgies together for the solution.

Once you have decided what type of hack you want to create, you should follow these guidelines when designing the challenges:

- Include a “Challenge 0” that helps attendees install all of the prerequisites that  are required on their computer, environment or Azure account.
- Challenge descriptions should be shorter than this section on how to design challenges. Keep it to a couple of sentences or bullet points stating the goal(s) and perhaps a hint at the skill(s) needed.
- Think through what skills/experience you want attendees to walk away with by completing each challenge
- Challenges should be cumulative, building upon each other and they should:
    - Establish Confidence – Start small and simple (think "Hello World")
    - Build Competence – By having successively more complex challenges.	
- Each challenge should provide educational value.  
    - For example, if an attendee completes only 3 out of 7 challenges, he/she still walks away feeling satisfied that they will have still learned something valuable.
- Take into consideration that a challenge might have more than one way to solve it and that's OK.
- Provide verifiable success criteria for each challenge that lets the coaches and attendees know they have completed it.
- Provide relevant links to learning resources that should lead the attendees toward the knowledge they need to complete the challenge.
- Provide hints for items that could potentially be time consuming to figure out but are of low learning value or relevance to the actual goal of the challenge. **For example:** A command line parameter that is not obvious but would take hours to debug if it were missed.
- Do **NOT** provide a list of step-by-step instructions. These are challenges designed to make the attendees learn by solving problems, not blindly following instructions.

### Challenge Template

The template for each challenge is available here for reference:
- [Challenge Template](WTH-Challenge-Template.md)

The Action has placed challenge templates in your hack's `../Student` folder as `Challenge-00.md`, `Challenge-01.md`, etc. Open each one and replace the sample text with your challenge content.

**NOTE:** In each challenge's markdown file, you should create navigation links to/from the previous & next challenges. Please use relative links (eg. `"/Challenge-XX.md"`) instead of absolute links (eg. `"http://github.com/Microsoft/WhatTheHack/000-YourAwesomeHack/Student/Challenge-XX.md"`)  

## Student Resources

It is common to provide attendees with resources in order to complete the hack's challenges. One example is to provide the code for an application that the hack's challenges are based on. Another example might be to provide sample code files, artifacts, or templates that provide guidance for completing the hack's challenges.

If your hack provides attendees with code or resources, they should be included with your hack's contents in the `../Student/Resources` folder.

### GitHub Codespaces & DevContainers

[GitHub Codespaces](https://docs.github.com/en/codespaces) provides a cloud-hosted development environment that students can access directly from their browser. A Codespace is powered by a [DevContainer](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers), which is a configuration file (`devcontainer.json`) that defines the tools, extensions, and settings for the development environment.

We strongly encourage all new hacks to support GitHub Codespaces. This provides students with a consistent, pre-configured environment that includes all the tools and resources they need to complete the hack without installing anything on their local workstation. Students who prefer to work locally can use the same DevContainer configuration to run the environment on their own machine.

#### How It Works

Each hack that supports Codespaces has **two copies** of its `devcontainer.json` file in the repo:

1. **`/.devcontainer/xxx-HackName/devcontainer.json`** (root-level copy)
   - This is the copy you will work with and test during development.
   - It contains `workspaceFolder` and `workspaceMount` settings that point to your hack's `/Student/Resources` folder within the repo.
   - This allows you to quickly launch a Codespace from your fork of the WTH repo to test your hack's environment as you are authoring it.

2. **`../Student/Resources/.devcontainer/devcontainer.json`** (hack-level copy)
   - This copy is used when students run the DevContainer on their local workstation.
   - The `workspaceFolder` and `workspaceMount` settings should remain commented out in this copy, as they are not needed for local use.

The **"Create New Hack" GitHub Action** automatically creates both copies from the [DevContainer Template](devcontainerTEMPLATE.json) when you scaffold a new hack. The Action takes care of uncommenting the workspace settings in the root-level copy and leaving them commented out in the hack-level copy.

**IMPORTANT:** While authoring your hack, you must keep both copies of `devcontainer.json` in sync. When you make changes to customize your devcontainer (adding tools, extensions, etc.), update the root-level copy first (since that is the one you test with), and then copy those changes to the hack-level copy.

#### Customizing Your DevContainer

The scaffolded `devcontainer.json` provides a baseline configuration. You should customize it for your hack's specific needs:

- **`name`**: Update with your hack's number and name (e.g., `"042-SAPOnAzure"`)
- **`features`**: Add or remove development tools your hack requires (e.g., Azure CLI, kubectl, Python, .NET, Terraform, etc.)
- **`customizations.vscode.extensions`**: Add VS Code extensions that are useful for your hack (e.g., Bicep, Python, Docker, etc.)
- **`customizations.codespaces.openFiles`**: List files that should automatically open when a student launches the Codespace (e.g., a README or getting-started guide in your Resources folder)

#### Referencing Resource Files in Challenge Text

When writing your challenge descriptions, refer to resource files using their path relative to the Codespace root. Since the Codespace opens to the `/Student/Resources` folder, reference files relative to that location.

For example, given a file at `../Student/Resources/infra/deploy.sh` in the repo, your challenge text should refer to it as:

> *"The `deploy.sh` file in the `/infra` folder of your Codespace"*

Do **NOT** reference file paths relative to the WTH repo or assume students will unpack a zip file.

## Presentation Lectures

You may be wondering why there is a section called "Presentation Lectures" when the whole point of What The Hack is to be hands-on and ***NOT*** a "death by Power Point" snoozefest?!  

When you host a What The Hack event, there is always a kick off meeting where the attendees are welcomed and then introduced to the logistics of the hack. The best way to do that is with a *short* PowerPoint delivered a few slides at a time.

We have provided Event Kickoff presentation templates that you can customize for your hack and use to cover attendee logistics for a WTH event. These are available for reference here:
- [Event Kickoff Presentation Template (Virtual)](WTH-EventKickoff-Virtual-Template.pptx)
- [Event Kickoff Presentation Template (In-Person)](WTH-EventKickoff-InPerson-Template.pptx)

After the kickoff meeting, its up to the hack authors if they want to provide any presentation lectures.  Some hack challenges are easy to jump right into.  Others are more complex and are better preceded by a brief introduction presentation.

It is OK and encouraged to offer a collection of "mini" presentation lectures if necessary for your hack's challenges. If you do provide a presentation lecture, consider these guidelines for each challenge:

- Try to limit the lectures to **5-10 minutes** per challenge.
- Provide a brief overview of the challenge scenario & success criteria
- Provide a brief overview of concepts needed to complete the challenge
- Provide "reference" slides that you might not present, but will have on hand if attendees need additional guidance
- Provide a slide with the challenge description that can be displayed when attendees are working on that challenge

We have more guidance on how and when to deliver mini presentation lectures for your challenges during your event in the [How To Host a What The Hack](WTH-HowToHostAHack.md) guide.

Publish any presentations in your hack's `../Coach` folder.

## Coaches Guide

Every WTH should come with a Coach's guide. The Action has placed a Coach's Guide template in your hack's `../Coach` folder. The template is available here for reference:
- [Coach's Guide Template](WTH-CoachGuide-Template.md)

The simple way to think of the Coach's guide is that it should be the document with all of "the answers". The reality is, doing so would turn it into a giant step-by-step document loaded with detailed commands, screenshots, and other resources that are certain to be obsolete the minute you publish it. No one wants to maintain a document like that. 

Instead of treating the Coach's guide like a step-by-step document, treat it as the "owner's manual" you would want to provide to future coaches so they can host and deliver your WTH to others. 

The Coach's guide should include the following:

- List of high-level solution steps to each challenge
- List of known blockers (things attendees will get hung up on) and recommended hints for solving them. For example:
    - Resources that will take a long time to deploy in Azure: Go get a coffee.
    - If installing the Azure CLI on Windows, install it in the Windows Subsystem for Linux instead of just Windows itself
    - Permission issues to be aware of, etc
- List of key concepts that should be explained to/understood by attendees before a given challenge (perhaps with a presentation lecture)
- List of reference links/articles/documentation that can be shared when attendees get stuck
- Estimated time it would take an attendee to complete each challenge. This will help coaches track progress against expectation. It should NOT to be shared with attendees.
- Suggested time a coach should wait before helping out if a team is not progressing past known blockers

The Coach's guide should be updated during & post event with key learnings, such as all the gotchas, snags, and other unexpected blockers that your attendees hit.

## Coach Solutions

This is where you put "the answers". There are usually multiple ways to solve a WTH Challenge. The solutions you provide here should be example solutions that represent one way to solve the challenges. The solution resources might include a full working application, configuration files, populated templates, or other resources that can be used to demonstrate how to solve the challenges. 

Examples of Coach Solutions are:
- Prerequisites for the Azure environment if needed. 
    - Example: A VM image with Visual Studio or ML tools pre-installed. 
    - Example: An ARM template and/or script that builds out an environment that saves time on solving a challenge
- Scripts/templates/etc for some challenges that can be shared with attendees if they get really stuck
    - Example: If challenges 1 through 3 build something (i.e. an ARM template) that is needed for challenge 4, you could “give” a stuck team the template so they could skip to challenge 4.

The Action has created a `../Coach/Solutions` folder for your hack. Place your solution code, templates, and other resources there.

**NOTE:** This content is not intended for hack attendees to see before or during a hack event. The content IS available publicly and thus an attendee can and WILL find it if they are determined enough. It is important to stress to the attendees that they should not cheat themselves out of an education by looking at the solutions.
