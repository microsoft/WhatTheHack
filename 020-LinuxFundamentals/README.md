# What The Hack - Linux Fundamentals

## Introduction
This hackathon will serve as an introduction to important command line concepts and skills on Linux environments.

<img align="right" src="./Student/resources/images/linuxpenguin.png" width="250"/>

## Linux History

Linux is a family of free and open-source operating systems based on the Linux kernel. Operating systems based on Linux are known as Linux distributions or distros. Examples include Debian, Ubuntu, Fedora, CentOS, Gentoo, Arch Linux, and many others.

The Linux kernel has been under active development since 1991 and has proven to be extremely versatile and adaptable. You can find computers that run Linux in a wide variety of contexts all over the world, from web servers to cell phones. Today, 90% of all cloud infrastructure and 74% of the world’s smartphones are powered by Linux.

To read more about Linux History, Linux Distributions and Linux Kernel, [click here](./Student/resources/linux-history.md).


## Learning Objectives
In this hack you will be challenged with some common tasks from a real world scenario in Linux administration duties, such as:

1. Create a Linux Virtual Machine on Azure
2. Handle files and directories
3. Maninpulate file contents
4. Work with standard Linux permissions
5. Collect information about Linux processes in your environment
6. Management of users and groups
7. Basic shell scripting 
8. Work with disks, partitions and logical volume manager
9. Linux package management 
10. Implement a basic webserver 

## Challenges

With the exception of challenge 01 which has as an outcome a Linux Virtual Machine which will be required for all other challenges, each challenge can be done separately and they are not interdependent. The level of complexity increases accordingly with the respective number of each one.

* Challenge 01: **[Create a Linux Virtual Machine](Student/Challenge-01.md)**
	 - A Linux Virtual machine is the prerequisite for the challenges, so create a new Ubuntu Linux VM
* Challenge 02: **[Handling Directories](Student/Challenge-02.md)**
	 - Learn how to perform common directory operations such as displaying your current directory and listing directory contents.
* Challenge 03: **[Handling Files](Student/Challenge-03.md)**
	 - Learn basic commands about file manipulation such as create, rename, find and remove files.
* Challenge 04: **[File Contents](Student/Challenge-04.md)**
	 - Learn about file content manipulation and discover how to count file lines, display specific lines from a file, and more.
* Challenge 05: **[Standard File Permissions](Student/Challenge-05.md)**
	 - Learn about the Linux standard file permissions and understand how to work with file permissioning on a Linux environment.
* Challenge 06: **[Process Management](Student/Challenge-06.md)**
	 - Your objectives will involve basic process management, such as checking processes running and identifying process ids. 
* Challenge 07: **[Group and User Management](Student/Challenge-07.md)**
	 - In this challenge you will learn about the creation of user and groups in a Linux environment.
* Challenge 08: **[Scripting](Student/Challenge-08.md)**
	 - Learn some basic stuff on shell scripting and the usage of some commands such as echo, cut, read and grep.
* Challenge 09: **[Disks, Partitions and File Systems](Student/Challenge-09.md)**
	 - You will be working with disks and partitions and learn about linx filesystems and commands such as fdisk, mkfs and mount.
* Challenge 10: **[Logical Volume Manager](Student/Challenge-10.md)**
	 - Discover about the Logical Volume Manager on Linux, and how to use commands such as pvcreate, vgcreate, lvrcreate, and more.
* Challenge 11: **[Package Management](Student/Challenge-11.md)**
	 - Learn about package management and common activites such as update package distribution lists, install and uninstall packages.
* Challenge 12: **[Setting up a Webserver](Student/Challenge-12.md)**
	 - In this challenge we will setting up a webserver and deploy a simple PHP application into it. The usage of SSL could be a plus. 
* Challenge 13: **[Protecting a Server](Student/Challenge-13.md)**
	- In this challenge we will discover about how to use Fail2Ban to protect services in a Linux environment.
	 
## Prerequisites
- Your own Azure subscription with contributor access for the Challenge 01 or contributor access to a pre-created Azure Virtual Machine for all other challenges.
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

## Learning Resources

* [Linux Journey](https://linuxjourney.com/)
* [Linux Upskill Challenge](https://linuxupskillchallenge.org/)
* [Beginner's Guide for Linux - Tecmint](https://www.tecmint.com/free-online-linux-learning-guide-for-beginners/)
* [Preparation for Linux Foundation Certified System Adminsitrator](https://github.com/Bes0n/LFCS)
* [Linux Foundation Certified System Administrator (LFCS) Notes](https://github.com/simonesavi/lfcs)
* [The Linux Documentation Project](https://tldp.org/)
* [Intrduction to Linux - from TLPD](https://tldp.org/LDP/intro-linux/intro-linux.pdf)
* [Linux Commands Notes for Professionals](https://goalkicker.com/LinuxBook/LinuxNotesForProfessionals.pdf)
* [Introduction to Linux - Free course on Linux Foundation](https://training.linuxfoundation.org/training/introduction-to-linux/)

## Feedback
Please [share](https://forms.office.com/r/1W73Y1rrxu) your experience during this Linux Hackathon and help us to improve.

## Contributors
- Ricardo Martins
