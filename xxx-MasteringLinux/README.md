# What The Hack - xxx-Mastering Linux

## Introduction
This hachathon will serve as an introduction to important command line concepts and skills on Linux environments.

<img align="right" src="./Student/resources/images/linuxpenguin.png" width="250"/>

## Linux History

Linux is a family of free and open-source operating systems based on the Linux kernel. Operating systems based on Linux are known as Linux distributions or distros. Examples include Debian, Ubuntu, Fedora, CentOS, Gentoo, Arch Linux, and many others.

The Linux kernel has been under active development since 1991, and has proven to be extremely versatile and adaptable. You can find computers that run Linux in a wide variety of contexts all over the world, from web servers to cell phones. Today, 90% of all cloud infrastructure and 74% of the world’s smartphones are powered by Linux.

To read more about Linux History, Linux Distributions and Linux Kernel, [click here](./Student/resources/linux-history.md).


## Learning Objectives
In this hack you will be challenged with some common tasks from a real world scenario in Linux administration duties, such as:

1. Create a Linux Virtual Machine on Azure
2. Handle files and directories
3. Maninpulate file contents
4. Work with standard linux permissions
5. Collect information about Linux process in your environment
6. Management of users and groups
7. Basic shell scripting 
8. Work with disks,  partitions and logical volume manager
9. Linux package management 
10. Implement a basic webserver 

## Challenges

With the exception of the **challenge 01** which the outcome of a Linux Virtual Machine will be required for all other challenges, each challenge can be done separately and they are not interdependent. The level of complexity increases accordingly with the respective number of each one.

1. Challenge 01: **[Create a Linux Virtual Machine](Student/Challenge-01.md)**
	 - A Linux Virtual machine is the prequise for the challenges, so create a new Ubuntu Linux VM
1. Challenge 02: **[Handling directories](Student/Challenge-02.md)**
	 - Learn how to perform common directory operations such as displaying your current directory and list directory contents.
1. Challenge 03: **[Handling files](Student/Challenge-03.md)**
	 - Learn basic commands about file manipulation such as create, rename, find and remove files.
1. Challenge 04: **[File contents](Student/Challenge-04.md)**
	 - Learn about file content manipulation and discover how to count file lines, display specific lines from a file, and more.
1. Challenge 05: **[Standard file permissions](Student/Challenge-05.md)**
	 - Learn about the Linux standard file permissions and understand how to work with file permissioning on a Linux environment.
1. Challenge 06: **[Process management](Student/Challenge-06.md)**
	 - Your objectives will involve basic process management, such as checking processes running and identifying process ids' 
1. Challenge 07: **[Group and user management](Student/Challenge-07.md)**
	 - In this challenge you will learn about the creation of user and groups in a Linux environment.
1. Challenge 08: **[Scripting](Student/Challenge-08.md)**
	 - Learn some basic stuff on shell scripting and the usage of some commands such as echo, cut, read and grep.
1. Challenge 09: **[Disks, partitions and file systems](Student/Challenge-09.md)**
	 - You will be working with disks and partitions and learn about linx filesystems and commands such as fdisk, mkfs and mount.
1. Challenge 10: **[Logical Volume Mananager](Student/Challenge-10.md)**
	 - Discover about the Logical Volume Manager on Linux, and how to use commands such as pvcreate, vgcreate, lvrcreate, and more.
1. Challenge 11: **[Package management](Student/Challenge-11.md)**
	 - Learn about package management and common activites related such as update package distribution lists, install and uninstall packages.
1. Challenge 12: **[Setting up a webserver](Student/Challenge-12.md)**
	 - In this challenge we will setting up a webserver and deploy a simple php application into it. 
	 
## Prerequisites
- Your own Azure subscription with contributor access 
- Access to a terminal. The terms “terminal,” “shell,” and “command line interface” are often used interchangeably, but there are subtle differences between them:

	* A terminal is an input and output environment that presents a text-only window running a shell.
	* A shell is a program that exposes the computer’s operating system to a user or program. In Linux systems, the shell presented in a terminal is a command line interpreter.
	* A command line interface is a user interface (managed by a command line interpreter program) which processes commands to a computer program and outputs the results.
When someone refers to one of these three terms in the context of Linux, they generally mean a terminal environment where you can run commands and see the results printed out to the terminal.

		Becoming a Linux expert requires you to be comfortable with using a terminal. Any administrative task, including file manipulation, package installation, and user management, can be accomplished through the terminal. The terminal is interactive: you specify commands to run and the terminal outputs the results of those commands. To execute any command, you type it into the prompt and press ENTER.

		For our activites, it is recommended to use the [Azure Cloud Shell](http://shell.azure.com/).


- There are some basic concepts that will be nice if you have them. If you would like to take a look they are [listed here](./Student/resources/concepts.md).
- Concepts around the Linux Filesystem Hierarchy Standard (FHS) are recommended, so you can get more details about it [here](./Student/resources/fhs.md).
- Regarding Linux commands, just for reference, [here is](./Student/resources/commands.md) a good cheat sheet.
- The Linux man pages are your best friend. Make sure to use as best you can.

## Repository Contents (Optional)
- `./Coach/Guides`
  - Coach's Guide and related files
- `./SteamShovel`
  - Image files and code for steam shovel microservice
- `./images`
  - Generic image files needed
- `./Student/Guides`
  - Student's Challenge Guide

## Contributors
- Ricardo Martins
