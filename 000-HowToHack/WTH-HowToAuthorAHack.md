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

##### DownGit

If your challenge requires attendees to download code or resources which you are publishing as part of the hack in the WTH repo, it is preferred to have them download those resources as a Zip file versus having them clone the entire repo onto their workstation.

One recommended way to do this is using DownGit:
- Publish your code/resources here in the WTH repo under the "student/resources" folder of your hack
- Create a DownGit link to the "resources" folder (or whatever sub-folder you want your attendees to download) https://minhaskamal.github.io/DownGit/#/home
- Use the DownGit link in your Challenge text to provide the link to the attendees.

This has the benefit of not having to direct the attendees to the WTH repo during your hack. As per usual, smart attendees can always find the WTH repo!  However, remind your attendees that they are cheating themselves if they go foraging around for the answers!

##### Pre-load Resources into Microsoft Teams

Another way to provide any needed code or resource files to attendees is for the WTH event host to pre-load them into the Microsoft Teams team for the WTH event. 

To pre-load resources into the event team, the host should:
- Use the DownGit link from the challenge to download the Zip file.
- Unpack the Zip file and upload its contents to the Files tab of the General team for the WTH event.


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
