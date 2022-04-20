# Challenge 01 - Create a Linux Virtual Machine

**[Home](../README.md)** - [Next Challenge >](./Challenge-02.md)

## Pre-requisites 

- An active Azure Subscription.

## Description

To follow along you will need access to a server running a Linux-based operating system. Note that this fasthack was validated using a Linux server running Ubuntu 20.04 ([LTS](https://ubuntu.com/about/release-cycle)), but the examples given should work on any Linux distribution. See below the steps to follow to create your Linux Virtual Machine on Azure and choose that one with which you are more familiar.

During the process of creation of the VM, ensure the usage of **student** for the username with administrator rights over the virtual machine, just to make it easier during the challenges. 

To access the Linux Virtual Machine, you will need to have access to a terminal to connect over SSH.

The terms “terminal,” “shell,” and “command line interface” are often used interchangeably, but there are subtle differences between them:

* A terminal is an input and output environment that presents a text-only window running a shell.
* A shell is a program that exposes the computer’s operating system to a user or program. In Linux systems, the shell presented in a terminal is a command line interpreter.
* A command line interface is a user interface (managed by a command line interpreter program) which processes commands to a computer program and outputs the results.
When someone refers to one of these three terms in the context of Linux, they generally mean a terminal environment where you can run commands and see the results printed out to the terminal. 

Becoming a Linux expert requires you to be comfortable with using a terminal. Any administrative task, including file manipulation, package installation, and user management, can be accomplished through the terminal. The terminal is interactive: you specify commands to run and the terminal outputs the results of those commands. To execute any command, you type it into the prompt and press ENTER.

For our activites, it is recommended to use the [Azure Cloud Shell](http://shell.azure.com/).


## Success Criteria

* Validate you was able to successfully create your Ubuntu Linux Virtual Machine
* Confirm you can access through SSH

## Learning Resources

* [Create a Linux virtual machine in the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-portal)
* [Create a Linux virtual machine with the Azure CLI](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)
* [Create a Linux virtual machine in Azure with PowerShell](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-powershell)


