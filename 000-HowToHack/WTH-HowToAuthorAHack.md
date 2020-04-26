# How to Create and Contribute your What The Hack

Developing a new What The Hack is a great way to get your content out into the world. Chances are if you've done workshops or PoCs in the past, you already have the material on which to base a What The Hack.

## Why What The Hack
Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.

Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.

## What Should You Be Thinking Of
Nulla vitae ante turpis. Etiam tincidunt venenatis mauris, ac volutpat augue rutrum sed. Vivamus dignissim est sed dolor luctus aliquet. Vestibulum cursus turpis nec finibus commodo.

Vivamus venenatis accumsan neque non lacinia. Sed maximus sodales varius. Proin eu nulla nunc. Proin scelerisque ipsum in massa tincidunt venenatis. Nulla eget interdum nunc, in vehicula risus.


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

## Templates

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

Another way to provide any needed code or resource files to attendees is for the WTH event host to pre-load them into the Microsoft Teams team for the WTH event. 

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
