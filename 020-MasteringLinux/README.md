# Welcome to the Mastering Linux Hack!

This FastHack will serves as an introduction to important command line concepts and skills to learn more about Linux.
<img align="right" src="images/linuxpenguin.png" width="250"/>

## Linux History 

Linux is a family of free and open-source operating systems based on the Linux kernel. Operating systems based on Linux are known as Linux distributions or distros. Examples include Debian, Ubuntu, Fedora, CentOS, Gentoo, Arch Linux, and many others.

The Linux kernel has been under active development since 1991, and has proven to be extremely versatile and adaptable. You can find computers that run Linux in a wide variety of contexts all over the world, from web servers to cell phones. Today, 90% of all cloud infrastructure and 74% of the world’s smartphones are powered by Linux.

To read more about Linux History, Linux Distributions and Linux Kernel, [click here](/resources/linux-history.md).


## Prerequisites

### :white_check_mark: A Linux Virtual Machine

To follow along you will need access to a server running a Linux-based operating system. Note that this fasthack was validated using a Linux server running Ubuntu 20.04 ([LTS](https://ubuntu.com/about/release-cycle)), but the examples given should work on any Linux distribution. See below the steps to follow to create your Linux Virtual Machine on Azure and choose that one with which you are more familiar.
* [Create a Linux virtual machine in the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal)
* [Create a Linux virtual machine with the Azure CLI](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)
* [Create a Linux virtual machine in Azure with PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-powershell)

_During the process of creation of the VM, ensure the usage of student for the username with administrator rights over the virtual machine, just to make it easier during the challenges._

### :white_check_mark: Access to a Terminal

The terms “terminal,” “shell,” and “command line interface” are often used interchangeably, but there are subtle differences between them:

* A terminal is an input and output environment that presents a text-only window running a shell.
* A shell is a program that exposes the computer’s operating system to a user or program. In Linux systems, the shell presented in a terminal is a command line interpreter.
* A command line interface is a user interface (managed by a command line interpreter program) which processes commands to a computer program and outputs the results.
When someone refers to one of these three terms in the context of Linux, they generally mean a terminal environment where you can run commands and see the results printed out to the terminal. 

Becoming a Linux expert requires you to be comfortable with using a terminal. Any administrative task, including file manipulation, package installation, and user management, can be accomplished through the terminal. The terminal is interactive: you specify commands to run and the terminal outputs the results of those commands. To execute any command, you type it into the prompt and press ENTER.

For our activites, is recommended to use the [Azure Cloud Shell](http://shell.azure.com/).

### :white_check_mark: Linux basic concepts

* There are some basic concepts that will be nice if you have them. If you would like to take a look they are [listed here](/resources/concepts.md).
* Concepts around the Linux Filesystem Hierarchy Standard (FHS) are recommended, so you can get more details about it [here](/resources/fhs.md).
* Regarding Linux commands, just for reference, [here is](/resources/commands.md) a good cheat sheet.

## Challenges

| Challenges |
|--------------|
| 1. [Handling directories](challenges/lab-working-directories.md)|
| 2. [Handling files](challenges/lab-working-files.md) |
| 3. [File contents](challenges/lab-file-contents.md) |
| 4. [Standard file permissions](challenges/lab-permissions.md) |
| 5. [Process management](challenges/lab-process-management.md) |
| 6. [Group and user management](challenges/lab-groups-and-users.md) |
| 7. [Scripting](challenges/lab-scripting.md) |
| 8. [Disks, partitions and file systems](challenges/lab-disks.md) |
| 9. [Logical Volume Mananager](challenges/lab-lvm.md) |
| 10. [Package management](challenges/lab-packages.md) |
| 11. [Setting up a webserver](challenges/lab-webserver.md) |



## Useful links / Study References

* [Linux Journey](https://linuxjourney.com/)
* [Linux Upskill Challenge](https://linuxupskillchallenge.org/)
* [Beginner's Guide for Linux - Tecmint](https://www.tecmint.com/free-online-linux-learning-guide-for-beginners/)
* [Preparation for Linux Foundation Certified System Adminsitrator](https://github.com/Bes0n/LFCS)
* [Linux Foundation Certified System Administrator (LFCS) Notes](https://github.com/simonesavi/lfcs)
* [The Linux Documentation Project](https://tldp.org/)
* [Intrduction to Linux - from TLPD](https://tldp.org/LDP/intro-linux/intro-linux.pdf)
* [Linux Commands Notes for Professionals](https://goalkicker.com/LinuxBook/LinuxNotesForProfessionals.pdf)
* [Introduction to Linux - Free course on Linux Foundation](https://training.linuxfoundation.org/training/introduction-to-linux/)

## Contributors

* [Ricardo Martins](https://www.linkedin.com/in/ricmmartins)

Contributions in the form of errors, feature requests and PRs are always welcome.

Please follow these steps before submitting a PR:

* Create an issue describing the error or feature request.
* Clone the repository and create a topic branch.
* Make changes, adding new tests for new functionality.
* Submit a PR.




