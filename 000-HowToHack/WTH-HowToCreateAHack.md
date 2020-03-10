# How to Create and Contribute your What The Hack

Developing a new What The Hack is a great way to get your content out into the world. Chances are if you've done workshops or PoCs in the past, you already have the material on which to base a What The Hack.

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
