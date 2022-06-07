# Challenge 03 - Handling files

[< Previous Challenge](./Challenge-02.md) - **[Home](../README.md)** - [Next Challenge >](./Challenge-04.md)

## Description

In this challenge you will learn basic commands about file manipulation such as create, rename, find and remove files.

- Find in the `/var` directory all the files that have been modified in the last 60 minutes
- Show the type of file of `/bin/htop`, `/etc/passwd` and `/usr/bin/passwd`
- Go to your home directory and download [azure-linux.svg](https://docs.microsoft.com/en-us/learn/achievements/azure-linux.svg)  and [azure-ops-guide.pdf](https://docsmsftpdfs.blob.core.windows.net/guides/azure/azure-ops-guide.pdf) 
- Display the type of file of `azure-linux.svg` and `azure-ops-guide.pdf`
- Rename `azure-linux.svg` to `azure-linux.pdf` 
- Display the type of file of `azure-linux.pdf` and `azure-ops-guide.pdf`
- Create a directory `~/lab` and enter it.
- Create the file `today.log` and the file `yesterday.log` in lab.
- Check the creation date and time
- Change the date on `yesterday.log` to match yesterday's date
- Check the creation date and time again
- Create a directory `~/mybackup` and copy all files from `~/lab` into it
- Use one command to remove the directory `~/mybackup` and all files under it
- Create a directory `~/logbackup` and copy the `*.log` files from `/var/log` into it
- Count the number of times 'linux' appears in the file `/etc/wgetrc`
- Count the number of words from the file `/etc/hdparm.conf`

## Success Criteria

1. Show all the files that have been modified in the last 60 minutes within `/var`
2. Make sure you checked the different file types of the files `/bin/htop`, `/etc/passwd` and `/usr/bin/passwd`
3. Confirm the different file types 
4. After the renaming of the extension, check if the file type was changed
5. Make sure you have changed the date properly to yesterday's date
6. Confirm if the creation date and time were defined as expected
7. Validate if the all files from `~/lab` were sucessfully placed into `~/mybackup`
8. Make sure if you were able to remove everything using just one command 
9. Show all log files copied from `/var/log` into `~/logbackup`
10. Confirm how many lines exist in `/etc/wgetrc`
11. Confirm how many words exist in `/etc/hdparm.conf`

## Learning Resources

- [The Shell](https://linuxjourney.com/lesson/the-shell)
