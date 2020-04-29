# How to Create and Contribute your What The Hack

Developing a new What The Hack is a great way to get your content out into the world. Chances are if you've done workshops or PoCs in the past, you already have the material on which to base a What The Hack.

## Why What The Hack?

The What The Hack "challenge" format is perfect for team-based hands-on learning experiences.

What The Hack is all about being "for the people, by the people". This repo was originally created to share real-world hackathons that Microsoft employees have hosted with customers. There are some core principles:
- Anyone can contribute a hack.
- Anyone can use the content to host their own event.
- Anyone can modify the content as needed.
- The content can always* be shared with attendees (*after the hack!) 

## What Does It Take To Create a What The Hack?

When you design a WTH, these are the things you should be thinking of...

- [Hack Description](#hack-description) (aka "One Pager")
- [Challenge Design](#challenge-design)
- [Student Resources](#student-resources)
- [Presentation Lectures](#presentation-lectures) (optional)
- [Coaches' Guide](#coaches-guide)
- [Coach Solutions](#coach-solutions)

If you create things in this order, you will be able to flush out a new hack rapidly! 

**Hint:** The Coaches' guide and Coach Solutions can be the most detail oriented & time consuming item to produce.  Shhh...  don't say we told you this, but hack authors have been known to write the Coaches' Guide as a post-mortem from their first run of the hack!

## Hack Description

Why should someone take the time to participate in your hack?  This is the main question you need to answer in order to define your hack. Every WTH needs to have a hack description (aka "one pager") that quickly describes your hack to those who will host or attend your hack. Think of this as your marketing pitch. 

**Hint:** The "one pager" can serve a dual purpose. If you take the time to write it first, it can be the outline or specification for your hack before you develop the actual content!

The "Hack Description" shall be the Readme.md that lives in the root of your hack's top level folder.

The "Hack Description" should include the following:

### Hack Title

Give your hack name. Keep it short, but consider giving it a "fun" name that is more than just the name of the technology(ies) that the hack will cover.
  
### Introduction

This is your chance to sell the casual reader on why they should consider your hack. In a paragraph or two, consider answering the following questions:

- What technology(ies) or solution type(s) will it cover? 
- Why is this technology or solution important or relevant to the industry?
- What real world scenarios can this technology or solution be applied to?

### Learning Objectives

This is where you describe the outcomes a hack attendee should have. Provide a short list of key learnings you expect someone to come away with if they complete this hack.

### Challenges

Every WTH is made up of a collection of technical challenges. For the one pager, you should list out your challenges by name, with no more than a single sentence description for each (if the challenge title is not descriptive enough on its own).

For most this page will act as a "Table of Contents" for your hack. We recommend that you create links for each challenge to its respective page.

### Prerequisites

Provide a list of technical prerequisites for your hack here.  List out assumed knowledge attendees should have to be successful with the hack. For example, if the hack is an "Introduction to Kubernetes", the attendee should have a basic understanding of containers.  However, if it is an "Advanced Kubernetes" hack, then the attendee should know the basics of Kubernetes and not ask you what a "pod" or "node" are!

Provide a list of tools/software that the attendee needs to install on their machine to complete the hack. There is a list of common pre-requisites for many of the WTH hacks here: Shared WTH Prerequisites. You can provide a link to it in your hack's prerequisites section in addition to any unique prerequisites for your hack.

### Repository Contents (Optional)

While optional, it is a good idea to provide a catalog of the files you are providing with your hack. 

### Contributors

Finally, give yourself and your fellow hack authors some credit! List the names (and optionally contact info) for all of the authors that have contributed to this hack.

### Hack Description Template

To help you get started, we have provided a sample template for a hack's "one pager" here:
- [Hack Description Template](WTH-HackDescription-Template.md). 

Please copy this template into your hack's root folder, rename it to "Readme.md", and customize it for your hack.

## Challenge Design

Challenges are at the heart of the WTH format! Designing challenges is what a hack author should spend the majority of their time focusing on. 

There are different approaches to designing a hackathon. If you are familiar with the Marvel Comic Universe movies, you know that they follow one of two patterns:
- "Origin Story" - A movie focused on the back story of one superhero character that lets the audience get to know that character in depth (perhaps with a sidekick character or two included!)
- "Avengers Story" - A movie with an ensemble cast of superhero characters working together to solve a mega problem, with each character getting varying amounts of screen time. 

You can use the same patterns as Marvel when designing a What The Hack!

- Singleton Hack - A hack designed to give in-depth hands-on experience with a specific technology (perhaps with a "sidekick technology" or two included!)
- Solution Hack - A hack designed to give experience solving a real-world scenario that involves using multiple technolgies together for the solution.

Once you have decided what type of hack you want to create, you should follow these guidelines when designing the challenges:

- Include a “Challenge 0” that has attendees address pre-requisites for their workstation environment
- Challenge descriptions should be shorter than this section on how to design challenges! Keep it to a couple of sentences or bullet points stating the goal(s) and perhaps a hint at the skill(s) needed.
- Think through what skills/experience you want attendees to walk away with by completing each challenge
- Challenges should be cumulative, building upon each other
    - Establish Confidence – Start small and simple (think "hello world")
    - Build Competence – By having successively more complex challenges.	
- Each challenge should provide educational value.  
    - For example, if an attendee completes only 3 out of 7 challenges, he/she still walks away feeling satisfied that he/she has learned something
- Consider that a challenge might have more than one way to solve it! 
- Provide verifiable success criteria for each challenge that lets the coaches and attendees know they have completed it.
- Provide relevant links to learning resources that should lead the attendees toward the knowledge they need to complete the challenge.
- Do **NOT** provide a list of step-by-step instructions! These are challenges designed to make the attendees learn by solving problems, not blindly following instructions.

### Challenge Template
To help you get started, we have provided a sample markdown template for a hack Challenge here:
- [Challenge Template](WTH-Challenge-Template.md). 

Please copy this template into your hack's `../Student` folder, rename it to "ChallengeXX.md", where "XX" is the challenge number, and customize it for each challenge. 

**Note:** In each challenge's markdown file, you should create navigation links to/from the previous & next challenges. Please use relative links (i.e. `"/ChallengeXX.md"`) instead of absolute links (i.e. `"http://github.com/Microsoft/WhatTheHack/000-YourAwesomeHack/Student/ChallengeXX.md"`)  

## Student Resources

It is common to provide attendees with resources in order to complete the hack's challenges.  One example is to provide the code for an application that the hack's challenges are based on. Another example might be to provide sample code files, artifacts, or templates that provide guidance for completing the hack's challenges.

If your hack provides attendees with code or resources, it is recommended that you publish those resources as part of your hack's contents in the `../Student/Resources` folder.

During a WTH event, it is recommended to have attendees download any provided resources as a Zip file instead of having them clone the entire WTH repo onto their workstation. 

This has the benefit of not having to direct the attendees to the WTH repo during your hack. Remember, attendees can always find the WTH repo.  However, remind your attendees that they are cheating themselves if they go foraging around in the WTH repo for the answers!

### DownGit

One recommended way to enable attendees to easily download hack resources is using DownGit. DownGit is a clever utility that lets you create a download link to any GitHub public directory or file. 

You can view the DownGit project on GitHub here: https://github.com/MinhasKamal/DownGit

Or, you can use DownGit from its website here: https://minhaskamal.github.io/DownGit/#/home

To enable attendees to download hack resources using DownGit:
1. Publish your resources in the WTH repo under the `..Student/Resources` folder of your hack
2. Create a DownGit link to the "Resources" folder (or whatever sub-folder you want your attendees to download)
3. Use the DownGit link you created in your Challenge text to provide the link to the attendees.

### Pre-load Resources into Microsoft Teams

Another way to provide resource files to attendees is for the WTH event host to pre-load them into the Microsoft Teams team for the WTH event. 

To pre-load resources into the event team, the host should:
1. Use DownGit to download the Zip file of resources from the WTH repo.
2. Unpack the Zip file and upload its contents to the Files tab of the General team for the WTH event.
3. Direct users to download the resource files from Files tab in Microsot Teams.

## Presentation Lectures

You may be wondering why there is a section called "Presentation Lectures" when the whole point of What The Hack is to be hands-on and ***NOT*** be a "death by Power Point" snoozefest?!  

When you host a What The Hack event, there is always a kick off meeting where the attendees are welcomed and then introduced to the logistics of the hack. The best way to do that is with a *little* PowerPoint.

We have provided an Event Kickoff presentation template that you can customize for your hack and use to cover attendee logistics for a WTH event here:
- [Event Kickoff Presentation Template](WTH-Challenge-Template.md). 

After the kickoff meeting, its up to the hack authors if they want to provide any presentation lectures.  Some hack challenges are easy to jump right into.  Others are more complex and are better preceded by a brief introduction presentation.

It is OK and encouraged to offer a collection of "mini" presentation lectures if necessary for your hack's challenges. If you do provide a presentation lecture, consider these guidelines for each challenge:

- Try to keep lectures **<5-10 minutes** per challenge!
- Provide a brief overview of the challenge scenario & success criteria
- Provide a brief overview of concepts needed to complete the challenge
- Provide "reference" slides that you might not present, but have handy if attendees need additional guidance
- Provide slide with the challenge description that can be displayed when attendees are working on that challenge
- Review of each challenge’s solution to be presented after challenge completion

We have more guidance on how and when to deliver mini presentation lectures for your challenges during your event in the [How To Host a What The Hack](WTH-HowToHostAHack.md) guide.

Please store any presentations in your hack's `../Coach` folder.

## Coaches Guide

*PL: This is the original coaches' guide bullets from the PPT. Need to write this up with examples.*

- Coaches' guide should have:
    - List of high-level steps to the challenge answers/solutions
    - List of known blockers (things attendees will get hung up on) and recommended hints for solving them
    - List of key concepts that should be explained-to/understood by attendees before a given challenge
    - Estimated time for each challenge (NOT to be shared with attendees)
    - Suggested time a proctor should wait before helping out if a team is not progressing past known blockers
- Coaches' guide may optionally have:
    - Pre-requisites for the Azure environment if needed. 
        - Example: A VM image with Visual Studio or ML tools pre-installed. 
        - Example: An ARM template and/or script that builds out an environment that saves time on solving a challenge
    - Slides that proctors can reference to help when teaching a key concept
    - Scripts/templates/etc for some challenges that can be shared with attendees if they get really stuck
        - Example: If challenges 1-3 build something (i.e. an ARM template) that is needed for challenge 4, you could “give” a stuck team the template so they could skip to challenge 4.
    - List of reference links/articles/documentation that can be shared when attendees get stuck
- Proctor’s guide should be updated during & post event with key learnings on what worked, didn’t work, and unexpected blockers that came up.

## Coach Solutions

This is where you put "the answers". There are usually multiple ways to solve a WTH Challenge. The solutions you put here should be example solutions that represent one way to solve the challenges. The solutions might include a full working application, configuration files, populated templates, or other resources that can be used to demonstrate how to solve the challenges. 

**Note:** This content is not intended for hack attendees to see before or during a hack event. The content IS available publicly and thus an attendee can-- uh, WILL find it. It is important to stress to the attendees that they should not cheat themselves out of learning experience by looking at "the answers"!

## Preparing Your Environment

Okay, ready to get started creating your own What The Hack?

First we create a fork of the main WTH repo and then clone it to disk and create a branch to work in. The instructions below assume you have the git command line on your machine. If you're more comfortable in a GUI git client, you can use that too.
1. Create a fork of the WTH repo
   - Navigate to the WTH git repo at: https://aka.ms/wth
   - Click the Fork button at the top right of the page and then choose the account you want to create the fork in. 
2. Clone your new fork to your local machine
   - `git clone https://github.com/myname/WhatTheHack.git`
   - `cd WhatTheHack`
3. Create a new branch for your work. It is a best practice to never work directly on the master branch
   - `git branch MyWork`
   - `git checkout MyWork`
4. Add a new top level folder to the WTH repo using the next available number in sequence
   - `mkdir 067-IoTCentury`
5. Within your new folder, create the following directory structure:
	- `../Coach`
		- `/Solutions`
	- `../Student`
		- `/Resources`


### Files and Folders
You've already created the directory structure above, here is what each of them will contain:
- `../`
	- Hack Description (Readme.md)
- `../Coach`
	- The Coach's Guide, Lecture presentations, and any supporting files.
	- `/Solutions`
		- Solution code for the coach only. These are the answers and should not be shared with students.
- `../Student`
	- The Challenge markdown files
	- `/Resources` 
		- The code and supporting files the students will need throughout the hack.
