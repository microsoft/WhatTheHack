# What The Hack - Author's Guide

This guide focuses on **what** makes a great hack — content design, challenge structure, templates, and resources. For the step-by-step **process** of setting up your environment and contributing to the repo (forking, scaffolding, pull requests), see the [Contribution Guide](../CONTRIBUTING.md#contribute-a-new-hack-to-what-the-hack).

Developing a new What The Hack is a great way to get your content out to the world. Chances are if you've done workshops or proof-of-concepts in the past, you already have the material on which to base a What The Hack.

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

- [Hack Description](#hack-description) (aka "The One Pager")
- [Challenge Design](#challenge-design)
- [Student Resources](#student-resources)
- [Presentation Lectures](#presentation-lectures) (optional)
- [Coach Guide](#coach-guide)
  - [Coach Guide Home Page](#coach-guide-home-page)
  - [Challenge Coach Guides](#challenge-coach-guides)
- [Coach Solutions](#coach-solutions)

If you work through these in order, you will be able to flesh out a new hack rapidly. 

**HINT:** The Coach Guide and Coach Solutions is the most detail oriented & time consuming item to produce.  Shhh...  don't say we told you this, but hack authors have been known to write the Coach Guide as a postmortem from their first run of the hack.

## Hack Folder Structure

The "Create New Hack" GitHub Action scaffolds the following folder structure for your hack:

```
xxx-HackName/
├── README.md                        # Hack Description ("The One Pager")
├── Coach/
│   ├── README.md                    # Coach Guide home page & table of contents
│   ├── Solution-XX.md               # Solution steps per challenge
│   ├── Lectures.pptx                # Lecture presentation deck (optional)
│   └── Solutions/                   # Solution code for the coach only
└── Student/
    ├── Challenge-00.md              # Challenge 0 (environment setup)
    ├── Challenge-01.md              # Challenge 1
    ├── Challenge-XX.md              # Additional challenges
    └── Resources/                   # Files and resources for students
        └── .devcontainer/           # (optional) DevContainer config
            └── devcontainer.json
```

**NOTE:** GitHub Codespaces/DevContainer support is optional when running the "Create New Hack" Action. If you choose not to enable Codespaces support, the `.devcontainer` folder and its `devcontainer.json` file will not be created. You can always add Codespaces support later by manually creating these files from the [DevContainer Template](devcontainerTEMPLATE.json).

If you do enable Codespaces support, there is also a root-level devcontainer entry created at `/.devcontainer/xxx-HackName/devcontainer.json` which is used for launching Codespaces from the WTH repo during development. See the [Student Resources](#student-resources) section for details.

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

This section serves as the **table of contents** for your hackathon. The "Create New Hack" Action has already created links for the number of challenges you requested when running the Action. Each link points to its corresponding challenge markdown file in the `/Student` folder.

Fill in the template with your challenge titles. Each link can include 1-2 sentences describing the challenge, or the challenge title alone may be descriptive enough on its own.

### Prerequisites

Keep this section short. List out the assumed knowledge attendees should have to be successful with the hack. For example, if the hack is an "Introduction to Kubernetes", the attendee should have a basic understanding of containers. However, if it is an "Advanced Kubernetes" hack, then the attendee should know the basics of Kubernetes and not ask you what a "pod" or "deployment" is.

For the full list of tools, software, and environment setup steps, refer the reader to Challenge 0. For example: *"See Challenge 0 for a full list of tools and setup steps required for this hack."*

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
- Solution Hack - A hack designed to give experience solving a real-world scenario that involves using multiple technologies together for the solution.

Once you have decided what type of hack you want to create, you should follow these guidelines when designing the challenges:

- The Action has already scaffolded a "Challenge 0" for your hack. Challenge 0 is where attendees set up their development environment (using GitHub Codespaces or their local workstation) and provision any required cloud resources (e.g., Azure subscriptions, resource groups). Customize the Challenge 0 template with the specific setup steps for your hack.
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

**NOTE:** The Action has already created navigation links in each challenge file that link to the preceding challenge, the hack home page, and the next challenge. If you need to add additional challenges beyond what was scaffolded, copy the [Challenge Template](WTH-Challenge-Template.md) into your `../Student` folder and update the navigation links to follow the same pattern. Always use relative links (e.g., `"Challenge-XX.md"`) instead of absolute links (e.g., `"http://github.com/Microsoft/WhatTheHack/000-YourAwesomeHack/Student/Challenge-XX.md"`).

## Student Resources

It is common to provide attendees with resources in order to complete the hack's challenges. One example is to provide the code for an application that the hack's challenges are based on. Another example might be to provide sample code files, artifacts, or templates that provide guidance for completing the hack's challenges.

If your hack provides attendees with code or resources, they should be included with your hack's contents in the `../Student/Resources` folder.

There are two options for making these resource files available to students during a hack event:

1. **GitHub Codespaces / DevContainers (Recommended)** — Students access a pre-configured cloud-hosted development environment in their browser with all resource files and tools ready to use. See [GitHub Codespaces & DevContainers](#github-codespaces--devcontainers) below.
2. **Resources.zip Distribution** — A coach packages the contents of the `/Student/Resources` folder into a `Resources.zip` file and distributes it to students. Students unpack the zip file on their local workstation and are responsible for installing any required tools themselves.

We strongly encourage all new hacks to use **Option 1** (Codespaces/DevContainers). If you choose Option 2 instead, you are responsible for documenting all prerequisites and any software installations required on the student's local workstation in Challenge 0.

### GitHub Codespaces & DevContainers

[GitHub Codespaces](https://docs.github.com/en/codespaces) provides a cloud-hosted development environment that students can access directly from their browser. A Codespace is powered by a [DevContainer](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/adding-a-dev-container-configuration/introduction-to-dev-containers), which is a configuration file (`devcontainer.json`) that defines the tools, extensions, and settings for the development environment.

When a student launches a Codespace for your hack, they will open VS Code in a browser window with:
- All of the files from your hack's `/Student/Resources` folder available in the file explorer
- Any command line tools specified in the devcontainer (e.g., Azure CLI, kubectl, Python, etc.) pre-installed and ready to use
- Any VS Code extensions specified in the devcontainer (e.g., Bicep, Python, etc.) pre-installed

Students who prefer to work locally can use the same DevContainer configuration to run the environment on their own machine with Docker and VS Code.

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

It is important to **never link directly to files in the WTH repo** from your challenge text. Students should not be directed to the repo during a hack event.

Instead, refer to resource files based on where students will access them. There are two scenarios depending on whether your hack uses Codespaces or not:

**If using Codespaces:** Refer to files relative to the Codespace root. Since the Codespace opens to the `/Student/Resources` folder, reference files relative to that location.

> *Example:* Given a file at `../Student/Resources/infra/deploy.sh` in the repo, your challenge text should say: *"Run the `deploy.sh` script in the `/infra` folder of your Codespace."*

**If NOT using Codespaces:** Students will receive a `Resources.zip` file from their coach that contains the contents of the `/Student/Resources` folder. Refer to files relative to where the student has unpacked the zip file.

> *Example:* For the same file, your challenge text should say: *"Run the `deploy.sh` script in the `/infra` folder of your Resources directory."*

**NOTE:** It is the coach's responsibility to package and distribute the `Resources.zip` file to students. This process is documented in the hack's Coach Guide and the [How To Host a What The Hack](WTH-HowToHostAHack.md) guide.

## Presentation Lectures

You may be wondering why there is a section called "Presentation Lectures" when the whole point of What The Hack is to be hands-on and ***NOT*** a "death by Power Point" snoozefest?!  

When you host a What The Hack event, there is always a kick off meeting where the attendees are welcomed and then introduced to the logistics of the hack. The best way to do that is with a *short* PowerPoint delivered a few slides at a time.

The Action has placed a template lecture deck (`Lectures.pptx`) in your hack's `../Coach` folder. Filling it out is optional, but **highly recommended**. The template includes slides for:

- A brief overview of the challenge scenario & success criteria
- A brief overview of concepts needed to complete the challenge
- "Reference" slides that you might not present, but will have on hand if attendees need additional guidance
- A slide with the challenge description that can be displayed when attendees are working on that challenge

We have also provided Event Kickoff presentation templates that coaches can customize for your hack to cover attendee logistics for a WTH event. These are available for reference here:
- [Event Kickoff Presentation Template (Virtual)](WTH-EventKickoff-Virtual-Template.pptx)
- [Event Kickoff Presentation Template (In-Person)](WTH-EventKickoff-InPerson-Template.pptx)

Some hack challenges are easy to jump right into. Others are more complex and are better preceded by a brief introduction presentation. It is OK and encouraged to offer a collection of "mini" presentation lectures if necessary for your hack's challenges. Try to limit the lectures to **5-10 minutes** per challenge.

We have more guidance on how and when to deliver mini presentation lectures for your challenges during your event in the [How To Host a What The Hack](WTH-HowToHostAHack.md) guide.

## Coach Guide

Every WTH must include a Coach Guide. The Coach Guide is the "owner's manual" for future coaches so they can host and deliver your hack to others. The Action scaffolds the Coach Guide files in your hack's `../Coach` folder, consisting of a home page and individual challenge coach guides.

### Coach Guide Home Page

The `README.md` in your hack's `../Coach` folder is the Coach Guide home page. The Action scaffolds this file from the [Coach Guide Home Page Template](WTH-CoachGuide-Template.md).

The Coach Guide home page contains both boilerplate guidance that applies to all hacks and sections specific to your hack that you need to fill out. The major sections include:

- **Introduction** — A brief welcome and overview of the hack for coaches.
- **Coach Guides (Table of Contents)** — Links to each of the challenge coach guide files (`Solution-XX.md`). Like the Hack Description page, the Action has pre-created these links for the number of challenges you requested. Fill in the challenge titles and descriptions to match the table of contents on your Hack Description page.
- **Coach Prerequisites** — Guidance for coaches on what they need to prepare before hosting an event, including how to handle student resources and any additional setup steps specific to your hack.
- **Azure Requirements** — Azure subscription requirements and permissions that should be shared with the organization providing Azure access for the hack.
- **Suggested Hack Agenda** (optional) — An estimate of how long each challenge should take and/or a suggested session structure for multi-day events.
- **Repository Contents** — A catalog of the files and folders in your hack.

### Challenge Coach Guides

For each challenge, the Action creates a `Solution-XX.md` file in your hack's `../Coach` folder. These are the individual coach guides for each challenge. The Action scaffolds these files from the [Challenge Coach Guide Template](WTH-Challenge-Solution-Template.md).

The simple way to think of each challenge coach guide is that it should be the document with all of "the answers" for that challenge. The reality is, making it a giant step-by-step document loaded with detailed commands, screenshots, and other resources would be certain to be obsolete the minute you publish it. No one wants to maintain a document like that.

Instead, treat each challenge coach guide as practical guidance for a coach to help attendees through that specific challenge. The structure of the solution files is less strict than the challenge templates, but each one should include:

- High-level solution steps for the challenge
- Known blockers (things attendees will get hung up on) and recommended hints for solving them. For example:
    - Resources that will take a long time to deploy in Azure: Go get a coffee.
    - If installing the Azure CLI on Windows, install it in the Windows Subsystem for Linux instead of just Windows itself
    - Permission issues to be aware of, etc
- Key concepts that should be explained to/understood by attendees before the challenge (perhaps with a presentation lecture)
- Reference links/articles/documentation that can be shared when attendees get stuck
- Estimated time it would take an attendee to complete the challenge. This will help coaches track progress against expectation. It should NOT be shared with attendees.
- Suggested time a coach should wait before helping out if a team is not progressing past known blockers

The challenge coach guides should be updated during & post event with key learnings, such as all the gotchas, snags, and other unexpected blockers that your attendees hit.

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
