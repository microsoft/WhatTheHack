# What The Hack - Linux Fundamentals - Coach Guide

## Introduction
Welcome to the coach's guide for the Linux Fundamentals What The Hack. Here you will find links to specific guidance for coaches for each of the challenges.

**NOTE:** If you are a Hackathon participant, this is the answer guide. Don't cheat yourself by looking at these during the hack! Go learn something. :)

## Coach's Guides
* Challenge 01: **[Create a Linux Virtual Machine](../Coach/Solution-01.md)**
	 - A Linux Virtual machine is the prerequisite for the challenges, so create a new Ubuntu Linux VM
* Challenge 02: **[Handling Directories](../Coach/Solution-02.md)**
	 - Learn how to perform common directory operations such as displaying your current directory and listing directory contents.
* Challenge 03: **[Handling Files](../Coach/Solution-03.md)**
	 - Learn basic commands about file manipulation such as create, rename, find and remove files.
* Challenge 04: **[File Contents](../Coach/Solution-04.md)**
	 - Learn about file content manipulation and discover how to count file lines, display specific lines from a file, and more.
* Challenge 05: **[Standard File Permissions](../Coach/Solution-05.md)**
	 - Learn about the Linux standard file permissions and understand how to work with file permissioning on a Linux environment.
* Challenge 06: **[Process Management](../Coach/Solution-06.md)**
	 - Your objectives will involve basic process management, such as checking running processes and identifying process ids. 
* Challenge 07: **[Group and User Management](../Coach/Solution-07.md)**
	 - In this challenge you will learn about the creation of user and groups in a Linux environment.
* Challenge 08: **[Scripting](../Coach/Solution-08.md)**
	 - Learn some basic stuff on shell scripting and the usage of some commands such as echo, cut, read and grep.
* Challenge 09: **[Disks, Partitions and File Systems](../Coach/Solution-09.md)**
	 - You will be working with disks and partitions and learn about Linux filesystems and commands such as fdisk, mkfs and mount.
* Challenge 10: **[Logical Volume Manager](../Coach/Solution-10.md)**
	 - Discover about the Logical Volume Manager on Linux, and how to use commands such as pvcreate, vgcreate, lvrcreate, and more.
* Challenge 11: **[Package Management](../Coach/Solution-11.md)**
	 - Learn about package management and common activites such as update package distribution lists, install and uninstall packages.
* Challenge 12: **[Setting up a Webserver](../Coach/Solution-12.md)**
	 - In this challenge we will setting up a webserver and deploy a simple PHP application into it. The usage of SSL could be a plus.
* Challenge 13: **[Protecting a Server](../Coach/Solution-13.md)**
	- In this challenge we will discover about how to use Fail2Ban to protect services in a Linux environment.

## Coach Prerequisites 

This hack has pre-reqs that a coach is responsible for understanding and/or setting up BEFORE hosting an event. Please review the [What The Hack Hosting Guide](https://aka.ms/wthhost) for information on how to host a hack event.

The guide covers the common preparation steps a coach needs to do before any What The Hack event, including how to properly configure Microsoft Teams.

### Student Resources

Before the hack, it is the Coach's responsibility to download and package up the contents of the /Student/Resources folder of this hack into a "Resources.zip" file. The coach should then provide a copy of the Resources.zip file to all students at the start of the hack.

Always refer students to the [What The Hack website](https://aka.ms/wth) for the student guide: [https://aka.ms/wth](https://aka.ms/wth)

**NOTE:** Students should **not** be given a link to the What The Hack repo before or during a hack. The student guide does **NOT** have any links to the Coach's guide or the What The Hack repo on GitHub.  

## Azure Requirements

This hack requires students to have access to an Azure subscription where they can create and consume Azure resources. These Azure requirements should be shared with a stakeholder in the organization that will be providing the Azure subscription(s) that will be used by the students.

- For Challenge 01 an Azure subscription with contributor access will be required.
- For all other challenges, at least a contributor access to a pre-created Ubuntu Linux 20.04 virtual machine will be required.
- For the optional advanced challenge from Challenge 12, these are the requirements:
	- A public IP attached to the virtual machine
	- Access to the public IP of the virtual machine
	- Access to the Azure App Service Domain to get a domain or a acess to the DNS management of an existent domain

## Repository Contents

- `./Coach`
  - Coach's Guide and related files
- `./Coach/Solutions`
  - Solution files with completed example answers to a challenge
- `./Student`
  - Student's Challenge Guide
- `./Student/Resources`
  - Resource files, sample code, scripts, etc. meant to be provided to students. (Must be packaged up by the coach and provided to students at the start of event)
