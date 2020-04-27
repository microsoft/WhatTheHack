# How to Create and Contribute your What The Hack

Developing a new What The Hack is a great way to get your content out into the world. Chances are if you've done workshops or PoCs in the past, you already have the material on which to base a What The Hack.

## Why What The Hack
Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.

Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.

## What Should You Be Thinking Of

When you design a WTH, these are the things you should be thinking of...

- Hack Description 
- Challenge Design
- Student Resources
- Coaches Guide

If you go in this order, you will be able to flush out a new hack rapidly!

## Hack Description (aka "One Pager")

Why should someone take the time to participate in your hack?  This is the main question you need to answer in order to define your hack. Each WTH needs to have a "one pager" that quickly describes your hack to those who will host or attend your hack. Think of this as your marketing pitch. 

The "one pager" can serve a dual purpose. If you take the time to write it first, it can be the outline or specification for your hack before you develop the actual content!

The "one pager" shall be the Readme.md that lives in the root of your hack's top level folder.

The "one pager" should include the following:

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

### Prerequisites

Provide a list of technical prerequisites for your hack here.  List out assumed knowledge attendees should have to be successful with the hack. For example, if the hack is an "Introduction to Kubernetes", the attendee should have a basic understanding of containers.  However, if it is an "Advanced Kubernetes" hack, then the attendee should know the basics of Kubernetes and not ask you what a "pod" or "node" are!

Provide a list of tools/software that the attendee needs to install on their machine to complete the hack. There is a list of common pre-requisites for many of the WTH hacks here: Shared WTH Prerequisites. You can provide a link to it in your hack's prerequisites section in addition to any unique prerequisites for your hack.

### Repository Contents (Optional)

While optional, it is a good idea to provide a catalog of the files you are providing with your hack. 

### Contributors

Finally, give yourself and your fellow hack authors some credit! List the names (and optionally contact info) for all of the authors that have contributed to this hack.

### Hack Design Template

To help you get started, we have provided a template for a hack's 'one pager' here <insert link here>. Please copy this template into your hack's root folder and customize it for your hack.


## Preparing Your Environment
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
		- `/Guides`
		- `/Solutions`
	- `../Student`
		- `/Guides`
		- `/Resources`

//## Templates

### Challenges
There is a challenge template, blah blah blah and follow these guidelines:
- Blah Blah
- Bling Bling
- Bleck Bleck

#### Student Resources

It is common to provide attendees with resources in order to complete the hack's challenges.  One example is to provide the code for an application that the hack's challenges are based on. Another example might be to provide sample code files, artifacts, or templates that provide guidance for completing the hack's challenges.

If your hack provides attendees with code or resources, it is recommended that you publish those resources as part of your hack's contents in the '../Students/Resources' folder.

During a WTH event, it is recommended to have attendees download any provided resources as a Zip file instead of having them clone the entire WTH repo onto their workstation. 

This has the benefit of not having to direct the attendees to the WTH repo during your hack. Remember, attendees can always find the WTH repo.  However, remind your attendees that they are cheating themselves if they go foraging around in the WTH repo for the answers!

##### DownGit

One recommended way to enable attendees to easily download hack resources is using DownGit. DownGit is a clever utility that lets you create a download link to any GitHub public directory or file. 

You can view the DownGit project on GitHub here: https://github.com/MinhasKamal/DownGit

Or, you can use DownGit from its website here: https://minhaskamal.github.io/DownGit/#/home

To enable attendees to download hack resources using DownGit:
1. Publish your resources in the WTH repo under the "..Student/Resources" folder of your hack
2. Create a DownGit link to the "Resources" folder (or whatever sub-folder you want your attendees to download)
3. Use the DownGit link you created in your Challenge text to provide the link to the attendees.

##### Pre-load Resources into Microsoft Teams

Another way to provide resource files to attendees is for the WTH event host to pre-load them into the Microsoft Teams team for the WTH event. 

To pre-load resources into the event team, the host should:
1. Use DownGit to download the Zip file of resources from the WTH repo.
2. Unpack the Zip file and upload its contents to the Files tab of the General team for the WTH event.
3. Direct users to download the resource files from Files tab in Microsot Teams.

### Coach's Guide
This is a template for the Coach's guide, blah blah blah and follow these guidelines when writing it:
- Blah Blah
- Bling Bling
- Bleck Bleck

### Files and Folders
You've already created the directory structure above, here is what each of them will contain:
- `../Coach`
	- `/Guides` 
		- The Coach's Guide and any supporting files.
	- `/Solutions`
		- Solution code for the coach only. These are the answers and should not be shared with students.
- `../Student`
	- `/Guides` 
		- The Coach's Guide and any supporting files.
	- `/Resources` 
		- The code and supporting files the students will need throughout the hack.
